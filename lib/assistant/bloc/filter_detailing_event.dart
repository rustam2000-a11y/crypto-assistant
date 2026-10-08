import '../../home/data/models/coin_model.dart';
import '../domain/filter_type.dart';
import '../domain/pump_reversal/pump_reversal_status.dart';

abstract class FilterDetailingEvent {
  const FilterDetailingEvent();
}

class LoadFilteredCoinsEvent extends FilterDetailingEvent {
  const LoadFilteredCoinsEvent(this.type);

  final FilterType type;
}

class FilterDetailingLoadingEvent extends FilterDetailingEvent {
  const FilterDetailingLoadingEvent({required this.isLoading});

  final bool isLoading;
}

class FilterDetailingCoinsLoadedEvent extends FilterDetailingEvent {
  const FilterDetailingCoinsLoadedEvent({
    required this.coins,
    this.reversalStatus,
    this.details = const {},
  });

  final List<CoinModel> coins;
  final PumpReversalStatus? reversalStatus;
  final Map<String, Object> details;
}
