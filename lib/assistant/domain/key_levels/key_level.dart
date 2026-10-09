import 'package:equatable/equatable.dart';

/// Сильный уровень, на котором стоит или к которому подходит цена монеты.
class KeyLevel extends Equatable {
  const KeyLevel({
    required this.price,
    required this.touches,
    required this.avgBouncePercent,
    required this.isResistance,
    required this.isAtLevel,
    required this.distancePercent,
    this.corridor,
  });

  final double price;

  /// Сколько крупных отскоков было от уровня за 90 дней.
  final int touches;

  /// Средний размер этих отскоков, %.
  final double avgBouncePercent;

  /// Уровень выше цены — сопротивление, ниже — поддержка.
  final bool isResistance;

  /// Цена уже на уровне (иначе — подходит к нему и ещё не касалась).
  final bool isAtLevel;

  /// Расстояние от текущей цены до уровня, %.
  final double distancePercent;

  /// Границы коридора, если цена ходит между сильными уровнями.
  final ({double low, double high})? corridor;

  @override
  List<Object?> get props => [
    price,
    touches,
    avgBouncePercent,
    isResistance,
    isAtLevel,
    distancePercent,
    corridor,
  ];
}
