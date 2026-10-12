import 'package:injectable/injectable.dart';

import '../../../home/data/client/binance_futures_client.dart';
import '../../../home/data/models/coin_model.dart';
import '../../../home/data/repository/candles_repository.dart';
import '../coin_filter.dart';
import '../key_levels/key_level_detector.dart';
import 'level_approach.dart';
import 'level_radar.dart';

/// Монеты на сильном уровне с крупным объёмом на отскоках или вплотную к нему
/// (< 1%).
@lazySingleton
class LevelRadarFilter implements DetailedCoinFilter {
  LevelRadarFilter(this._binance, this._candles);

  final BinanceFuturesClient _binance;
  final CandlesRepositoryI _candles;
  final _detector = const KeyLevelDetector();
  final _radar = const LevelRadar();

  // Уровни меняются только с новой 4ч свечой: считаем раз на список свечей.
  final _analysisCache = Expando<LevelAnalysis>();

  Map<String, LevelApproach> _details = const {};

  @override
  Map<String, LevelApproach> get details => _details;

  @override
  Future<List<CoinModel>> filter(List<CoinModel> coins) async {
    final symbols = await _binance.perpetualSymbols();
    final contracts = [
      for (final coin in coins)
        if (BinanceFuturesClient.contractFor(coin.symbol, symbols)
            case final contract?)
          (coin: coin, symbol: contract.symbol, scale: contract.scale),
    ];
    final names = contracts.map((c) => c.symbol);
    final candles4h = await _candles.closedCandles(
      names,
      interval: '4h',
      limit: KeyLevelDetector.candlesLimit,
    );
    final hourly = await _candles.closedCandles(
      names,
      interval: '1h',
      limit: LevelRadar.hourlyCandles,
    );
    final prices = await _binance.lastPrices();

    final details = <String, LevelApproach>{};
    for (final (:coin, :symbol, :scale) in contracts) {
      final history = candles4h[symbol];
      final lastHours = hourly[symbol];
      final price = prices[symbol];
      if (history == null || lastHours == null || price == null) continue;
      final analysis = _analysisCache[history] ??= _detector.analyze(history);
      if (analysis == null) continue;
      final approach = _radar.approach(
        analysis: analysis,
        hourly: lastHours,
        price: price,
      );
      if (approach == null) continue;
      // Уровень считается в цене контракта, в списке — в цене монеты.
      details[coin.id] = LevelApproach(
        levelPrice: approach.levelPrice / scale,
        isResistance: approach.isResistance,
        isAtLevel: approach.isAtLevel,
        touches: approach.touches,
        avgBouncePercent: approach.avgBouncePercent,
        volumeMultiple: approach.volumeMultiple,
        distancePercent: approach.distancePercent,
      );
    }
    _details = details;
    // Сначала монеты уже на уровне, затем самые близкие.
    return coins.where((c) => details.containsKey(c.id)).toList()..sort((a, b) {
      final x = details[a.id]!;
      final y = details[b.id]!;
      if (x.isAtLevel != y.isAtLevel) return x.isAtLevel ? -1 : 1;
      return x.distancePercent.compareTo(y.distancePercent);
    });
  }
}
