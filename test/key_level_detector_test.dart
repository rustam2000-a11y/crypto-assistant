import 'dart:math';

import 'package:crypto_assistant/assistant/domain/key_levels/key_level_detector.dart';
import 'package:crypto_assistant/home/data/models/candle.dart';
import 'package:flutter_test/flutter_test.dart';

const _bars = 540;
const _hourMs = 60 * 60 * 1000;

/// Часовые свечи по ценам закрытия: open — прошлое закрытие, тени по 0.1.
List<Candle> _candles(double Function(int k) price) {
  return [
    for (var k = 0; k < _bars; k++)
      () {
        final open = price(max(0, k - 1));
        final close = price(k);
        return Candle(
          openTime: k * _hourMs,
          closeTime: (k + 1) * _hourMs - 1,
          open: open,
          high: max(open, close) + 0.1,
          low: min(open, close) - 0.1,
          close: close,
          quoteVolume: 1000,
          takerBuyQuoteVolume: 500,
        );
      }(),
  ];
}

/// Цена ходит между 100 и 110: 20 часов вверх, 20 часов вниз.
double _range(int k) {
  final phase = k % 40;
  return 100 + (phase <= 20 ? phase : 40 - phase) * 0.5;
}

void main() {
  const detector = KeyLevelDetector();

  test('у верхней границы — сопротивление и коридор', () {
    final level = detector.nearestLevel(_candles(_range), 109.8)!;
    expect(level.isResistance, isTrue);
    expect(level.price, closeTo(110.1, 0.01));
    expect(level.touches, greaterThanOrEqualTo(5));
    expect(level.corridor, isNotNull);
    expect(level.corridor!.low, closeTo(99.9, 0.01));
  });

  test('у нижней границы — поддержка', () {
    final level = detector.nearestLevel(_candles(_range), 100.2)!;
    expect(level.isResistance, isFalse);
    expect(level.price, closeTo(99.9, 0.01));
    expect(level.distancePercent, closeTo(0.3, 0.01));
  });

  test('в середине коридора уровня рядом нет', () {
    expect(detector.nearestLevel(_candles(_range), 105), isNull);
  });

  test('ровный тренд без повторных разворотов — уровней нет', () {
    final candles = _candles((k) => 100 + k * 0.2);
    expect(detector.nearestLevel(candles, candles.last.close), isNull);
  });

  test('мало свечей — нет результата', () {
    final candles = _candles(_range).sublist(0, 40);
    expect(detector.nearestLevel(candles, 109.8), isNull);
  });
}
