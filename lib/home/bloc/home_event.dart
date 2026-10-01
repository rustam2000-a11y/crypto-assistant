import '../data/models/coin_model.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class LoadingEvent extends HomeEvent {
  const LoadingEvent({required this.isLoading});

  final bool isLoading;
}

class LoadItemsEvent extends HomeEvent {
  LoadItemsEvent({required this.items});

  final List<CoinModel> items;
}

class SearchQueryChangedEvent extends HomeEvent {
  const SearchQueryChangedEvent({required this.query});

  final String query;
}

class LogOutEvent extends HomeEvent {
  const LogOutEvent();
}

class LoggedInStatusChangedEvent extends HomeEvent {
  const LoggedInStatusChangedEvent({required this.isLoggedIn});

  final bool isLoggedIn;
}
