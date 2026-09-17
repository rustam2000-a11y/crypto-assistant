import 'dart:async';

import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';

import '../../home/data/models/coin_model.dart';
import '../../home/data/repository/coint_rpository.dart';
import '../domain/coin_filter.dart';
import '../domain/filter_type.dart';
import 'filter_detailing_effect.dart';
import 'filter_detailing_event.dart';
import 'filter_detailing_state.dart';

@injectable
class FilterDetailingBloc
    extends
        EffectBloc<
          FilterDetailingEvent,
          FilterDetailingState,
          FilterDetailingEffect
        > {
  FilterDetailingBloc({required CoinRepositoryI repository})
    : _repository = repository,
      super(const FilterDetailingState()) {
    on<LoadFilteredCoinsEvent>((event, emit) {
      _watchCoins(event.type);
    });
    on<FilterDetailingLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: event.isLoading));
    });
    on<FilterDetailingCoinsLoadedEvent>((event, emit) {
      emit(state.copyWith(coins: event.coins, isLoading: false));
    });
  }

  final CoinRepositoryI _repository;
  StreamSubscription<List<CoinModel>>? _coinsSubscription;

  void _watchCoins(FilterType type) {
    add(const FilterDetailingLoadingEvent(isLoading: true));
    final filter = CoinFilter.forType(type);
    _coinsSubscription?.cancel();
    _coinsSubscription = _repository.watchCoins().listen(
      (coins) {
        add(FilterDetailingCoinsLoadedEvent(coins: filter.filter(coins)));
      },
      onError: (Object error) {
        emitEffect(FilterDetailingShowError(error.toString()));
        add(const FilterDetailingLoadingEvent(isLoading: false));
      },
    );
  }

  @override
  Future<void> close() {
    _coinsSubscription?.cancel();
    return super.close();
  }
}
