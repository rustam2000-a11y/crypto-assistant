import 'package:injectable/injectable.dart';

import '../../../home/data/client/binance_futures_client.dart';
import '../../../home/data/models/coin_model.dart';
import '../../../home/data/repository/candles_repository.dart';
import '../coin_filter.dart';
import '../key_levels/key_level_detector.dart';
import 'overload_detector.dart';
import 'overload_signal.dart';

/// Монеты с 3+ из 7 признаков перегрузки (перегрев цены и плеч).
@lazySingleton
class OverloadFilter implements DetailedCoinFilter {
  OverloadFilter(this._binance, this._candles);

  final BinanceFuturesClient _binance;
  final CandlesRepositoryI _candles;
  final _detector = const OverloadDetector();

  // Те же часовые и 4ч свечи, что у других фильтров, — общий кэш.
  static const int _hourlyLimit = 540;
  static const int _parallelRequests = 10;
  // Плечи и фандинг меняются медленно — не дёргаем Binance на каждый прогон.
  static const Duration _leverageTtl = Duration(minutes: 10);
  static const Duration _fundingTtl = Duration(minutes: 1);

  final _leverageCache =
      <String, ({double? openInterest, double? topRatio, DateTime at})>{};
  ({Map<String, double> rates, DateTime at})? _funding;

  Map<String, OverloadSignal> _details = const {};

  @override
  Map<String, OverloadSignal> get details => _details;

  @override
  Future<List<CoinModel>> filter(List<CoinModel> coins) async {
    final symbols = await _binance.perpetualSymbols();
    final contracts = [
      for (final coin in coins)
        if (BinanceFuturesClient.contractFor(coin.symbol, symbols)
            case final contract?)
          (coin: coin, symbol: contract.symbol),
    ];
    final names = contracts.map((c) => c.symbol);
    final hourly = await _candles.closedCandles(
      names,
      interval: '1h',
      limit: _hourlyLimit,
    );
    final candles4h = await _candles.closedCandles(
      names,
      interval: '4h',
      limit: KeyLevelDetector.candlesLimit,
    );
    final funding = await _fundingRates();

    // Плечи нужны только разогнанным монетам.
    final stretched = [
      for (final c in contracts)
        if (hourly[c.symbol] case final h? when _detector.stretch(h) != null) c,
    ];
    await _loadLeverage(stretched.map((c) => c.symbol).toList());

    final details = <String, OverloadSignal>{};
    for (final (:coin, :symbol) in stretched) {
      final leverage = _leverageCache[symbol];
      final signal = _detector.detect(
        hourly: hourly[symbol]!,
        candles4h: candles4h[symbol] ?? const [],
        openInterestChange: leverage?.openInterest,
        fundingRate: funding[symbol],
        topTraderRatio: leverage?.topRatio,
      );
      if (signal != null) details[coin.id] = signal;
    }
    _details = details;
    return coins.where((c) => details.containsKey(c.id)).toList()..sort((a, b) {
      final byPoints = details[b.id]!.points.length.compareTo(
        details[a.id]!.points.length,
      );
      return byPoints != 0
          ? byPoints
          : details[b.id]!.extension.compareTo(details[a.id]!.extension);
    });
  }

  Future<Map<String, double>> _fundingRates() async {
    final cached = _funding;
    if (cached != null && DateTime.now().difference(cached.at) < _fundingTtl) {
      return cached.rates;
    }
    final rates = await _binance.fundingRates();
    _funding = (rates: rates, at: DateTime.now());
    return rates;
  }

  Future<void> _loadLeverage(List<String> symbols) async {
    final now = DateTime.now();
    final stale = symbols.where((s) {
      final cached = _leverageCache[s];
      return cached == null || now.difference(cached.at) >= _leverageTtl;
    }).toList();
    for (var i = 0; i < stale.length; i += _parallelRequests) {
      await Future.wait(
        stale.skip(i).take(_parallelRequests).map((symbol) async {
          final (openInterest, topRatio) = await (
            _binance.openInterestChange(symbol, hours: 24),
            _binance.topTraderPositionRatio(symbol),
          ).wait;
          _leverageCache[symbol] = (
            openInterest: openInterest,
            topRatio: topRatio,
            at: DateTime.now(),
          );
        }),
      );
    }
  }
}
