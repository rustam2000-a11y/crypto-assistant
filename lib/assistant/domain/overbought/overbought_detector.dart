import 'dart:math';

import '../../../home/data/models/candle.dart';
import 'overbought_signal.dart';

/// Перегрев, при котором уходит ликвидность, по закрытым часовым свечам.
/// Все условия обязательные:
///  * RSI(14) >= 80;
///  * рост за 24ч >= 2 обычных дневных хода, цена >= 1.5 хода над средней
///    за 7 дней;
///  * средний часовой объём за 3ч на 30%+ ниже, чем за 6ч до них;
///  * доля агрессивных покупок за 3ч ниже, чем за 6ч до них.
///
/// На истории Binance (150 ликвидных монет, окт 2025 — сен 2026) — около
/// двух монет в день; через 1–4 часа цена была ниже примерно в половине
/// случаев, то есть это состояние монеты, а не прогноз падения.
class OverboughtDetector {
  const OverboughtDetector();

  static const int _rsiPeriod = 14;
  static const int _weekBars = 168;
  static const int _recentBars = 3;
  static const int _previousBars = 6;

  static const double _minRsi = 80;
  static const double _minHeat = 2;
  static const double _minStretch = 1.5;
  static const double _maxVolumeRatio = 0.7;
  // Ниже — стейблкоины и привязанные активы.
  static const double _minDailyVolatility = 0.01;

  static const int requiredCandles = _weekBars + 1;

  OverboughtSignal? detect(List<Candle> candles) {
    if (candles.length < requiredCandles) return null;
    final t = candles.length - 1;
    final close = candles[t].close;

    final rsi = _rsi(candles);
    if (rsi < _minRsi) return null;

    final volatility = _dailyVolatility(candles, t);
    if (volatility < _minDailyVolatility) return null;
    final rise = log(close / candles[t - 24].close);
    final heat = rise / volatility;
    if (heat < _minHeat) return null;
    var weekSum = 0.0;
    for (var k = t - _weekBars + 1; k <= t; k++) {
      weekSum += candles[k].close;
    }
    final stretch = (close / (weekSum / _weekBars) - 1) / volatility;
    if (stretch < _minStretch) return null;

    final recent = _flow(candles, t - _recentBars + 1, t);
    final previous = _flow(
      candles,
      t - _recentBars - _previousBars + 1,
      t - _recentBars,
    );
    if (recent.volume <= 0 || previous.volume <= 0) return null;
    final volumeRatio =
        (recent.volume / _recentBars) / (previous.volume / _previousBars);
    if (volumeRatio > _maxVolumeRatio) return null;
    final buyers = recent.buys / recent.volume;
    final previousBuyers = previous.buys / previous.volume;
    if (buyers >= previousBuyers) return null;

    return OverboughtSignal(
      rsi: rsi,
      rise24hPercent: (exp(rise) - 1) * 100,
      heat: heat,
      volumeChangePercent: (volumeRatio - 1) * 100,
      buyersSharePercent: buyers * 100,
      previousBuyersSharePercent: previousBuyers * 100,
    );
  }

  // RSI Уайлдера по всей истории: экспоненциальное сглаживание 1/14,
  // первое изменение считается нулевым.
  static double _rsi(List<Candle> c) {
    const alpha = 1 / _rsiPeriod;
    var gain = 0.0;
    var loss = 0.0;
    for (var k = 1; k < c.length; k++) {
      final change = c[k].close - c[k - 1].close;
      gain = (1 - alpha) * gain + alpha * max(change, 0.0);
      loss = (1 - alpha) * loss + alpha * max(-change, 0.0);
    }
    return loss == 0 ? 100 : 100 - 100 / (1 + gain / loss);
  }

  // Медиана |часовых лог-доходностей| за неделю × 1.4826 × √24 — обычный
  // дневной ход без влияния самого пампа (в долях).
  static double _dailyVolatility(List<Candle> c, int t) {
    final moves = <double>[
      for (var k = t - _weekBars + 1; k <= t; k++)
        log(c[k].close / c[k - 1].close).abs(),
    ]..sort();
    final mid = moves.length ~/ 2;
    final median = moves.length.isOdd
        ? moves[mid]
        : (moves[mid - 1] + moves[mid]) / 2;
    return median * 1.4826 * sqrt(24);
  }

  static ({double volume, double buys}) _flow(
    List<Candle> c,
    int from,
    int to,
  ) {
    var volume = 0.0;
    var buys = 0.0;
    for (var k = from; k <= to; k++) {
      volume += c[k].quoteVolume;
      buys += c[k].takerBuyQuoteVolume;
    }
    return (volume: volume, buys: buys);
  }
}
