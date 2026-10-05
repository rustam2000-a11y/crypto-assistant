import '../../home/data/models/coin_model.dart';

abstract class BriefcaseEvent {
  const BriefcaseEvent();
}

class BriefcaseLoadingEvent extends BriefcaseEvent {
  const BriefcaseLoadingEvent({required this.isLoading});

  final bool isLoading;
}

class BriefcaseCoinsLoadedEvent extends BriefcaseEvent {
  const BriefcaseCoinsLoadedEvent({required this.coins});

  final List<CoinModel> coins;
}

class BriefcaseToggleCoinSelectionEvent extends BriefcaseEvent {
  const BriefcaseToggleCoinSelectionEvent({required this.coinId});

  final String coinId;
}

class BriefcaseSelectionChangedEvent extends BriefcaseEvent {
  const BriefcaseSelectionChangedEvent({required this.selectedCoinIds});

  final Set<String> selectedCoinIds;
}

class BriefcaseRemoveSelectedCoinsEvent extends BriefcaseEvent {
  const BriefcaseRemoveSelectedCoinsEvent();
}
