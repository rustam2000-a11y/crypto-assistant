import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../api/coint_api.dart';
import '../models/coin_model.dart';
import '../models/price_point.dart';

@LazySingleton(as: CoinRepositoryI)
class CoinRepository extends CoinRepositoryI {
  CoinRepository({required CoinApI api}) : _api = api;

  final CoinApI _api;

  @override
  Stream<List<CoinModel>> watchCoins() {
    return Stream.periodic(const Duration(seconds: 60))
        .startWith(null)
        .switchMap((_) => Stream.fromFuture(_api.fetch()))
        .switchMap((coins) {
          if (coins.isEmpty) return Stream.value(coins);
          return CombineLatestStream.list(
            coins.map(
              (coin) => _api
                  .watchPrice(coin.symbol)
                  .map((price) => coin.copyWith(currentPrice: price))
                  .startWith(coin),
            ),
          );
        });
  }

  @override
  Stream<CoinModel> watchCoin(String id) {
    return Stream.periodic(const Duration(seconds: 60))
        .startWith(null)
        .switchMap((_) => Stream.fromFuture(_api.fetchById(id)))
        .switchMap(
          (coin) => _api
              .watchPrice(coin.symbol)
              .map((price) => coin.copyWith(currentPrice: price))
              .startWith(coin),
        );
  }

  @override
  Stream<List<PricePoint>> watchMarketChart(String id, {int days = 7}) {
    return Stream.fromFuture(_api.fetchById(id)).switchMap((coin) {
      final livePrice = _api.watchPrice(coin.symbol);
      return Stream.periodic(const Duration(seconds: 60))
          .startWith(null)
          .switchMap(
            (_) => Stream.fromFuture(_api.fetchMarketChart(id, days: days)),
          )
          .switchMap(
            (points) => livePrice
                .map(
                  (price) => [
                    ...points,
                    PricePoint(timestamp: DateTime.now(), price: price),
                  ],
                )
                .startWith(points),
          );
    });
  }

  @override
  Future<void> addCoinToBriefcase(String coinId) =>
      _api.addCoinToBriefcase(coinId);

  @override
  Future<void> removeCoinFromBriefcase(String coinId) =>
      _api.removeCoinFromBriefcase(coinId);
}

abstract class CoinRepositoryI {
  Stream<List<CoinModel>> watchCoins();
  Stream<CoinModel> watchCoin(String id);
  Stream<List<PricePoint>> watchMarketChart(String id, {int days = 7});
  Future<void> addCoinToBriefcase(String coinId);
  Future<void> removeCoinFromBriefcase(String coinId);
}