import 'package:equatable/equatable.dart';

import '../data/models/coin_model.dart';

class HomeState extends Equatable {
  const HomeState({
    this.items = const [],
    this.filteredItems = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.isLoggedIn = false,
  });

  final List<CoinModel> items;
  final List<CoinModel> filteredItems;
  final String searchQuery;
  final bool isLoading;
  final bool isLoggedIn;

  HomeState copyWith({
    List<CoinModel>? items,
    List<CoinModel>? filteredItems,
    String? searchQuery,
    bool? isLoading,
    bool? isLoggedIn,
  }) {
    return HomeState(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [
    items,
    filteredItems,
    searchQuery,
    isLoading,
    isLoggedIn,
  ];
}
