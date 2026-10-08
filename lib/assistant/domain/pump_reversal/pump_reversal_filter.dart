import 'package:injectable/injectable.dart';

import '../../../home/data/client/binance_futures_client.dart';
import '../../../home/data/models/candle.dart';
import '../../../home/data/models/coin_model.dart';
import '../../data/signal_journal_repository.dart';
import '../coin_filter.dart';
import 'pump_reversal_detector.dart';
import 'pump_reversal_status.dart';
import 'signal_record.dart';

/// Разворот после пампа (шорт на 3–4 часа).
///
/// Монета попадает в список, если на последней закрытой 15m свече сработал
/// паттерн [PumpReversalDetector] и одновременно:
///  * BTC за 30 дней упал — на растущем рынке пампы чаще продолжаются;
///  * рынок за последний час снижается.
/// В бэктесте рынок — медиана топ-150 фьючерсов Binance за 1ч, здесь —
/// медиана изменения за 1ч монет из списка CoinGecko (близкая замена).
///
/// Все сработавшие паттерны пишутся в журнал, в том числе отсеянные
/// фильтрами, чтобы на новых данных было видно, помогают ли фильтры.
@lazySingleton
class PumpReversalFilter implements CoinFilter {
  PumpReversalFilter(this._binance, this._journal);

  final BinanceFuturesClient _binance;
  final SignalJournalRepositoryI _journal;
  final _detector = const PumpReversalDetector();

  // Без запроса свечей отсекаем монеты, которые не могли перегреться:
  // перегрев >= 3 дневных ходов при ходе >= 1% — это рост от 3% за 24ч
  // (берём 2.5% с запасом на разницу CoinGecko и Binance).
  static const double _minChange24hPercent = 2.5;
  static const int _klinesLimit = 700;
  static const int _btcTrendHours = 24 * 30;
  static const Duration _bar = Duration(minutes: 15);
  // Binance публикует закрытую свечу с небольшой задержкой.
  static const Duration _publishDelay = Duration(seconds: 5);

  final _candlesCache =
      <String, ({List<Candle> candles, DateTime validUntil})>{};
  ({double value, DateTime validUntil})? _btcCache;

  PumpReversalStatus? _status;

  /// Режим рынка на момент последнего прогона фильтра.
  PumpReversalStatus? get status => _status;

  @override
  Future<List<CoinModel>> filter(List<CoinModel> coins) async {
    final status = PumpReversalStatus(
      btcChange30d: await _btcChange30d(),
      marketChange1h: _median(
        coins.map((c) => c.priceChangePercentage1h).whereType<double>(),
      ),
    );
    _status = status;

    final symbols = await _binance.perpetualSymbols();
    final candidates = <(CoinModel, String)>[
      for (final coin in coins)
        if ((coin.priceChangePercentage24h ?? 0) >= _minChange24hPercent)
          if (BinanceFuturesClient.contractFor(coin.symbol, symbols)
              case final contract?)
            (coin, contract.symbol),
    ];
    final signals = await Future.wait(
      candidates.map((c) => _detect(c.$1, c.$2, status)),
    );

    final result = <CoinModel>[];
    for (final signal in signals.whereType<SignalRecord>()) {
      await _journal.add(signal);
      if (signal.passedFilters) {
        result.add(candidates.firstWhere((c) => c.$2 == signal.symbol).$1);
      }
    }
    return result;
  }

  Future<SignalRecord?> _detect(
    CoinModel coin,
    String symbol,
    PumpReversalStatus status,
  ) async {
    final candles = await _candles(symbol);
    final setup = _detector.detect(candles);
    if (setup == null) return null;
    return SignalRecord(
      coinId: coin.id,
      name: coin.name,
      symbol: symbol,
      setup: setup,
      entryTime: candles.last.closeTime + 1,
      signalPrice: candles.last.close,
      high24h: _detector.high24h(candles),
      passedFilters: status.isActive,
    );
  }

  // Свечи меняются только с закрытием новой 15m свечи — до него берём кэш.
  Future<List<Candle>> _candles(String symbol) async {
    final cached = _candlesCache[symbol];
    if (cached != null && DateTime.now().isBefore(cached.validUntil)) {
      return cached.candles;
    }
    final candles = await _binance.closedKlines(
      symbol,
      interval: '15m',
      limit: _klinesLimit,
    );
    if (candles.isNotEmpty) {
      _candlesCache[symbol] = (
        candles: candles,
        validUntil: _nextUpdate(candles.last, _bar),
      );
    }
    return candles;
  }

  Future<double> _btcChange30d() async {
    final cached = _btcCache;
    if (cached != null && DateTime.now().isBefore(cached.validUntil)) {
      return cached.value;
    }
    final candles = await _binance.closedKlines(
      'BTCUSDT',
      interval: '1h',
      limit: _btcTrendHours + 2,
    );
    final now = candles.last.close;
    final monthAgo = candles[candles.length - 1 - _btcTrendHours].close;
    final value = (now / monthAgo - 1) * 100;
    _btcCache = (
      value: value,
      validUntil: _nextUpdate(candles.last, const Duration(hours: 1)),
    );
    return value;
  }

  static DateTime _nextUpdate(Candle last, Duration interval) =>
      DateTime.fromMillisecondsSinceEpoch(
        last.closeTime + 1,
      ).add(interval + _publishDelay);

  static double _median(Iterable<double> values) {
    final sorted = values.toList()..sort();
    if (sorted.isEmpty) return 0;
    final mid = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[mid]
        : (sorted[mid - 1] + sorted[mid]) / 2;
  }
}
