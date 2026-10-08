import 'dart:math';

import 'package:crypto_assistant/assistant/domain/pump_reversal/pump_reversal_detector.dart';
import 'package:crypto_assistant/home/data/models/candle.dart';
import 'package:flutter_test/flutter_test.dart';

const _bars = 700;
const _barMs = 15 * 60 * 1000;

/// Пила ±[noise] вокруг 100, с [pump] (лог-рост) за последние 24ч до бара [pumpEnd].
List<double> _closes({double noise = 0.002, double pump = 0, int? pumpEnd}) {
  final end = pumpEnd ?? _bars;
  final start = end - PumpReversalDetector.barsPerDay;
  return [
    for (var k = 0; k < _bars; k++)
      100 *
          (1 + noise * (k.isEven ? 1 : -1)) *
          exp(pump * ((k.clamp(start, end) - start) / (end - start))),
  ];
}

List<Candle> _candles(List<double> closes, {double quoteVolume = 1000}) {
  return [
    for (var k = 0; k < closes.length; k++)
      _candle(
        k,
        open: k == 0 ? closes[0] : closes[k - 1],
        close: closes[k],
        quoteVolume: quoteVolume,
      ),
  ];
}

Candle _candle(
  int index, {
  required double open,
  required double close,
  double? high,
  double? low,
  double quoteVolume = 1000,
}) {
  return Candle(
    openTime: index * _barMs,
    closeTime: (index + 1) * _barMs - 1,
    open: open,
    high: high ?? max(open, close) * 1.001,
    low: low ?? min(open, close) * 0.999,
    close: close,
    quoteVolume: quoteVolume,
    takerBuyQuoteVolume: quoteVolume / 2,
  );
}

/// Памп, а последний час — свеча с длинной верхней тенью на объёме.
List<Candle> _wickRejection({double noise = 0.002}) {
  final candles = _candles(
    _closes(noise: noise, pump: 0.3, pumpEnd: _bars - 4),
  );
  final p = candles[_bars - 5].close;
  candles
    ..[_bars - 4] = _candle(
      _bars - 4,
      open: p,
      close: p,
      high: p * 1.06,
      low: p * 0.995,
      quoteVolume: 4000,
    )
    ..[_bars - 3] = _candle(_bars - 3, open: p, close: p, quoteVolume: 4000)
    ..[_bars - 2] = _candle(_bars - 2, open: p, close: p, quoteVolume: 4000)
    ..[_bars - 1] = _candle(
      _bars - 1,
      open: p,
      close: p * 0.99,
      low: p * 0.985,
      quoteVolume: 4000,
    );
  return candles;
}

/// Пик 2 часа назад, затем цена пробивает минимум последнего часа.
List<Candle> _structureBreak() {
  final candles = _candles(_closes(pump: 0.4, pumpEnd: _bars - 9));
  final p = candles[_bars - 10].close;
  candles[_bars - 9] = _candle(_bars - 9, open: p, close: p, high: p * 1.02);
  for (var k = _bars - 8; k < _bars - 1; k++) {
    candles[k] = _candle(k, open: p * 0.98, close: p * 0.98, low: p * 0.97);
  }
  candles[_bars - 1] = _candle(_bars - 1, open: p * 0.98, close: p * 0.95);
  return candles;
}

void main() {
  const detector = PumpReversalDetector();

  test('нет сигнала без пампа', () {
    expect(detector.detect(_candles(_closes())), isNull);
  });

  test('нет сигнала, если свечей меньше, чем нужно', () {
    final candles = _wickRejection();
    expect(detector.detect(candles.sublist(candles.length - 600)), isNull);
  });

  test('отбой длинной верхней тенью на объёме после пампа', () {
    expect(detector.detect(_wickRejection()), ReversalSetup.wickRejection);
  });

  test('слом структуры через 1–8 часов после пика', () {
    expect(detector.detect(_structureBreak()), ReversalSetup.structureBreak);
  });

  test('стейблкоин с почти нулевой волатильностью игнорируется', () {
    expect(detector.detect(_wickRejection(noise: 0.0001)), isNull);
  });

  test('high24h — максимум за последние 96 свечей', () {
    final candles = _wickRejection();
    expect(detector.high24h(candles), candles[_bars - 4].high);
  });
}
