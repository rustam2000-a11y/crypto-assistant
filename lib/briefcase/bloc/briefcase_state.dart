import 'package:equatable/equatable.dart';

import '../../home/data/models/coin_model.dart';

class BriefcaseState extends Equatable {
  const BriefcaseState({
    this.coins = const [],
    this.selectedCoinIds = const {},
    this.isLoading = false,
  });

  final List<CoinModel> coins;
  final Set<String> selectedCoinIds;
  final bool isLoading;

  BriefcaseState copyWith({
    List<CoinModel>? coins,
    Set<String>? selectedCoinIds,
    bool? isLoading,
  }) {
    return BriefcaseState(
      coins: coins ?? this.coins,
      selectedCoinIds: selectedCoinIds ?? this.selectedCoinIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [coins, selectedCoinIds, isLoading];
}
