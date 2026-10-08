import 'package:injectable/injectable.dart';

import '../../../home/data/client/binance_futures_client.dart';
import '../../../home/data/models/coin_model.dart';
import '../../../home/data/repository/hourly_candles_repository.dart';
import '../coin_filter.dart';
import 'overbought_detector.dart';
import 'overbought_signal.dart';

/// Сильно перегретые монеты (RSI 80+), у которых уходит ликвидность.
@lazySingleton
class OverboughtFilter implements DetailedCoinFilter {
  OverboughtFilter(this._binance, this._candles);

  final BinanceFuturesClient _binance;
  final HourlyCandlesRepositoryI _candles;
  final _detector = const OverboughtDetector();

  // Без запроса свечей отсекаем монеты, которые не могли перегреться:
  // рост >= 2 дневных хода при ходе >= 1% — это от 2% за 24ч
  // (берём 1.5% с запасом на разницу CoinGecko и Binance).
  static const double _minChange24hPercent = 1.5;

  Map<String, OverboughtSignal> _details = const {};

  /// Показатели перегрева для каждой монеты из последнего результата.
  @override
  Map<String, OverboughtSignal> get details => _details;

  @override
  Future<List<CoinModel>> filter(List<CoinModel> coins) async {
    final symbols = await _binance.perpetualSymbols();
    final contracts = [
      for (final coin in coins)
        if ((coin.priceChangePercentage24h ?? 0) >= _minChange24hPercent)
          if (BinanceFuturesClient.contractFor(coin.symbol, symbols)
              case final contract?)
            (coin: coin, symbol: contract.symbol),
    ];
    final candles = await _candles.closedCandles(
      contracts.map((c) => c.symbol),
    );

    final details = <String, OverboughtSignal>{};
    for (final (:coin, :symbol) in contracts) {
      final history = candles[symbol];
      if (history == null) continue;
      if (_detector.detect(history) case final signal?) {
        details[coin.id] = signal;
      }
    }
    _details = details;
    return coins.where((c) => details.containsKey(c.id)).toList()
      ..sort((a, b) => details[b.id]!.rsi.compareTo(details[a.id]!.rsi));
  }
}
