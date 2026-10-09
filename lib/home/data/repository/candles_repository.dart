import 'package:injectable/injectable.dart';

import '../client/binance_futures_client.dart';
import '../models/candle.dart';

/// Закрытые свечи Binance Futures с кэшем до закрытия следующей свечи:
/// общие для фильтров, чтобы не качать одни и те же свечи дважды.
@LazySingleton(as: CandlesRepositoryI)
class CandlesRepository extends CandlesRepositoryI {
  CandlesRepository(this._binance);

  final BinanceFuturesClient _binance;

  static const int _parallelRequests = 10;
  // Binance публикует закрытую свечу с небольшой задержкой.
  static const Duration _publishDelay = Duration(seconds: 5);
  static const _intervals = {
    '1h': Duration(hours: 1),
    '4h': Duration(hours: 4),
  };

  final _cache = <String, ({List<Candle> candles, DateTime validUntil})>{};

  @override
  Future<Map<String, List<Candle>>> closedCandles(
    Iterable<String> symbols, {
    required String interval,
    required int limit,
  }) async {
    final duration = _intervals[interval];
    if (duration == null) throw ArgumentError.value(interval, 'interval');
    final unique = symbols.toSet().toList();
    final now = DateTime.now();
    final stale = unique.where((s) {
      final cached = _cache[_key(s, interval, limit)];
      return !(cached?.validUntil.isAfter(now) ?? false);
    }).toList();
    for (var i = 0; i < stale.length; i += _parallelRequests) {
      await Future.wait(
        stale
            .skip(i)
            .take(_parallelRequests)
            .map((s) => _load(s, interval, limit, duration)),
      );
    }
    return {
      for (final symbol in unique)
        if (_cache[_key(symbol, interval, limit)] case final cached?)
          symbol: cached.candles,
    };
  }

  Future<void> _load(
    String symbol,
    String interval,
    int limit,
    Duration duration,
  ) async {
    final candles = await _binance.closedKlines(
      symbol,
      interval: interval,
      limit: limit,
    );
    if (candles.isEmpty) return;
    _cache[_key(symbol, interval, limit)] = (
      candles: candles,
      validUntil: DateTime.fromMillisecondsSinceEpoch(
        candles.last.closeTime + 1,
      ).add(duration + _publishDelay),
    );
  }

  static String _key(String symbol, String interval, int limit) =>
      '$symbol|$interval|$limit';
}

abstract class CandlesRepositoryI {
  /// Закрытые свечи по контрактам; без данных — контракта нет в ответе.
  Future<Map<String, List<Candle>>> closedCandles(
    Iterable<String> symbols, {
    required String interval,
    required int limit,
  });
}
