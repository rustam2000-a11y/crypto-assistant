import 'dart:math';

import 'package:crypto_assistant/assistant/domain/overbought/overbought_detector.dart';
import 'package:crypto_assistant/home/data/models/candle.dart';
import 'package:flutter_test/flutter_test.dart';

const _bars = 540;
const _hourMs = 60 * 60 * 1000;
const _pumpBars = 30;

/// Неделями цена ходит пилой ±0.3% у 100, последние 30 часов растёт на 1%
/// в час. Объём и доля покупок: [pumpVolume]/[pumpBuys] в разгар роста
/// (часы -9..-4), [lastVolume]/[lastBuys] — последние 3 часа.
List<Candle> _pump({
  double pumpVolume = 3000,
  double pumpBuys = 0.7,
  double lastVolume = 1000,
  double lastBuys = 0.45,
  bool rising = true,
}) {
  double close(int k) {
    final noise = 1 + 0.003 * (k.isEven ? 1 : -1);
    final grown = rising ? max(0, k - (_bars - _pumpBars)) : 0;
    return 100 * noise * exp(0.01 * grown);
  }

  return [
    for (var k = 0; k < _bars; k++)
      () {
        final open = close(max(0, k - 1));
        final volume = k >= _bars - 3
            ? lastVolume
            : (k >= _bars - 9 ? pumpVolume : 1000.0);
        final buys = k >= _bars - 3
            ? lastBuys
            : (k >= _bars - 9 ? pumpBuys : 0.5);
        return Candle(
          openTime: k * _hourMs,
          closeTime: (k + 1) * _hourMs - 1,
          open: open,
          high: max(open, close(k)) * 1.001,
          low: min(open, close(k)) * 0.999,
          close: close(k),
          quoteVolume: volume,
          takerBuyQuoteVolume: volume * buys,
        );
      }(),
  ];
}

void main() {
  const detector = OverboughtDetector();

  test('перегрев с уходящими объёмом и покупателями — сигнал', () {
    final signal = detector.detect(_pump())!;
    expect(signal.rsi, greaterThanOrEqualTo(80));
    expect(signal.heat, greaterThanOrEqualTo(2));
    expect(signal.volumeChangePercent, closeTo(-66.7, 0.1));
    expect(signal.buyersSharePercent, closeTo(45, 0.01));
    expect(signal.previousBuyersSharePercent, closeTo(70, 0.01));
  });

  test('без роста RSI ниже 80 — сигнала нет', () {
    expect(detector.detect(_pump(rising: false)), isNull);
  });

  test('объём не падает — ликвидность не уходит', () {
    expect(detector.detect(_pump(lastVolume: 2500)), isNull);
  });

  test('доля покупок растёт — покупатели не выдохлись', () {
    expect(detector.detect(_pump(lastBuys: 0.8)), isNull);
  });

  test('мало свечей — нет результата', () {
    expect(detector.detect(_pump().sublist(_bars - 100)), isNull);
  });
}
