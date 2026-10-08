import 'package:equatable/equatable.dart';

import '../../home/data/models/coin_model.dart';

class BriefcaseState extends Equatable {
  const BriefcaseState({
    this.coins = const [],
    this.selectedCoinIds = const {},
    this.isLoading = false,
    this.isLoggedIn = false,
  });

  final List<CoinModel> coins;
  final Set<String> selectedCoinIds;
  final bool isLoading;
  final bool isLoggedIn;

  BriefcaseState copyWith({
    List<CoinModel>? coins,
    Set<String>? selectedCoinIds,
    bool? isLoading,
    bool? isLoggedIn,
  }) {
    return BriefcaseState(
      coins: coins ?? this.coins,
      selectedCoinIds: selectedCoinIds ?? this.selectedCoinIds,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [coins, selectedCoinIds, isLoading, isLoggedIn];
}
