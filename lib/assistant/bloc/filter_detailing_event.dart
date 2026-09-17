import '../../home/data/models/coin_model.dart';
import '../domain/filter_type.dart';

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
  const FilterDetailingCoinsLoadedEvent({required this.coins});

  final List<CoinModel> coins;
}
