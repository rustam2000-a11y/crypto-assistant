import 'dart:async';

import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/data/repository/auth_repository.dart';
import '../../core/models/user_model.dart';
import '../../home/data/models/coin_model.dart';
import '../../home/data/repository/coint_rpository.dart';
import 'briefcase_effect.dart';
import 'briefcase_event.dart';
import 'briefcase_state.dart';

@injectable
class BriefcaseBloc
    extends EffectBloc<BriefcaseEvent, BriefcaseState, BriefcaseEffect> {
  BriefcaseBloc({
    required CoinRepositoryI coinRepository,
    required AuthRepositoryI authRepository,
  }) : _coinRepository = coinRepository,
       _authRepository = authRepository,
       super(const BriefcaseState()) {
    on<BriefcaseLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: event.isLoading));
    });
    on<BriefcaseCoinsLoadedEvent>((event, emit) {
      emit(state.copyWith(coins: event.coins, isLoading: false));
    });

    init();
  }

  final CoinRepositoryI _coinRepository;
  final AuthRepositoryI _authRepository;
  StreamSubscription<List<CoinModel>>? _coinsSubscription;
  StreamSubscription<bool>? _authSubscription;

  void init() {
    _authSubscription = _authRepository.authStateChanges().listen(
      (isLoggedIn) {
        if (!isLoggedIn) {
          _coinsSubscription?.cancel();
          _coinsSubscription = null;
          add(const BriefcaseCoinsLoadedEvent(coins: []));
          return;
        }
        add(const BriefcaseLoadingEvent(isLoading: true));
        _watchUserCoins();
      },
      onError: (Object e) {
        if (e is Exception) emitEffect(BriefcaseShowError(e.toString()));
      },
    );
  }

  void _watchUserCoins() {
    _coinsSubscription?.cancel();
    _coinsSubscription =
        Rx.combineLatest2<List<CoinModel>, UserModel?, List<CoinModel>>(
          _coinRepository.watchCoins(),
          _authRepository.watchCurrentUserProfile(),
          (coins, userProfile) {
            final coinIds = userProfile?.coinIds ?? const [];
            return coins.where((coin) => coinIds.contains(coin.id)).toList();
          },
        ).listen(
          (userCoins) {
            add(BriefcaseCoinsLoadedEvent(coins: userCoins));
          },
          onError: (Object e) {
            if (e is Exception) emitEffect(BriefcaseShowError(e.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _coinsSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}
