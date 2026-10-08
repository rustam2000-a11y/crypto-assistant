import 'package:injectable/injectable.dart';

import '../../../home/data/client/binance_futures_client.dart';
import '../../../home/data/models/coin_model.dart';
import '../../../home/data/repository/hourly_candles_repository.dart';
import '../coin_filter.dart';
import 'key_level.dart';
import 'key_level_detector.dart';

/// Монеты, цена которых подошла к сильному уровню сверху или снизу.
/// Уровни считаются по часовым свечам Binance Futures, расстояние — по живой
/// цене монеты.
@lazySingleton
class KeyLevelFilter implements DetailedCoinFilter {
  KeyLevelFilter(this._binance, this._candles);

  final BinanceFuturesClient _binance;
  final HourlyCandlesRepositoryI _candles;
  final _detector = const KeyLevelDetector();

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
    );

    final details = <String, KeyLevel>{};
    for (final (:coin, :symbol, :scale) in contracts) {
      final history = candles[symbol];
      if (history == null) continue;
      // Уровни считаются в цене контракта, результат — в цене монеты.
      final level = _detector.nearestLevel(history, coin.currentPrice * scale);
      if (level == null) continue;
      details[coin.id] = KeyLevel(
        price: level.price / scale,
        touches: level.touches,
        isResistance: level.isResistance,
        distancePercent: level.distancePercent,
        corridor: level.corridor == null
            ? null
            : (
                low: level.corridor!.low / scale,
                high: level.corridor!.high / scale,
              ),
      );
    }
    _details = details;
    return coins.where((c) => details.containsKey(c.id)).toList()..sort(
      (a, b) => details[a.id]!.distancePercent.compareTo(
        details[b.id]!.distancePercent,
      ),
    );
  }
}
