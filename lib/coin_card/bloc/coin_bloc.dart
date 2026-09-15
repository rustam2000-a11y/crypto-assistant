import 'dart:async';

import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';

import '../../home/data/models/chart_period.dart';
import '../../home/data/models/coin_model.dart';
import '../../home/data/models/price_point.dart';
import '../../home/data/repository/coint_rpository.dart';
import '../../registration/data/repository/registration_repository.dart';
import 'coin_effect.dart';
import 'coin_event.dart';
import 'coin_state.dart';

@injectable
class CoinBloc extends EffectBloc<CoinEvent, CoinState, CoinEffect> {
  CoinBloc({
    required CoinRepositoryI coinRepository,
    required RegistrationRepositoryI registrationRepository,
  }) : _coinRepository = coinRepository,
       _registrationRepository = registrationRepository,
       super(const CoinState()) {
    on<LoadCoinDetailsEvent>((event, emit) {
      emit(state.copyWith(coinId: event.coinId));
      _watchCoin(event.coinId);
      _watchChart(event.coinId, state.chartPeriod);
      _loadBriefcaseStatus(event.coinId);
    });
    on<CoinLoadingEvent>((event, emit) {
      emit(state.copyWith(isLoading: event.isLoading));
    });
    on<CoinLoadedEvent>((event, emit) {
      emit(state.copyWith(coin: event.coin, isLoading: false));
    });
    on<ChartLoadingEvent>((event, emit) {
      emit(state.copyWith(isChartLoading: event.isLoading));
    });
    on<ChartLoadedEvent>((event, emit) {
      emit(state.copyWith(chartPoints: event.points, isChartLoading: false));
    });
    on<ToggleBriefcaseEvent>((event, emit) {
      _toggleBriefcase();
    });
    on<BriefcaseStatusLoadedEvent>((event, emit) {
      emit(state.copyWith(isFavorite: event.isFavorite));
    });
    on<ChangeChartPeriodEvent>((event, emit) {
      _changeChartPeriod(event.period);
    });
    on<ChartPeriodChangedEvent>((event, emit) {
      emit(state.copyWith(chartPeriod: event.period));
    });
  }

  final CoinRepositoryI _coinRepository;
  final RegistrationRepositoryI _registrationRepository;
  StreamSubscription<CoinModel>? _coinSubscription;
  StreamSubscription<List<PricePoint>>? _chartSubscription;

  void _watchCoin(String coinId) {
    add(const CoinLoadingEvent(isLoading: true));
    _coinSubscription?.cancel();
    _coinSubscription = _coinRepository.watchCoin(coinId).listen((coin) {
      add(CoinLoadedEvent(coin: coin));
    });
  }

  void _watchChart(String coinId, ChartPeriod period) {
    add(const ChartLoadingEvent(isLoading: true));
    _chartSubscription?.cancel();
    _chartSubscription = _coinRepository
        .watchMarketChart(coinId, days: period.days)
        .listen((points) {
          add(ChartLoadedEvent(points: points));
        });
  }

  void _changeChartPeriod(ChartPeriod period) {
    if (period == state.chartPeriod) return;
    add(ChartPeriodChangedEvent(period));
    final coinId = state.coinId;
    if (coinId != null) _watchChart(coinId, period);
  }

  Future<void> _loadBriefcaseStatus(String coinId) async {
    if (_registrationRepository.currentUser == null) {
      add(const BriefcaseStatusLoadedEvent(isFavorite: false));
      return;
    }
    final userProfile = await _registrationRepository.getCurrentUserProfile();
    final isFavorite = userProfile?.coinIds.contains(coinId) ?? false;
    add(BriefcaseStatusLoadedEvent(isFavorite: isFavorite));
  }

  Future<void> _toggleBriefcase() async {
    if (_registrationRepository.currentUser == null) {
      emitEffect(const CoinNavigateToLogin());
      return;
    }
    final coinId = state.coin?.id;
    if (coinId == null) return;

    if (state.isFavorite) {
      await _coinRepository.removeCoinFromBriefcase(coinId);
      add(const BriefcaseStatusLoadedEvent(isFavorite: false));
      return;
    }

    await _coinRepository.addCoinToBriefcase(coinId);
    add(const BriefcaseStatusLoadedEvent(isFavorite: true));
  }

  @override
  Future<void> close() {
    _coinSubscription?.cancel();
    _chartSubscription?.cancel();
    return super.close();
  }
}
