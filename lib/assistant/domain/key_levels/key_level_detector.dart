import 'dart:math';

import '../../../home/data/models/candle.dart';

/// Сильный уровень: цена, от которой было несколько крупных отскоков.
typedef StrongLevel = ({double price, int touches, double avgBouncePercent});

/// Уровни и типичный ход монеты по последней закрытой 4ч свече.
typedef LevelAnalysis = ({List<StrongLevel> levels, double atr});

/// Реально сильные уровни по 4-часовым свечам за 90 дней.
///
/// Касание уровня — крупный разворот: самая высокая/низкая цена за ±24 часа,
/// после которой цена за 48 часов ушла минимум на 3 обычных 4ч хода
/// (обычно 10%+). Уровень — узкая зона (±0.25 хода), где таких разворотов
/// минимум 3. Пробитое сопротивление часто становится поддержкой, поэтому
/// считаются и вершины, и впадины.
///
/// На истории отскок от уровней (в любом их определении) случался не чаще,
/// чем от случайной цены на том же расстоянии: уровень — ориентир, а не
/// прогноз.
class KeyLevelDetector {
  const KeyLevelDetector();

  /// Свечей запрашивать: 90 дней + неделя на ATR первых разворотов.
  static const int candlesLimit = 600;
  static const int _lookbackBars = 540;
  static const int _atrBars = 42; // 7 дней
  static const int _swingBars = 6; // ±24 часа
  static const int _reactionBars = 12; // 48 часов
  static const double _minReactionAtr = 3;
  static const double _zoneAtr = 0.25;
  static const int _minTouches = 3;

  /// Цена «на уровне» — ближе 0.1 хода (обычно ~0.3%).
  static const double atLevelAtr = 0.1;

  /// Цена «подходит» — ближе 0.35 хода (обычно ~1%).
  static const double approachAtr = 0.35;

  // Коридор: 48 часов цена между уровнями, ширина от 3 ходов.
  static const int _corridorBars = 12;
  static const double _minCorridorAtr = 3;

  LevelAnalysis? analyze(List<Candle> candles) {
    if (candles.length < _atrBars + _swingBars * 2 + 1) return null;
    final atr = _atrSeries(candles);
    final t = candles.length - 1;
    final atrNow = atr[t];
    if (atrNow == null || atrNow <= 0) return null;
    return (levels: _levels(candles, atr, t, atrNow), atr: atrNow);
  }

  /// Ближайший к [price] уровень и расстояние до него в ходах (ATR).
  ({StrongLevel level, double distanceAtr})? nearest(
    LevelAnalysis analysis,
    double price,
  ) {
    StrongLevel? best;
    for (final level in analysis.levels) {
      if (best == null ||
          (level.price - price).abs() < (best.price - price).abs()) {
        best = level;
      }
    }
    if (best == null) return null;
    return (
      level: best,
      distanceAtr: (best.price - price).abs() / analysis.atr,
    );
  }

  /// Цена уже доходила до уровня в [recent] свечах — касание было, монета
  /// не «подходит», а уже отреагировала.
  bool touchedRecently(
    StrongLevel level,
    double price,
    double atr,
    List<Candle> recent,
  ) {
    final zone = atLevelAtr * atr;
    final isResistance = level.price > price;
    return recent.any(
      (c) => isResistance
          ? c.high >= level.price - zone
          : c.low <= level.price + zone,
    );
  }

  /// Коридор между ближайшими уровнями сверху и снизу, если цена 48 часов
  /// ходит между ними.
  ({double low, double high})? corridor(
    List<Candle> candles,
    LevelAnalysis analysis,
    double price,
  ) {
    final above = analysis.levels.where((l) => l.price > price);
    final below = analysis.levels.where((l) => l.price < price);
    if (above.isEmpty || below.isEmpty) return null;
    final high = above.map((l) => l.price).reduce(min);
    final low = below.map((l) => l.price).reduce(max);
    if (high - low < _minCorridorAtr * analysis.atr) return null;
    final margin = _zoneAtr * analysis.atr;
    for (var k = candles.length - _corridorBars; k < candles.length; k++) {
      final close = candles[k].close;
      if (close < low - margin || close > high + margin) return null;
    }
    return (low: low, high: high);
  }

  List<StrongLevel> _levels(
    List<Candle> c,
    List<double?> atr,
    int t,
    double atrNow,
  ) {
    // Развороты, подтверждённые к последней свече (прошло окно реакции).
    final pivots = <({double price, double bounce})>[];
    final from = max(_swingBars, t - _lookbackBars + 1);
    final to = t - max(_swingBars, _reactionBars);
    for (var k = from; k <= to; k++) {
      final a = atr[k];
      if (a == null) continue;
      final end = min(c.length, k + 1 + _reactionBars);
      if (c[k].high >= _maxHigh(c, k - _swingBars, k + _swingBars)) {
        final move = c[k].high - _minLow(c, k + 1, end - 1);
        if (move >= _minReactionAtr * a) {
          pivots.add((price: c[k].high, bounce: move / c[k].high * 100));
        }
      }
      if (c[k].low <= _minLow(c, k - _swingBars, k + _swingBars)) {
        final move = _maxHigh(c, k + 1, end - 1) - c[k].low;
        if (move >= _minReactionAtr * a) {
          pivots.add((price: c[k].low, bounce: move / c[k].low * 100));
        }
      }
    }
    pivots.sort((a, b) => a.price.compareTo(b.price));

    // Узкие зоны: вокруг разворота с наибольшим числом соседей в ±zone,
    // без «перетекания» зоны от точки к точке.
    final zone = _zoneAtr * atrNow;
    final used = List<bool>.filled(pivots.length, false);
    final levels = <StrongLevel>[];
    while (true) {
      List<int>? best;
      for (var i = 0; i < pivots.length; i++) {
        if (used[i]) continue;
        final members = [
          for (var j = 0; j < pivots.length; j++)
            if (!used[j] && (pivots[j].price - pivots[i].price).abs() <= zone)
              j,
        ];
        if (best == null || members.length > best.length) best = members;
      }
      if (best == null || best.length < _minTouches) break;
      for (final j in best) {
        used[j] = true;
      }
      final prices = [for (final j in best) pivots[j].price];
      final bounces = [for (final j in best) pivots[j].bounce];
      levels.add((
        price: _median(prices),
        touches: best.length,
        avgBouncePercent: bounces.reduce((a, b) => a + b) / bounces.length,
      ));
    }
    return levels;
  }

  // ATR: среднее истинного диапазона за 7 дней (null, пока данных мало).
  static List<double?> _atrSeries(List<Candle> c) {
    final result = List<double?>.filled(c.length, null);
    final tr = <double>[];
    var sum = 0.0;
    for (var k = 0; k < c.length; k++) {
      tr.add(
        k == 0
            ? c[k].high - c[k].low
            : [
                c[k].high - c[k].low,
                (c[k].high - c[k - 1].close).abs(),
                (c[k].low - c[k - 1].close).abs(),
              ].reduce(max),
      );
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

  // Значения уже отсортированы по цене.
  static double _median(List<double> sorted) {
    final mid = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[mid]
        : (sorted[mid - 1] + sorted[mid]) / 2;
  }
}
