import 'dart:math';

import '../../../home/data/models/candle.dart';
import 'key_level.dart';

/// Очень сильные уровни по часовым свечам: цены, от которых за последние
/// 20 дней было 5+ сильных разворотов (и сверху, и снизу — пробитое
/// сопротивление часто становится поддержкой).
///
/// На истории Binance (120 ликвидных монет, окт 2025 — сен 2026) отскок от
/// таких уровней случался не чаще, чем от случайной цены на том же
/// расстоянии — и для 1ч/20д, и для 4ч/90д уровней, при любом числе касаний,
/// режиме рынка, RSI и скорости подхода. Уровень — ориентир для стопов и
/// целей, а не прогноз отскока.
class KeyLevelDetector {
  const KeyLevelDetector();

  static const int lookbackBars = 480; // 20 дней часовых свечей
  static const int _atrBars = 48;
  // Разворот: экстремум среди 4 свечей слева и справа...
  static const int _swingBars = 4;
  // ...после которого цена за 12 часов ушла минимум на 2 ATR.
  static const int _reactionBars = 12;
  static const double _minReactionAtr = 2;
  // Развороты ближе 0.5 ATR друг к другу — один уровень.
  static const double _clusterAtr = 0.5;
  static const int _minTouches = 5;
  // «Подошла к уровню» — ближе 0.5 ATR.
  static const double _nearAtr = 0.5;
  // Коридор: двое суток цена между уровнями, ширина от 3 ATR.
  static const int _corridorBars = 48;
  static const double _minCorridorAtr = 3;

  static const int requiredCandles = _atrBars + _swingBars * 2 + 1;

  /// Ближайший сильный уровень, к которому подошла [price], или null.
  KeyLevel? nearestLevel(List<Candle> candles, double price) {
    if (candles.length < requiredCandles || price <= 0) return null;
    final atr = _atrSeries(candles);
    final t = candles.length - 1;
    final atrNow = atr[t];
    if (atrNow == null || atrNow <= 0) return null;

    final levels = _levels(candles, atr, t, atrNow);
    ({double price, int touches})? nearest;
    for (final level in levels) {
      final distance = (level.price - price).abs();
      if (distance > _nearAtr * atrNow) continue;
      if (nearest == null || distance < (nearest.price - price).abs()) {
        nearest = level;
      }
    }
    if (nearest == null) return null;

    final corridor = _corridor(candles, levels, price, atrNow);
    return KeyLevel(
      price: nearest.price,
      touches: nearest.touches,
      isResistance: nearest.price > price,
      distancePercent: (nearest.price - price).abs() / price * 100,
      corridor: corridor,
    );
  }

  List<({double price, int touches})> _levels(
    List<Candle> c,
    List<double?> atr,
    int t,
    double atrNow,
  ) {
    final points = <double>[];
    final from = max(_swingBars, t - lookbackBars + 1);
    // Разворот подтверждён, когда прошло окно реакции.
    final to = t - max(_swingBars, _reactionBars);
    for (var k = from; k <= to; k++) {
      final a = atr[k];
      if (a == null) continue;
      final end = min(c.length, k + 1 + _reactionBars);
      if (c[k].high >= _maxHigh(c, k - _swingBars, k + _swingBars) &&
          c[k].high - _minLow(c, k + 1, end - 1) >= _minReactionAtr * a) {
        points.add(c[k].high);
      }
      if (c[k].low <= _minLow(c, k - _swingBars, k + _swingBars) &&
          _maxHigh(c, k + 1, end - 1) - c[k].low >= _minReactionAtr * a) {
        points.add(c[k].low);
      }
    }
    points.sort();

    final tolerance = _clusterAtr * atrNow;
    final clusters = <List<double>>[];
    for (final point in points) {
      final current = clusters.isEmpty ? null : clusters.last;
      if (current != null && point - _mean(current) <= tolerance) {
        current.add(point);
      } else {
        clusters.add([point]);
      }
    }
    return [
      for (final cluster in clusters)
        if (cluster.length >= _minTouches)
          (price: _median(cluster), touches: cluster.length),
    ];
  }

  ({double low, double high})? _corridor(
    List<Candle> c,
    List<({double price, int touches})> levels,
    double price,
    double atrNow,
  ) {
    final above = levels.where((l) => l.price > price).map((l) => l.price);
    final below = levels.where((l) => l.price < price).map((l) => l.price);
    if (above.isEmpty || below.isEmpty) return null;
    final high = above.reduce(min);
    final low = below.reduce(max);
    if (high - low < _minCorridorAtr * atrNow) return null;
    final margin = _clusterAtr * atrNow;
    for (var k = c.length - _corridorBars; k < c.length; k++) {
      if (c[k].close < low - margin || c[k].close > high + margin) return null;
    }
    return (low: low, high: high);
  }

  // ATR: среднее истинного диапазона за 48 часов (null, пока данных мало).
  static List<double?> _atrSeries(List<Candle> c) {
    final tr = <double>[
      for (var k = 0; k < c.length; k++)
        k == 0
            ? c[k].high - c[k].low
            : [
                c[k].high - c[k].low,
                (c[k].high - c[k - 1].close).abs(),
                (c[k].low - c[k - 1].close).abs(),
              ].reduce(max),
    ];
    final result = List<double?>.filled(c.length, null);
    var sum = 0.0;
    for (var k = 0; k < c.length; k++) {
      sum += tr[k];
      if (k >= _atrBars) sum -= tr[k - _atrBars];
      if (k >= _atrBars - 1) result[k] = sum / _atrBars;
    }
    return result;
  }

  static double _maxHigh(List<Candle> c, int from, int to) {
    var value = c[from].high;
    for (var k = from + 1; k <= to; k++) {
      value = max(value, c[k].high);
    }
    return value;
  }

  static double _minLow(List<Candle> c, int from, int to) {
    var value = c[from].low;
    for (var k = from + 1; k <= to; k++) {
      value = min(value, c[k].low);
    }
    return value;
  }

  static double _mean(List<double> values) =>
      values.reduce((a, b) => a + b) / values.length;

  static double _median(List<double> sorted) {
    final mid = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[mid]
        : (sorted[mid - 1] + sorted[mid]) / 2;
  }
}
