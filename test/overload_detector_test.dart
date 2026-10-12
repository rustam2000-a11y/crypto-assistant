import 'dart:math';

import 'package:crypto_assistant/assistant/domain/overload/overload_detector.dart';
import 'package:crypto_assistant/assistant/domain/overload/overload_signal.dart';
import 'package:crypto_assistant/home/data/models/candle.dart';
import 'package:flutter_test/flutter_test.dart';

const _hour = 60 * 60 * 1000;

/// Часовые свечи: пила ±0.5% у 100, последние [climbHours] часов — рост
/// на 1% в час; объём последних 2 часов — [lastVolume].
List<Candle> _hourly({
  int climbHours = 30,
  double lastVolume = 3000,
  bool fallLast6h = false,
}) {
  const bars = 540;
  double close(int k) {
    final noise = 1 + 0.005 * (k.isEven ? 1 : -1);
    var grown = max(0, k - (bars - climbHours)).toDouble();
    if (fallLast6h && k > bars - 7) grown -= (k - (bars - 7)) * 2;
    return 100 * noise * exp(0.01 * grown);
  }

  return [
    for (var k = 0; k < bars; k++)
      () {
        final open = close(max(0, k - 1));
        final volume = k >= bars - 2 ? lastVolume : 1000.0;
        return Candle(
          openTime: k * _hour,
          closeTime: (k + 1) * _hour - 1,
          open: open,
          high: max(open, close(k)) * 1.002,
          low: min(open, close(k)) * 0.998,
          close: close(k),
          quoteVolume: volume,
          takerBuyQuoteVolume: volume / 2,
        );
      }(),
  ];
}

/// 4ч свечи: ровно, затем [risingBars] свечей роста по 2%.
List<Candle> _fourHour({int risingBars = 8}) {
  const bars = 100;
  double close(int k) =>
      100 *
      (1 + 0.005 * (k.isEven ? 1 : -1)) *
      exp(0.02 * max(0, k - (bars - risingBars)));
  return [
    for (var k = 0; k < bars; k++)
      Candle(
        openTime: k * 4 * _hour,
        closeTime: (k + 1) * 4 * _hour - 1,
        open: close(max(0, k - 1)),
        high: max(close(max(0, k - 1)), close(k)) * 1.002,
        low: min(close(max(0, k - 1)), close(k)) * 0.998,
        close: close(k),
        quoteVolume: 1000,
        takerBuyQuoteVolume: 500,
      ),
  ];
}

void main() {
  const detector = OverloadDetector();

  test('все 7 признаков перегрузки', () {
    final signal = detector.detect(
      hourly: _hourly(),
      candles4h: _fourHour(),
      openInterestChange: 0.2,
      fundingRate: 0.0003,
      topTraderRatio: 2.5,
    )!;
    expect(signal.points, OverloadSign.values.toSet());
    expect(signal.rsi1h, greaterThanOrEqualTo(72));
    expect(signal.volumeSpike, closeTo(3, 0.01));
    expect(signal.squeezeRisk, isFalse);
  });

  test('без данных о плечах считаются только признаки цены и объёма', () {
    final signal = detector.detect(hourly: _hourly(), candles4h: _fourHour())!;
    expect(signal.points, {
      OverloadSign.extension,
      OverloadSign.rsi1h,
      OverloadSign.rsi4h,
      OverloadSign.volumeSpike,
    });
  });

  test('открытый интерес удвоился за сутки — предупреждение о сквизе', () {
    final signal = detector.detect(
      hourly: _hourly(),
      candles4h: _fourHour(),
      openInterestChange: 1.2,
    )!;
    expect(signal.squeezeRisk, isTrue);
  });

  test('меньше 3 признаков — монеты нет в списке', () {
    final signal = detector.detect(
      hourly: _hourly(lastVolume: 1000),
      candles4h: _fourHour(risingBars: 0),
    );
    expect(signal, isNull);
  });

  test('монета не разогнана — не перегружена', () {
    expect(detector.stretch(_hourly(climbHours: 0)), isNull);
  });

  test('за 6 часов цена упала — не разогнана', () {
    expect(detector.stretch(_hourly(fallLast6h: true)), isNull);
  });
}
