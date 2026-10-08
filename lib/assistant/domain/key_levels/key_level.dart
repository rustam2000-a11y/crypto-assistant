import 'package:equatable/equatable.dart';

/// Сильный уровень, к которому подошла цена монеты.
class KeyLevel extends Equatable {
  const KeyLevel({
    required this.price,
    required this.touches,
    required this.isResistance,
    required this.distancePercent,
    this.corridor,
  });

  final double price;

  /// Сколько сильных разворотов было от этого уровня за 20 дней.
  final int touches;

  /// Уровень выше цены — сопротивление, ниже — поддержка.
  final bool isResistance;

  /// Расстояние от текущей цены до уровня, %.
  final double distancePercent;

  /// Границы коридора, если цена ходит между подтверждёнными уровнями.
  final ({double low, double high})? corridor;

  @override
  List<Object?> get props => [
    price,
    touches,
    isResistance,
    distancePercent,
    corridor,
  ];
}
