import 'package:equatable/equatable.dart';

/// Показатели перегретой монеты, у которой уходит ликвидность.
class OverboughtSignal extends Equatable {
  const OverboughtSignal({
    required this.rsi,
    required this.rise24hPercent,
    required this.heat,
    required this.volumeChangePercent,
    required this.buyersSharePercent,
    required this.previousBuyersSharePercent,
  });

  /// RSI(14) по часовым свечам.
  final double rsi;

  /// Рост за 24 часа, %.
  final double rise24hPercent;

  /// Во сколько раз рост за 24ч больше обычного дневного хода монеты.
  final double heat;

  /// Средний часовой объём за 3ч против 6ч до них, % (отрицательный — падает).
  final double volumeChangePercent;

  /// Доля агрессивных покупок в обороте за 3ч и за 6ч до них, %.
  final double buyersSharePercent;
  final double previousBuyersSharePercent;

  @override
  List<Object?> get props => [
    rsi,
    rise24hPercent,
    heat,
    volumeChangePercent,
    buyersSharePercent,
    previousBuyersSharePercent,
  ];
}
