import 'dart:math';

import '../../../home/data/models/candle.dart';
import '../indicators.dart';
import '../signal_side.dart';
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
///
/// Зеркально для лонга — перепроданность, при которой уходят продавцы:
/// RSI <= 20, падение за 24ч >= 2 хода, цена >= 1.5 хода под средней,
/// объём так же падает, а доля агрессивных продаж снижается.
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

    final rawRsi = wilderRsi(candles, period: _rsiPeriod);
    // RSI 20 и ниже — зеркальная перепроданность, сторона лонга.
    final side = rawRsi <= 100 - _minRsi ? SignalSide.long : SignalSide.short;
    // Для лонга всё зеркально: RSI ↔ 100 − RSI, рост ↔ падение.
    final sign = side.isLong ? -1.0 : 1.0;
    final rsi = side.isLong ? 100 - rawRsi : rawRsi;
    if (rsi < _minRsi) return null;

    final volatility = dailyVolatility(candles, bars: _weekBars);
    if (volatility < _minDailyVolatility) return null;
    final rise = log(close / candles[t - 24].close);
    final heat = sign * rise / volatility;
    if (heat < _minHeat) return null;
    var weekSum = 0.0;
    for (var k = t - _weekBars + 1; k <= t; k++) {
      weekSum += candles[k].close;
    }
    final stretch = sign * (close / (weekSum / _weekBars) - 1) / volatility;
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
    // Покупатели выдыхаются; для лонга — продавцы (доля покупок растёт).
    if (sign * buyers >= sign * previousBuyers) return null;

    return OverboughtSignal(
      side: side,
      rsi: rawRsi,
      rise24hPercent: (exp(rise) - 1) * 100,
      heat: heat,
      volumeChangePercent: (volumeRatio - 1) * 100,
      buyersSharePercent: buyers * 100,
      previousBuyersSharePercent: previousBuyers * 100,
    );
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
