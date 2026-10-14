import 'dart:math';

import '../../../home/data/models/candle.dart';
import '../key_levels/key_level_detector.dart';
import 'level_approach.dart';

/// Радар: цена на сильном уровне (см. [KeyLevelDetector]: 2+ крупных отскока
/// в среднем от 8%, уровень почти не пробивался, монета живая), на свечах
/// отскоков от которого шёл крупный объём, или вплотную подходит к нему —
/// до уровня меньше 1%.
///
/// На истории Binance (150 ликвидных монет, окт 2025 — сен 2026) на радаре
/// в среднем была ~1 монета одновременно, часто пусто (у прежних, более
/// слабых уровней — ~4). «Подходит» доходила до уровня за 2 часа в ~75%
/// случаев, за 4 часа — в ~80% (около 140 случаев за год). Когда цена уже
/// на уровне, в ближайшие 4 часа уровень чаще пробивался, чем давал сильный
/// отскок, — радар показывает важную цену, а не обещает отскок.
class LevelRadar {
  const LevelRadar();

  /// Часовых свечей нужно: 8 часов на проверку касания + запас.
  static const int hourlyCandles = 30;

  static const double _minVolumeMultiple = 1.5;
  // «Подходит» — ближе 0.35 обычного 4ч хода и меньше 1% в цене.
  static const double _maxDistanceAtr = 0.35;
  static const double _maxDistancePercent = 1;
  // За 4 часа цена прошла к уровню минимум четверть обычного 4ч хода.
  static const int _moveHours = 4;
  static const double _minMoveAtr = 0.25;
  static const int _touchHours = 8;

  LevelApproach? approach({
    required LevelAnalysis analysis,
    required List<Candle> hourly,
    required double price,
  }) {
    if (hourly.length < _touchHours + 1) return null;
    final atr = analysis.atr;

    // Ближайший сильный уровень с крупным объёмом на отскоках.
    StrongLevel? level;
    for (final candidate in analysis.levels) {
      if (candidate.volumeMultiple < _minVolumeMultiple) continue;
      if (level == null ||
          (candidate.price - price).abs() < (level.price - price).abs()) {
        level = candidate;
      }
    }
    if (level == null) return null;

    final distance = (level.price - price).abs();
    final distancePercent = distance / price * 100;
    if (distance > _maxDistanceAtr * atr ||
        distancePercent >= _maxDistancePercent) {
      return null;
    }
    final isResistance = level.price > price;
    final isAtLevel = distance <= KeyLevelDetector.atLevelAtr * atr;

    if (!isAtLevel) {
      // Цена идёт к уровню и за 8 часов его не касалась — касание впереди.
      final before = hourly[hourly.length - 1 - _moveHours].close;
      final move = (price - before) / atr * (isResistance ? 1 : -1);
      if (move < _minMoveAtr) return null;
      final zone = KeyLevelDetector.atLevelAtr * atr;
      final recent = hourly.sublist(hourly.length - _touchHours);
      final touched = isResistance
          ? recent.map((c) => c.high).reduce(max) >= level.price - zone
          : recent.map((c) => c.low).reduce(min) <= level.price + zone;
      if (touched) return null;
    }

    return LevelApproach(
      levelPrice: level.price,
      isResistance: isResistance,
      isAtLevel: isAtLevel,
      touches: level.touches,
      avgBouncePercent: level.avgBouncePercent,
      volumeMultiple: level.volumeMultiple,
      distancePercent: distancePercent,
    );
  }
}
