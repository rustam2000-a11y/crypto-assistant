import 'package:equatable/equatable.dart';

/// Монета на сильном уровне с крупным объёмом на отскоках или вплотную
/// подходит к нему.
class LevelApproach extends Equatable {
  const LevelApproach({
    required this.levelPrice,
    required this.isResistance,
    required this.isAtLevel,
    required this.touches,
    required this.avgBouncePercent,
    required this.volumeMultiple,
    required this.distancePercent,
  });

  final double levelPrice;

  /// Уровень над ценой — сопротивление, под ценой — поддержка.
  final bool isResistance;

  /// Цена уже на уровне (иначе — подходит, до уровня меньше 1%).
  final bool isAtLevel;

  /// Крупных отскоков от уровня за 90 дней и их средний размер, %.
  final int touches;
  final double avgBouncePercent;

  /// Во сколько раз оборот свечей отскока от уровня больше обычного.
  final double volumeMultiple;

  final double distancePercent;

  @override
  List<Object?> get props => [
    levelPrice,
    isResistance,
    isAtLevel,
    touches,
    avgBouncePercent,
    volumeMultiple,
    distancePercent,
  ];
}
