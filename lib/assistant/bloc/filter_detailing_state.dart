import 'package:equatable/equatable.dart';

import '../../home/data/models/coin_model.dart';
import '../domain/pump_reversal/pump_reversal_status.dart';

class FilterDetailingState extends Equatable {
  const FilterDetailingState({
    this.coins = const [],
    this.isLoading = false,
    this.reversalStatus,
    this.details = const {},
  });

  final List<CoinModel> coins;
  final bool isLoading;
  // Режим рынка для фильтра разворота после пампа, у остальных — null.
  final PumpReversalStatus? reversalStatus;
  // Пояснение к каждой монете (по id): уровень, показатели перегрева.
  final Map<String, Object> details;

  FilterDetailingState copyWith({
    List<CoinModel>? coins,
    bool? isLoading,
    PumpReversalStatus? reversalStatus,
    Map<String, Object>? details,
  }) {
    return FilterDetailingState(
      coins: coins ?? this.coins,
      isLoading: isLoading ?? this.isLoading,
      reversalStatus: reversalStatus ?? this.reversalStatus,
      details: details ?? this.details,
    );
  }

  @override
  List<Object?> get props => [coins, isLoading, reversalStatus, details];
}
