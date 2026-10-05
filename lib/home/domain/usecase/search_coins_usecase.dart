import 'package:injectable/injectable.dart';

import '../../data/models/coin_model.dart';

@injectable
class SearchCoinsUseCase {
  List<CoinModel> call(List<CoinModel> coins, String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) return coins;
    return coins
        .where(
          (coin) =>
              coin.name.toLowerCase().startsWith(lowerQuery) ||
              coin.symbol.toLowerCase().startsWith(lowerQuery),
        )
        .toList();
  }
}
