import 'package:equatable/equatable.dart';

import '../signal_side.dart';

/// Признаки перегрузки монеты и их значения.
class OverloadSignal extends Equatable {
  const OverloadSignal({
    required this.side,
    required this.points,
    required this.extension,
    required this.rsi1h,
    required this.rsi4h,
    required this.volumeSpike,
    this.openInterestChange,
    this.fundingRate,
    this.topTraderRatio,
  });

  /// Перегрузка вверх (шорт) или зеркально вниз (лонг).
  final SignalSide side;

  /// Какие из 7 признаков горят.
  final Set<OverloadSign> points;

  /// Насколько цена выше EMA20 часового графика (для лонга — ниже),
  /// в обычных часовых ходах.
  final double extension;
  final double rsi1h;
  final double rsi4h;

  /// Средний объём за 2 часа к среднему за 6 часов до них.
  final double volumeSpike;

  /// Изменение открытого интереса за сутки, в долях (нет данных — null).
  final double? openInterestChange;

  /// Ставка фандинга за 8 часов, в долях.
  final double? fundingRate;

  /// Лонг/шорт по позициям топ-трейдеров.
  final double? topTraderRatio;

  /// Плечи растут так резко (OI x2 за сутки), что на истории рост чаще
  /// продолжался, чем сменялся откатом. Для лонга — падение может продолжиться.
  bool get squeezeRisk => (openInterestChange ?? 0) >= 1;

  @override
  List<Object?> get props => [
    side,
    points,
    extension,
    rsi1h,
    rsi4h,
    volumeSpike,
    openInterestChange,
    fundingRate,
    topTraderRatio,
  ];
}

enum OverloadSign {
  extension,
  rsi1h,
  rsi4h,
  openInterest,
  funding,
  topTraders,
  volumeSpike,
}
