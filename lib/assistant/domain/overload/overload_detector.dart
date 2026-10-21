import 'dart:math';

import '../../../home/data/models/candle.dart';
import '../indicators.dart';
import '../signal_side.dart';
import 'overload_signal.dart';

/// Индекс перегрузки: сколько из 7 признаков перегрева и плеч горит у
/// разогнанной монеты. Пороги — верхние ~20% среди всех разогнанных монет на
/// истории Binance (150 ликвидных монет, окт 2025 — апр 2026), округлённые.
///
/// Это состояние монеты, а не прогноз: на истории откат после перегрузки
/// случался не чаще обычного, а при резком росте плеч рост чаще продолжался.
///
/// Зеркально для лонга — перегрузка вниз: монета разогнана под EMA20 и за
/// 6 часов в минусе, признаки те же с обратным знаком (RSI 1ч <= 28,
/// RSI 4ч <= 33, фандинг <= −0.02% — переплачивают шорты, лонг/шорт
/// топ-трейдеров <= 0.5); рост открытого интереса и всплеск объёма — как есть.
class OverloadDetector {
  const OverloadDetector();

  static const int minPoints = 3;
  static const int requiredHourly = 169;

  // Монета разогнана: цена выше EMA20 минимум на 1 ход и за 6 часов в плюсе.
  static const double _minStretch = 1;
  static const int _emaPeriod = 20;
  static const int _atrBars = 24;
  static const double _minDailyVolatility = 0.01;

  static const double _extensionAtr = 2.5;
  static const double _rsi1h = 72;
  static const double _rsi4h = 67;
  static const double _openInterestGrowth = 0.15;
  static const double _funding = 0.0002;
  static const double _topTraderRatio = 2;
  static const double _volumeSpike = 2;

  /// Цена выше EMA20 часового графика, в обычных часовых ходах, если монета
  /// разогнана (иначе null) — только для таких монет нужны данные о плечах.
  /// Монета, зеркально разогнанная вниз (под EMA20 и за 6 часов в минусе),
  /// даёт отрицательное значение — это сторона лонга.
  double? stretch(List<Candle> hourly) {
    if (hourly.length < requiredHourly) return null;
    if (dailyVolatility(hourly) < _minDailyVolatility) return null;
    final t = hourly.length - 1;
    final change6h = hourly[t].close - hourly[t - 6].close;
    final value = (hourly[t].close - _ema(hourly)) / _atr(hourly);
    if (change6h > 0 && value >= _minStretch) return value;
    if (change6h < 0 && value <= -_minStretch) return value;
    return null;
  }

  OverloadSignal? detect({
    required List<Candle> hourly,
    required List<Candle> candles4h,
    double? openInterestChange,
    double? fundingRate,
    double? topTraderRatio,
  }) {
    final stretched = stretch(hourly);
    if (stretched == null || candles4h.length < 15) return null;
    final side = stretched < 0 ? SignalSide.long : SignalSide.short;
    // Для лонга всё зеркально: RSI ↔ 100 − RSI, фандинг ↔ −фандинг,
    // лонг/шорт топ-трейдеров ↔ шорт/лонг.
    final sign = side.isLong ? -1.0 : 1.0;
    double mirrorRsi(double rsi) => side.isLong ? 100 - rsi : rsi;
    final crowdRatio = side.isLong && topTraderRatio != null
        ? 1 / topTraderRatio
        : topTraderRatio;
    final extension = stretched.abs();
    final rsi1h = wilderRsi(hourly);
    final rsi4h = wilderRsi(candles4h);
    final t = hourly.length - 1;
    var recent = 0.0;
    var before = 0.0;
    for (var k = t - 1; k <= t; k++) {
      recent += hourly[k].quoteVolume;
    }
    for (var k = t - 7; k <= t - 2; k++) {
      before += hourly[k].quoteVolume;
    }
    final volumeSpike = before > 0 ? (recent / 2) / (before / 6) : 0.0;

    final points = {
      if (extension >= _extensionAtr) OverloadSign.extension,
      if (mirrorRsi(rsi1h) >= _rsi1h) OverloadSign.rsi1h,
      if (mirrorRsi(rsi4h) >= _rsi4h) OverloadSign.rsi4h,
      if ((openInterestChange ?? 0) >= _openInterestGrowth)
        OverloadSign.openInterest,
      if (sign * (fundingRate ?? 0) >= _funding) OverloadSign.funding,
      if ((crowdRatio ?? 0) >= _topTraderRatio) OverloadSign.topTraders,
      if (volumeSpike >= _volumeSpike) OverloadSign.volumeSpike,
    };
    if (points.length < minPoints) return null;
    return OverloadSignal(
      side: side,
      points: points,
      extension: extension,
      rsi1h: rsi1h,
      rsi4h: rsi4h,
      volumeSpike: volumeSpike,
      openInterestChange: openInterestChange,
      fundingRate: fundingRate,
      topTraderRatio: topTraderRatio,
    );
  }

  static double _ema(List<Candle> c) {
    const alpha = 2 / (_emaPeriod + 1);
    var ema = c.first.close;
    for (var k = 1; k < c.length; k++) {
      ema = alpha * c[k].close + (1 - alpha) * ema;
    }
    return ema;
  }

  // Средний истинный диапазон часовой свечи за сутки.
  static double _atr(List<Candle> c) {
    var sum = 0.0;
    for (var k = c.length - _atrBars; k < c.length; k++) {
      final previous = c[k - 1].close;
      sum += [
        c[k].high - c[k].low,
        (c[k].high - previous).abs(),
        (c[k].low - previous).abs(),
      ].reduce(max);
    }
    return sum / _atrBars;
  }
}
