import 'dart:math';

import 'package:crypto_assistant/assistant/domain/key_levels/key_level_detector.dart';
import 'package:crypto_assistant/assistant/domain/level_radar/level_approach.dart';
import 'package:crypto_assistant/assistant/domain/level_radar/level_radar.dart';
import 'package:crypto_assistant/home/data/models/candle.dart';
import 'package:flutter_test/flutter_test.dart';

const _bars = KeyLevelDetector.candlesLimit;
const _hour = 60 * 60 * 1000;

/// 4ч свечи: цена ходит между 100 и 130 (крупные развороты), у вершины —
/// в 5 раз больший объём: на отскоках от неё «крупный капитал».
List<Candle> _range4h() {
  double price(int k) {
    final phase = k % 24;
    return 100 + (phase <= 12 ? phase : 24 - phase) * 2.5;
  }

  return [
    for (var k = 0; k < _bars; k++)
      () {
        final open = price(max(0, k - 1));
        final close = price(k);
        final volume = close >= 125 ? 5e7 : 1e7;
        return Candle(
          openTime: k * 4 * _hour,
          closeTime: (k + 1) * 4 * _hour - 1,
          open: open,
          high: max(open, close) + 0.1,
          low: min(open, close) - 0.1,
          close: close,
          quoteVolume: volume,
          takerBuyQuoteVolume: volume / 2,
        );
      }(),
  ];
}

/// Последние 30 часов: цена стояла на [from], за последние 4 часа дошла до
/// [to]; [spikeHigh] — максимум одной из свечей последних 8 часов.
List<Candle> _hourly({
  required double from,
  required double to,
  double? spikeHigh,
}) {
  return [
    for (var k = 0; k < 30; k++)
      () {
        final close = k <= 25 ? from : from + (to - from) * (k - 25) / 4;
        return Candle(
          openTime: k * _hour,
          closeTime: (k + 1) * _hour - 1,
          open: close,
          high: k == 27 && spikeHigh != null ? spikeHigh : close + 0.05,
          low: close - 0.05,
          close: close,
          quoteVolume: 1000,
          takerBuyQuoteVolume: 500,
        );
      }(),
  ];
}

void main() {
  const detector = KeyLevelDetector();
  const radar = LevelRadar();
  final candles = _range4h();
  final analysis = detector.analyze(candles)!;

  LevelApproach? run(List<Candle> hourly, double price) =>
      radar.approach(analysis: analysis, hourly: hourly, price: price);

  test('объём на свечах отскока: у вершины крупный, у дна обычный', () {
    final levels = [...analysis.levels]
      ..sort((a, b) => a.price.compareTo(b.price));
    expect(levels.first.volumeMultiple, closeTo(1, 0.01));
    expect(levels.last.volumeMultiple, closeTo(5, 0.01));
  });

  test('на уровне без крупного объёма на отскоках — нет сигнала', () {
    expect(run(_hourly(from: 100, to: 100), 100), isNull);
  });

  test('цена уже на сильном уровне', () {
    final approach = run(_hourly(from: 130, to: 130), 130)!;
    expect(approach.isAtLevel, isTrue);
    expect(approach.isResistance, isTrue);
    expect(approach.levelPrice, closeTo(130.1, 0.01));
    expect(approach.volumeMultiple, greaterThan(1.5));
  });

  test('цена подходит: до уровня меньше 1% и идёт к нему', () {
    final approach = run(_hourly(from: 128.5, to: 129.3), 129.3)!;
    expect(approach.isAtLevel, isFalse);
    expect(approach.distancePercent, lessThan(1));
  });

  test('цена рядом, но уходит от уровня — нет сигнала', () {
    expect(run(_hourly(from: 129.6, to: 129.3), 129.3), isNull);
  });

  test('за 8 часов уже касалась уровня — нет сигнала', () {
    final hourly = _hourly(from: 128.5, to: 129.3, spikeHigh: 130.2);
    expect(run(hourly, 129.3), isNull);
  });

  test('до уровня больше 1% — нет сигнала', () {
    expect(run(_hourly(from: 126, to: 128), 128), isNull);
  });
}
