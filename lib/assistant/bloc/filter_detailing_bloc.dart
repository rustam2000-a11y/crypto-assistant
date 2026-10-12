import 'dart:async';

import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../home/data/models/coin_model.dart';
import '../../home/data/repository/coint_rpository.dart';
import '../domain/coin_filter.dart';
import '../domain/filter_type.dart';
import '../domain/key_levels/key_level_filter.dart';
import '../domain/level_radar/level_radar_filter.dart';
import '../domain/overbought/overbought_filter.dart';
import '../domain/overload/overload_filter.dart';
import '../domain/pump_reversal/pump_reversal_filter.dart';
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
  FilterDetailingBloc({
    required CoinRepositoryI repository,
    required PumpReversalFilter pumpReversal,
    required KeyLevelFilter keyLevels,
    required OverboughtFilter overbought,
    required LevelRadarFilter levelRadar,
    required OverloadFilter overload,
  }) : _repository = repository,
       _pumpReversal = pumpReversal,
       _keyLevels = keyLevels,
       _overbought = overbought,
       _levelRadar = levelRadar,
       _overload = overload,
       super(const FilterDetailingState()) {
    on<LoadFilteredCoinsEvent>((event, emit) {
      _watchCoins(event.type);
    });
    on<FilterDetailingLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: event.isLoading));
    });
    on<FilterDetailingCoinsLoadedEvent>((event, emit) {
      emit(
        state.copyWith(
          coins: event.coins,
          reversalStatus: event.reversalStatus,
          details: event.details,
          isLoading: false,
        ),
      );
    });
  }

  // Фильтры на свечах Binance не запускаем на каждый тик цены.
  static const _binanceThrottle = Duration(seconds: 5);

  final CoinRepositoryI _repository;
  final PumpReversalFilter _pumpReversal;
  final KeyLevelFilter _keyLevels;
  final OverboughtFilter _overbought;
  final LevelRadarFilter _levelRadar;
  final OverloadFilter _overload;
  StreamSubscription<List<CoinModel>>? _coinsSubscription;

  void _watchCoins(FilterType type) {
    add(const FilterDetailingLoadingEvent(isLoading: true));
    final filter = CoinFilter.forType(
      type,
      pumpReversal: _pumpReversal,
      keyLevels: _keyLevels,
      overbought: _overbought,
      levelRadar: _levelRadar,
      overload: _overload,
    );
    final isReversal = identical(filter, _pumpReversal);
    var coins = _repository.watchCoins();
    if (isReversal || filter is DetailedCoinFilter) {
      coins = coins.throttleTime(_binanceThrottle, trailing: true);
    }
    _coinsSubscription?.cancel();
    // exhaustMap: новый прогон не начинается, пока не закончен предыдущий.
    _coinsSubscription = coins
        .exhaustMap(
          (all) => Stream.fromFuture(Future.sync(() => filter.filter(all))),
        )
        .listen(
          (filtered) {
            add(
              FilterDetailingCoinsLoadedEvent(
                coins: filtered,
                reversalStatus: isReversal ? _pumpReversal.status : null,
                details: filter is DetailedCoinFilter
                    ? filter.details
                    : const {},
              ),
            );
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
