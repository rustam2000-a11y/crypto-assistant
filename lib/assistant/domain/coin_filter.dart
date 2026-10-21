import 'dart:async';
import 'dart:math';

import '../../home/data/models/coin_model.dart';
import 'filter_type.dart';
import 'signal_side.dart';

abstract class CoinFilter {
  FutureOr<List<CoinModel>> filter(List<CoinModel> coins);

  /// [pumpReversal], [keyLevels], [overbought], [levelRadar] и [overload]
  /// работают с данными Binance, поэтому приходят из DI, а не создаются здесь.
  factory CoinFilter.forType(
    FilterType type, {
    required CoinFilter pumpReversal,
    required CoinFilter keyLevels,
    required CoinFilter overbought,
    required CoinFilter levelRadar,
    required CoinFilter overload,
  }) {
    switch (type) {
      case FilterType.abnormalMovement:
        return keyLevels;
      case FilterType.priceMovement:
        return pumpReversal;
      case FilterType.highVolatility:
        return OverheatedFadingFilter();
      case FilterType.historicalExtremum:
        return overbought;
      case FilterType.turnover:
        return PriceMovementFilter();
      case FilterType.capitalInflow:
        return overload;
      case FilterType.dailyExtremum:
        return levelRadar;
      case FilterType.confirmedAnomaly:
        return ConfirmedAnomalyFilter();
    }
  }
}

/// Фильтр, который к каждой монете из результата даёт пояснение (по id монеты),
/// например уровень или показатели перегрева.
abstract class DetailedCoinFilter implements CoinFilter {
  Map<String, Object> get details;
}

// Памп начинает выдыхаться (шорт) и зеркально — дамп начинает выдыхаться
// (лонг): для лонга рост ↔ падение, пик ↔ дно, RSI ↔ 100 − RSI.
class PriceMovementFilter implements DetailedCoinFilter {
  // Перегрев: во сколько раз рост превышает типичный дневной ход монеты.
  static const double _minHeat = 2;
  // Рост за 24ч или 7д должен быть заметным и в абсолюте, %.
  static const double _minRisePercent = 4;
  // Типичный дневной ход ниже — стейблкоины и привязанные активы, %.
  static const double _minDailyVolatility = 1;

  // Пик цены был не раньше, чем столько часов назад: вершина свежая.
  static const int _maxHoursSincePeak = 3;

  // RSI за сутки побывал в перекупленности...
  static const double _rsiOverbought = 80;
  // ...и сейчас уже загнулся вниз на столько пунктов...
  static const double _minRsiDrop = 3;
  // ...но ещё не обвалился (иначе разворот уже идёт полным ходом).
  static const double _maxRsiDrop = 12;

  // Цена чуть отошла от дневного максимума, но ещё рядом с ним
  // (в % от диапазона high-low).
  static const double _minPullbackPercent = 3;
  static const double _maxPullbackPercent = 20;

  // Статистика по sparkline считается один раз на fetch: copyWith с живой
  // ценой Binance сохраняет тот же список, поэтому кэш по нему переживает тики.
  final _statsCache = Expando<_SparklineStats>();

  Map<String, SignalSide> _details = const {};

  /// Сторона (шорт или лонг) каждой монеты из последнего результата.
  @override
  Map<String, SignalSide> get details => _details;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    _details = _sides(coins, _isStartingToFade);
    return coins.where((c) => _details.containsKey(c.id)).toList();
  }

  bool _isStartingToFade(CoinModel coin, SignalSide side) {
    final prices = coin.sparkline7d;
    final high = coin.high24h;
    final low = coin.low24h;
    final price = coin.currentPrice;
    if (prices.length < 48 || high == null || low == null || high <= low) {
      return false;
    }
    if (price <= 0) return false;

    // Для лонга изменения цены берём с обратным знаком: падение — это «рост».
    final sign = side.isLong ? -1.0 : 1.0;
    final change24h = sign * (coin.priceChangePercentage24h ?? 0);
    final change7d = sign * (coin.priceChangePercentage7d ?? 0);
    if (max(change24h, change7d) < _minRisePercent) return false;

    final stats = _statsCache[prices] ??= _SparklineStats.from(prices);
    final volatility = stats.dailyVolatility;
    if (volatility < _minDailyVolatility) return false;
    if (stats.lastPrice <= 0 || stats.price6hAgo <= 0) return false;

    // 1. Был перегрев: рост в типичных дневных ходах
    //    (за 7д типичный ход растёт как √7). Для лонга — такое же падение.
    final heat = max(
      change24h / volatility,
      change7d / (volatility * sqrt(7)),
    );
    if (heat < _minHeat) return false;

    // 2. Пик совсем свежий (для лонга — дно).
    final hoursSinceExtreme = side.isLong
        ? stats.hoursSinceTrough
        : stats.hoursSincePeak;
    if (hoursSinceExtreme > _maxHoursSincePeak) return false;

    // 3. RSI был в перекупленности и только начал загибаться.
    //    RSI считается по живой цене, а не по последней часовой точке.
    //    Для лонга — был в перепроданности (20 и ниже) и начал подниматься.
    final rsi = _mirrorRsi(stats.rsiAt(price), side);
    final rsiPeak24h = side.isLong
        ? 100 - stats.rsiTrough24h
        : stats.rsiPeak24h;
    final rsiDrop = rsiPeak24h - rsi;
    if (rsiPeak24h < _rsiOverbought) return false;
    if (rsiDrop < _minRsiDrop || rsiDrop > _maxRsiDrop) return false;

    // 4. Цена чуть отошла от максимума, но ещё у вершины.
    //    Если живая цена выше high24h, pullback < 0 — рост продолжается.
    //    Для лонга — чуть отскочила от минимума, но ещё у дна.
    final pullback =
        (side.isLong ? price - low : high - price) / (high - low) * 100;
    if (pullback < _minPullbackPercent || pullback > _maxPullbackPercent) {
      return false;
    }

    // 5. Первый разворот: живая цена ниже последней часовой точки,
    //    но за 6 часов ещё рост (иначе затухание идёт уже давно).
    //    Для лонга — выше последней точки, но за 6 часов ещё падение.
    if (sign * price >= sign * stats.lastPrice) return false;
    final change6h = sign * (price / stats.price6hAgo - 1) * 100;
    if (change6h <= 0) return false;

    return true;
  }
}

/// Монеты, прошедшие [matches] хотя бы с одной стороны: сначала проверяется
/// шорт (перегрев), затем зеркальный лонг (перепроданность).
Map<String, SignalSide> _sides(
  List<CoinModel> coins,
  bool Function(CoinModel coin, SignalSide side) matches,
) {
  final sides = <String, SignalSide>{};
  for (final coin in coins) {
    for (final side in SignalSide.values) {
      if (matches(coin, side)) {
        sides[coin.id] = side;
        break;
      }
    }
  }
  return sides;
}

// Для лонга RSI зеркалится: перепроданность 20 — как перекупленность 80.
double _mirrorRsi(double rsi, SignalSide side) => side.isLong ? 100 - rsi : rsi;

class _SparklineStats {
  const _SparklineStats({
    required this.dailyVolatility,
    required this.average,
    required this.rsi,
    required this.rsiPeak24h,
    required this.rsiTrough24h,
    required this.hoursSincePeak,
    required this.hoursSinceTrough,
    required this.price6hAgo,
    required this.lastPrice,
    required this.avgGain,
    required this.avgLoss,
  });

  factory _SparklineStats.from(List<double> prices) {
    final hourlyMoves = <double>[];
    for (var i = 1; i < prices.length; i++) {
      if (prices[i - 1] > 0 && prices[i] > 0) {
        hourlyMoves.add(log(prices[i] / prices[i - 1]).abs());
      }
    }
    // Медиана × 1.4826 ≈ стандартное отклонение, но не раздувается самим пампом.
    final hourlyVolatility = _median(hourlyMoves) * 1.4826;
    final rsi = _rsiSeries(prices, _rsiPeriod);

    // Сколько часов назад была максимальная и минимальная цена
    // за последние 24 точки.
    final last24 = prices.sublist(max(0, prices.length - 24));
    var peakIndex = 0;
    var troughIndex = 0;
    for (var i = 1; i < last24.length; i++) {
      if (last24[i] >= last24[peakIndex]) peakIndex = i;
      if (last24[i] <= last24[troughIndex]) troughIndex = i;
    }
    final rsi24h = rsi.values.skip(max(0, rsi.values.length - 24));

    return _SparklineStats(
      dailyVolatility: hourlyVolatility * sqrt(24) * 100,
      average: prices.reduce((a, b) => a + b) / prices.length,
      rsi: rsi.values.last,
      rsiPeak24h: rsi24h.reduce(max),
      rsiTrough24h: rsi24h.reduce(min),
      hoursSincePeak: last24.length - 1 - peakIndex,
      hoursSinceTrough: last24.length - 1 - troughIndex,
      price6hAgo: prices[prices.length - 7],
      lastPrice: prices.last,
      avgGain: rsi.avgGain,
      avgLoss: rsi.avgLoss,
    );
  }

  static const int _rsiPeriod = 14;

  final double dailyVolatility; // типичный дневной ход, %
  final double average; // средняя цена за 7 дней
  final double rsi; // RSI(14) по последней часовой точке
  final double rsiPeak24h; // максимум RSI за последние 24 часа
  final double rsiTrough24h; // минимум RSI за последние 24 часа
  final int hoursSincePeak; // сколько часов назад был пик цены (0 — последняя точка)
  final int hoursSinceTrough; // сколько часов назад было дно цены
  final double price6hAgo;
  final double lastPrice; // последняя часовая точка sparkline
  // Средние рост и падение по Уайлдеру на последней часовой точке.
  final double avgGain;
  final double avgLoss;

  // RSI(14) по часам на текущий момент: живая цена считается закрытием
  // часовой свечи, которая ещё не закрылась после последней точки sparkline.
  double rsiAt(double price) {
    final change = price - lastPrice;
    final gain = (avgGain * (_rsiPeriod - 1) + max(change, 0.0)) / _rsiPeriod;
    final loss = (avgLoss * (_rsiPeriod - 1) + max(-change, 0.0)) / _rsiPeriod;
    return _rsiValue(gain, loss);
  }

  static double _median(List<double> values) {
    if (values.isEmpty) return 0;
    final sorted = [...values]..sort();
    final mid = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[mid]
        : (sorted[mid - 1] + sorted[mid]) / 2;
  }

  // RSI со сглаживанием Уайлдера; первое значение — на свече с индексом period.
  // Вместе с рядом возвращает средние на последней свече — для живого RSI.
  static ({List<double> values, double avgGain, double avgLoss}) _rsiSeries(
      List<double> prices,
      int period,
      ) {
    var gain = 0.0;
    var loss = 0.0;
    for (var i = 1; i <= period; i++) {
      final change = prices[i] - prices[i - 1];
      gain += max(change, 0.0);
      loss += max(-change, 0.0);
    }
    gain /= period;
    loss /= period;

    final result = [_rsiValue(gain, loss)];
    for (var i = period + 1; i < prices.length; i++) {
      final change = prices[i] - prices[i - 1];
      gain = (gain * (period - 1) + max(change, 0.0)) / period;
      loss = (loss * (period - 1) + max(-change, 0.0)) / period;
      result.add(_rsiValue(gain, loss));
    }
    return (values: result, avgGain: gain, avgLoss: loss);
  }

  static double _rsiValue(double gain, double loss) =>
      loss == 0 ? 100 : 100 - 100 / (1 + gain / loss);
}

// Перегрев и затухание: монета выросла необычно сильно для своей волатильности,
// и сработали минимум 3 из 4 сигналов затухания импульса (шорт).
// Зеркально для лонга: монета необычно сильно упала, и падение затухает.
class OverheatedFadingFilter implements DetailedCoinFilter {
  // Перегрев: во сколько раз рост превышает типичный дневной ход монеты.
  static const double _minHeat = 2;
  // Рост за 24ч или 7д должен быть заметным и в абсолюте, %.
  static const double _minRisePercent = 4;
  // Типичный дневной ход ниже — стейблкоины и привязанные активы, %.
  static const double _minDailyVolatility = 1;
  // Сколько сигналов затухания из 4 должно сработать.
  static const int _minSignals = 3;

  static const double _rsiOverbought = 85;
  static const double _rsiDrop = 5;
  static const double _minPullbackPercent = 15;
  static const double _maxPullbackPercent = 50;
  static const double _minStretch = 1.5;

  // Статистика по sparkline считается один раз на fetch: copyWith с живой
  // ценой Binance сохраняет тот же список, поэтому кэш по нему переживает тики.
  final _statsCache = Expando<_SparklineStats>();

  Map<String, SignalSide> _details = const {};

  /// Сторона (шорт или лонг) каждой монеты из последнего результата.
  @override
  Map<String, SignalSide> get details => _details;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    _details = _sides(coins, _isOverheatedAndFading);
    return coins.where((c) => _details.containsKey(c.id)).toList();
  }

  bool _isOverheatedAndFading(CoinModel coin, SignalSide side) {
    final prices = coin.sparkline7d;
    final high = coin.high24h;
    final low = coin.low24h;
    if (prices.length < 48 || high == null || low == null || high <= low) {
      return false;
    }
    if (coin.currentPrice == 0) return false;

    // Для лонга изменения цены берём с обратным знаком: падение — это «рост».
    final sign = side.isLong ? -1.0 : 1.0;
    final change24h = sign * (coin.priceChangePercentage24h ?? 0);
    final change7d = sign * (coin.priceChangePercentage7d ?? 0);
    if (max(change24h, change7d) < _minRisePercent) return false;

    final stats = _statsCache[prices] ??= _SparklineStats.from(prices);
    final volatility = stats.dailyVolatility;
    if (volatility < _minDailyVolatility) return false;
    // Уже упала сильнее обычного дневного хода — откат состоялся, поздно.
    // Для лонга — уже отскочила сильнее обычного хода.
    if (change24h < -volatility) return false;

    // 1. Перегрев: рост в типичных дневных ходах (за 7д ход растёт как √7).
    //    Для лонга — такое же падение.
    final heat = max(
      change24h / volatility,
      change7d / (volatility * sqrt(7)),
    );
    if (heat < _minHeat) return false;

    // 2. Затухание: считаем сработавшие сигналы.
    var signals = 0;

    // RSI был в перекупленности и разворачивается вниз.
    // Для лонга — был в перепроданности (15 и ниже) и разворачивается вверх.
    final rsi = _mirrorRsi(stats.rsi, side);
    final rsiPeak24h = side.isLong
        ? 100 - stats.rsiTrough24h
        : stats.rsiPeak24h;
    if (rsiPeak24h >= _rsiOverbought && rsi <= rsiPeak24h - _rsiDrop) {
      signals++;
    }

    // Цена отошла от дневного максимума (в % от диапазона high-low).
    // Для лонга — отскочила от дневного минимума.
    final pullback =
        (side.isLong ? coin.currentPrice - low : high - coin.currentPrice) /
        (high - low) *
        100;
    if (pullback >= _minPullbackPercent && pullback <= _maxPullbackPercent) {
      signals++;
    }

    // Импульс погас: последний час и последние 6 часов в минусе.
    // Для лонга — в плюсе.
    final change1h = sign * (coin.priceChangePercentage1h ?? 0);
    final change6h = sign * (coin.currentPrice / stats.price6hAgo - 1) * 100;
    if (change1h < 0 && change6h < 0) signals++;

    // Цена оторвалась от средней за 7 дней (в типичных дневных ходах).
    // Для лонга — ушла под среднюю.
    final stretch =
        sign * (coin.currentPrice / stats.average - 1) * 100 / volatility;
    if (stretch > _minStretch) signals++;

    return signals >= _minSignals;
  }
}

// Подтверждённая аномалия: аномальное движение цены, подтверждённое высоким объёмом торгов.
class ConfirmedAnomalyFilter implements CoinFilter {
  static const double _priceThresholdPercent = 7;
  static const double _turnoverThresholdRatio = 0.3;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins.where((coin) {
      final priceAnomaly = (coin.priceChangePercentage24h ?? 0).abs() > _priceThresholdPercent;
      if (!priceAnomaly || coin.marketCap == 0) return false;
      final turnoverRatio = coin.totalVolume / coin.marketCap;
      return turnoverRatio > _turnoverThresholdRatio;
    }).toList();
  }
}
