import 'dart:math';

import 'package:crypto_assistant/assistant/domain/key_levels/key_level_detector.dart';
import 'package:crypto_assistant/home/data/models/candle.dart';
import 'package:flutter_test/flutter_test.dart';

const _bars = KeyLevelDetector.candlesLimit;
const _barMs = 4 * 60 * 60 * 1000;

/// Свечи по ценам закрытия: open — прошлое закрытие, тени по 0.1.
/// Оборот по умолчанию — $60 млн в сутки: монета живая.
List<Candle> _candles(
  double Function(int k) price, {
  int count = _bars,
  double volume = 1e7,
}) {
  return [
    for (var k = 0; k < count; k++)
      _candle(k, open: price(max(0, k - 1)), close: price(k), volume: volume),
  ];
}

Candle _candle(
  int k, {
  required double open,
  required double close,
  required double volume,
}) {
  return Candle(
    openTime: k * _barMs,
    closeTime: (k + 1) * _barMs - 1,
    open: open,
    high: max(open, close) + 0.1,
    low: min(open, close) - 0.1,
    close: close,
    quoteVolume: volume,
    takerBuyQuoteVolume: volume / 2,
  );
}

/// Цена ходит между 100 и 130: 2 дня вверх, 2 дня вниз — крупные развороты
/// с отскоками по 23–30%.
double _range(int k) {
  final phase = k % 24;
  return 100 + (phase <= 12 ? phase : 24 - phase) * 2.5;
}

/// Дно всегда 100, вершины чередуются: 120, 140, 120, 140... Цена 120
/// трижды и больше разворачивалась, но каждый второй цикл проходит её
/// насквозь — это середина боковика, а не уровень.
double _chop(int k) {
  final phase = k % 24;
  final top = (k ~/ 24).isEven ? 20.0 : 40.0;
  return 100 + (phase <= 12 ? phase : 24 - phase) * top / 12;
}

/// Последние часы перед проверкой: цена держалась не выше [high].
List<Candle> _recent(double high) => [
  for (var k = 0; k < 8; k++)
    Candle(
      openTime: k,
      closeTime: k,
      open: high - 1,
      high: high,
      low: high - 2,
      close: high - 1,
      quoteVolume: 1000,
      takerBuyQuoteVolume: 500,
    ),
];

void main() {
  const detector = KeyLevelDetector();
  final candles = _candles(_range);
  final analysis = detector.analyze(candles)!;

  test('сильные уровни — вершины и впадины коридора', () {
    final prices = analysis.levels.map((l) => l.price).toList()..sort();
    expect(prices, hasLength(2));
    expect(prices.first, closeTo(99.9, 0.01));
    expect(prices.last, closeTo(130.1, 0.01));
    final top = analysis.levels.firstWhere((l) => l.price > 120);
    expect(top.touches, greaterThanOrEqualTo(3));
    expect(top.avgBouncePercent, closeTo(30.2 / 130.1 * 100, 0.01));
  });

  test('цена на уровне', () {
    final nearest = detector.nearest(analysis, 129.9)!;
    expect(nearest.level.price, closeTo(130.1, 0.01));
    expect(nearest.distanceAtr, lessThanOrEqualTo(KeyLevelDetector.atLevelAtr));
  });

  test('цена подходит к уровню', () {
    final nearest = detector.nearest(analysis, 129.3)!;
    expect(nearest.distanceAtr, greaterThan(KeyLevelDetector.atLevelAtr));
    expect(
      nearest.distanceAtr,
      lessThanOrEqualTo(KeyLevelDetector.approachAtr),
    );
  });

  test('касался уровня за последние часы — уже отреагировал', () {
    final level = detector.nearest(analysis, 129.3)!.level;
    expect(
      detector.touchedRecently(level, 129.3, analysis.atr, _recent(130.2)),
      isTrue,
    );
    expect(
      detector.touchedRecently(level, 129.3, analysis.atr, _recent(129.5)),
      isFalse,
    );
  });

  test('цена между уровнями — коридор', () {
    final corridor = detector.corridor(candles, analysis, 115)!;
    expect(corridor.low, closeTo(99.9, 0.01));
    expect(corridor.high, closeTo(130.1, 0.01));
  });

  test('уровень, который цена много раз пробивала, — не уровень', () {
    final prices =
        detector.analyze(_candles(_chop))!.levels.map((l) => l.price).toList()
          ..sort();
    expect(prices, hasLength(2));
    expect(prices.first, closeTo(99.9, 0.01));
    expect(prices.last, closeTo(140.1, 0.01));
  });

  test('ровный тренд без повторных разворотов — уровней нет', () {
    final trend = detector.analyze(
      _candles((k) => 100 * pow(1.04, k).toDouble()),
    )!;
    expect(trend.levels, isEmpty);
    expect(detector.nearest(trend, 300), isNull);
  });

  test('вялая монета: мелкий ход — уровней не ищем', () {
    final calm = _candles((k) => 100 + _range(k) / 100);
    expect(detector.analyze(calm), isNull);
  });

  test('вялая монета: оборот меньше \$10 млн в сутки — уровней не ищем', () {
    expect(detector.analyze(_candles(_range, volume: 1e6)), isNull);
  });

  test('мало свечей — нет результата', () {
    expect(detector.analyze(_candles(_range, count: 40)), isNull);
  });
}
