import 'package:equatable/equatable.dart';

import '../signal_side.dart';

/// Показатели перегретой (или зеркально перепроданной) монеты, у которой
/// уходит ликвидность.
class OverboughtSignal extends Equatable {
  const OverboughtSignal({
    required this.side,
    required this.rsi,
    required this.rise24hPercent,
    required this.heat,
    required this.volumeChangePercent,
    required this.buyersSharePercent,
    required this.previousBuyersSharePercent,
  });

  /// Перегрев (шорт) или перепроданность (лонг).
  final SignalSide side;

  /// RSI(14) по часовым свечам.
  final double rsi;

  /// Изменение цены за 24 часа, % (для лонга — отрицательное).
  final double rise24hPercent;

  /// Во сколько раз рост (для лонга — падение) за 24ч больше обычного
  /// дневного хода монеты.
  final double heat;

  /// Средний часовой объём за 3ч против 6ч до них, % (отрицательный — падает).
  final double volumeChangePercent;

  /// Доля агрессивных покупок в обороте за 3ч и за 6ч до них, %.
  final double buyersSharePercent;
  final double previousBuyersSharePercent;

  @override
  List<Object?> get props => [
    side,
    rsi,
    rise24hPercent,
    heat,
    volumeChangePercent,
    buyersSharePercent,
    previousBuyersSharePercent,
  ];
}
