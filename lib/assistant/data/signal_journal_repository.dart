import 'dart:convert';
import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/data/client/binance_futures_client.dart';
import '../../home/data/models/candle.dart';
import '../domain/pump_reversal/signal_record.dart';

/// Журнал сигналов разворота: проверка формулы на новых данных.
/// Результат шорта считается по свечам Binance так же, как в бэктесте:
/// вход по открытию следующей 15m свечи, аварийный стоп на 4% выше
/// максимума за 24ч, издержки 0.2% на сделку.
@LazySingleton(as: SignalJournalRepositoryI)
class SignalJournalRepository extends SignalJournalRepositoryI {
  SignalJournalRepository(this._preferences, this._binance);

  final SharedPreferences _preferences;
  final BinanceFuturesClient _binance;

  static const _storageKey = 'pump_reversal_journal';
  static const _maxRecords = 500;
  static const _horizonsHours = [1, 2, 3, 4];
  static const _barsPerHour = 4;
  static const _costPercent = 0.2;
  static const _stopAboveHigh = 1.04;
  // Повторный сигнал по той же монете раньше конца сделки не записываем.
  static const _cooldown = Duration(hours: 4);

  @override
  List<SignalRecord> records() {
    final raw = _preferences.getString(_storageKey);
    if (raw == null) return const [];
    return (jsonDecode(raw) as List<dynamic>)
        .map((e) => SignalRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> add(SignalRecord record) async {
    final all = records();
    final hasRecent = all.any(
      (r) =>
          r.symbol == record.symbol &&
          (record.entryTime - r.entryTime).abs() < _cooldown.inMilliseconds,
    );
    if (hasRecent) return;
    await _save([record, ...all]);
  }

  @override
  Future<List<SignalRecord>> resolvePending() async {
    final all = records();
    final holdMs = _horizonsHours.last * Duration.millisecondsPerHour;
    final now = DateTime.now().millisecondsSinceEpoch;
    var changed = false;
    final updated = <SignalRecord>[];
    for (final record in all) {
      if (record.isResolved || now < record.entryTime + holdMs) {
        updated.add(record);
        continue;
      }
      final results = await _shortResults(record);
      changed |= results != null;
      updated.add(results == null ? record : record.copyWith(results: results));
    }
    if (changed) await _save(updated);
    return updated;
  }

  Future<Map<int, double>?> _shortResults(SignalRecord record) async {
    final bars = _horizonsHours.last * _barsPerHour;
    final candles = await _binance.closedKlines(
      record.symbol,
      interval: '15m',
      limit: bars,
      startTime: record.entryTime,
    );
    if (candles.length < bars) return null;
    final stop = record.high24h * _stopAboveHigh;
    return {
      for (final hours in _horizonsHours)
        hours: _shortReturn(candles.take(hours * _barsPerHour).toList(), stop),
    };
  }

  // Выход по закрытию последней свечи или по стопу (с учётом гэпа на open).
  double _shortReturn(List<Candle> candles, double stop) {
    final entry = candles.first.open;
    var exit = candles.last.close;
    for (final candle in candles) {
      if (candle.high >= stop) {
        exit = max(candle.open, stop);
        break;
      }
    }
    return (entry - exit) / entry * 100 - _costPercent;
  }

  Future<void> _save(List<SignalRecord> records) {
    final trimmed = records.take(_maxRecords).map((r) => r.toJson()).toList();
    return _preferences.setString(_storageKey, jsonEncode(trimmed));
  }
}

abstract class SignalJournalRepositoryI {
  List<SignalRecord> records();

  Future<void> add(SignalRecord record);

  /// Досчитывает результаты сигналов, по которым прошло 4 часа.
  Future<List<SignalRecord>> resolvePending();
}
