import 'package:injectable/injectable.dart';

import '../../../home/data/client/binance_futures_client.dart';
import '../../../home/data/models/candle.dart';
import '../../../home/data/models/coin_model.dart';
import '../../../home/data/repository/candles_repository.dart';
import '../coin_filter.dart';
import 'key_level.dart';
import 'key_level_detector.dart';

/// Монеты, цена которых стоит на реально сильном уровне или подходит к нему
/// и ещё его не касалась. Уровни — по 4ч свечам Binance Futures, цена — текущая
/// цена того же фьючерса (у CoinGecko она может отставать на минуты).
@lazySingleton
class KeyLevelFilter implements DetailedCoinFilter {
  KeyLevelFilter(this._binance, this._candles);

  final BinanceFuturesClient _binance;
  final CandlesRepositoryI _candles;
  final _detector = const KeyLevelDetector();

  // Касание за последние 8 часов (часовые свечи вместе с текущей).
  static const int _recentHours = 8;
  static const Duration _recentTtl = Duration(seconds: 30);

  // Уровни меняются только с новой 4ч свечой: считаем раз на список свечей.
  final _analysisCache = Expando<LevelAnalysis>();
  final _recentCache = <String, ({List<Candle> candles, DateTime at})>{};

  Map<String, KeyLevel> _details = const {};

  /// Уровень для каждой монеты из последнего результата, по id монеты.
  @override
  Map<String, KeyLevel> get details => _details;

  @override
  Future<List<CoinModel>> filter(List<CoinModel> coins) async {
    final symbols = await _binance.perpetualSymbols();
    final contracts = [
      for (final coin in coins)
        if (BinanceFuturesClient.contractFor(coin.symbol, symbols)
            case final contract?)
          (coin: coin, symbol: contract.symbol, scale: contract.scale),
    ];
    final candles = await _candles.closedCandles(
      contracts.map((c) => c.symbol),
      interval: '4h',
      limit: KeyLevelDetector.candlesLimit,
    );
    final prices = await _binance.lastPrices();

    final details = <String, KeyLevel>{};
    for (final (:coin, :symbol, :scale) in contracts) {
      final history = candles[symbol];
      final price = prices[symbol];
      if (history == null || price == null) continue;
      final analysis = _analysisCache[history] ??= _detector.analyze(history);
      if (analysis == null) continue;
      final nearest = _detector.nearest(analysis, price);
      if (nearest == null ||
          nearest.distanceAtr > KeyLevelDetector.approachAtr) {
        continue;
      }
      final isAtLevel = nearest.distanceAtr <= KeyLevelDetector.atLevelAtr;
      if (!isAtLevel &&
          _detector.touchedRecently(
            nearest.level,
            price,
            analysis.atr,
            await _recent(symbol),
          )) {
        continue;
      }
      final corridor = _detector.corridor(history, analysis, price);
      // Уровни считаются в цене контракта, в списке — в цене монеты.
      details[coin.id] = KeyLevel(
        price: nearest.level.price / scale,
        touches: nearest.level.touches,
        avgBouncePercent: nearest.level.avgBouncePercent,
        isResistance: nearest.level.price > price,
        isAtLevel: isAtLevel,
        distancePercent: (nearest.level.price - price).abs() / price * 100,
        corridor: corridor == null
            ? null
            : (low: corridor.low / scale, high: corridor.high / scale),
      );
    }
    _details = details;
    return coins.where((c) => details.containsKey(c.id)).toList()..sort(
      (a, b) => details[a.id]!.distancePercent.compareTo(
        details[b.id]!.distancePercent,
      ),
    );
  }

  Future<List<Candle>> _recent(String symbol) async {
    final cached = _recentCache[symbol];
    if (cached != null && DateTime.now().difference(cached.at) < _recentTtl) {
      return cached.candles;
    }
    final candles = await _binance.recentKlines(
      symbol,
      interval: '1h',
      limit: _recentHours,
    );
    _recentCache[symbol] = (candles: candles, at: DateTime.now());
    return candles;
  }
}
