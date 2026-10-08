import 'dart:math';

import '../../../home/data/models/candle.dart';

/// Какой паттерн разворота сработал.
enum ReversalSetup {
  /// Новый 24ч максимум отбит длинной верхней тенью на всплеске объёма.
  wickRejection,

  /// Пик был 1–8 часов назад, и цена пробила минимум последнего часа.
  structureBreak,
}

/// Разворот после пампа по закрытым 15-минутным свечам.
///
/// Параметры подобраны и проверены на истории Binance USDT-M Futures
/// (окт 2025 — июнь 2026): шорт по открытию следующей свечи, выход через
/// 3–4 часа. Сигнал имеет смысл только вместе с фильтрами рынка и режима
/// (см. PumpReversalFilter), без них на растущем рынке он убыточен.
class PumpReversalDetector {
  const PumpReversalDetector();

  static const int barsPerHour = 4;
  static const int barsPerDay = 96;
  static const int _volatilityWindow = barsPerDay * 7;

  /// Сколько закрытых свечей нужно для расчёта.
  static const int requiredCandles = _volatilityWindow + 1;

  // Типичный дневной ход ниже — стейблкоины: там «перегрев» — это шум.
  static const double _minDailyVolatility = 0.01;
  // Перегрев: рост за 24ч в типичных дневных ходах монеты.
  static const double _minHeatWick = 3;
  static const double _minHeatBreak = 4;
  // Верхняя тень часовой свечи — доля её диапазона.
  static const double _minUpperWick = 0.55;
  // Оборот за последний час к среднему часовому обороту за 7 дней.
  static const double _minVolumeSpike = 3;
  // Пик 24ч был не ближе 1 часа (high1h < high24h) и не дальше 8 часов назад.
  static const int _breakPeakMaxBars = barsPerHour * 8;
  // Откат от пика — в типичных дневных ходах.
  static const double _minBreakDrawdown = 1;

  ReversalSetup? detect(List<Candle> candles) {
    if (candles.length < requiredCandles) return null;
    final i = candles.length - 1;
    final last = candles[i];

    final dailyVolatility = _dailyVolatility(candles, i);
    if (dailyVolatility < _minDailyVolatility) return null;
    final dayAgo = candles[i - barsPerDay].close;
    final heat = log(last.close / dayAgo) / dailyVolatility;

    final high24h = _maxHigh(candles, i - barsPerDay + 1, i);
    final high1h = _maxHigh(candles, i - barsPerHour + 1, i);

    if (high1h >= high24h &&
        heat >= _minHeatWick &&
        _upperWick1h(candles, i) >= _minUpperWick &&
        _volumeSpike1h(candles, i) >= _minVolumeSpike) {
      return ReversalSetup.wickRejection;
    }

    final peakRecent = _maxHigh(candles, i - _breakPeakMaxBars + 1, i);
    final lowBefore = _minLow(candles, i - barsPerHour, i - 1);
    final drawdown = (high24h - last.close) / last.close / dailyVolatility;
    if (high1h < high24h &&
        peakRecent >= high24h &&
        heat >= _minHeatBreak &&
        last.close < lowBefore &&
        drawdown >= _minBreakDrawdown) {
      return ReversalSetup.structureBreak;
    }
    return null;
  }

  /// Максимум цены за 24ч — над ним ставится аварийный стоп.
  double high24h(List<Candle> candles) {
    final i = candles.length - 1;
    return _maxHigh(candles, i - barsPerDay + 1, i);
  }

  // Медиана |15m лог-доходностей| за 7 дней × 1.4826 ≈ σ без влияния пампа,
  // × √96 — в дневном масштабе (в долях, не в %).
  static double _dailyVolatility(List<Candle> c, int i) {
    final moves = <double>[
      for (var k = i - _volatilityWindow + 1; k <= i; k++)
        log(c[k].close / c[k - 1].close).abs(),
    ]..sort();
    final mid = moves.length ~/ 2;
    final median = moves.length.isOdd
        ? moves[mid]
        : (moves[mid - 1] + moves[mid]) / 2;
    return median * 1.4826 * sqrt(barsPerDay);
  }

  static double _upperWick1h(List<Candle> c, int i) {
    final high = _maxHigh(c, i - barsPerHour + 1, i);
    final low = _minLow(c, i - barsPerHour + 1, i);
    if (high <= low) return 0;
    final open = c[i - barsPerHour + 1].open;
    return (high - max(open, c[i].close)) / (high - low);
  }

  static double _volumeSpike1h(List<Candle> c, int i) {
    var hour = 0.0;
    for (var k = i - barsPerHour + 1; k <= i; k++) {
      hour += c[k].quoteVolume;
    }
    var week = 0.0;
    for (var k = i - _volatilityWindow + 1; k <= i; k++) {
      week += c[k].quoteVolume;
    }
    final hourlyAverage = week / (_volatilityWindow / barsPerHour);
    return hourlyAverage > 0 ? hour / hourlyAverage : 0;
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
}
