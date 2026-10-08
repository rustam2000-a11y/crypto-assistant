import 'dart:async';
import 'dart:math';

import '../../home/data/models/coin_model.dart';
import 'filter_type.dart';

abstract class CoinFilter {
  FutureOr<List<CoinModel>> filter(List<CoinModel> coins);

  /// [pumpReversal], [keyLevels] и [overbought] работают со свечами Binance,
  /// поэтому приходят из DI, а не создаются здесь.
  factory CoinFilter.forType(
    FilterType type, {
    required CoinFilter pumpReversal,
    required CoinFilter keyLevels,
    required CoinFilter overbought,
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
        return CapitalInflowFilter();
      case FilterType.dailyExtremum:
        return DailyExtremumFilter();
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

class PriceMovementFilter implements CoinFilter {
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

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins.where(_isStartingToFade).toList();
  }

  bool _isStartingToFade(CoinModel coin) {
    final prices = coin.sparkline7d;
    final high = coin.high24h;
    final low = coin.low24h;
    final price = coin.currentPrice;
    if (prices.length < 48 || high == null || low == null || high <= low) {
      return false;
    }
    if (price <= 0) return false;

    final change24h = coin.priceChangePercentage24h ?? 0;
    final change7d = coin.priceChangePercentage7d ?? 0;
    if (max(change24h, change7d) < _minRisePercent) return false;

    final stats = _statsCache[prices] ??= _SparklineStats.from(prices);
    final volatility = stats.dailyVolatility;
    if (volatility < _minDailyVolatility) return false;
    if (stats.lastPrice <= 0 || stats.price6hAgo <= 0) return false;

    // 1. Был перегрев: рост в типичных дневных ходах
    //    (за 7д типичный ход растёт как √7).
    final heat = max(
      change24h / volatility,
      change7d / (volatility * sqrt(7)),
    );
    if (heat < _minHeat) return false;

    // 2. Пик совсем свежий.
    if (stats.hoursSincePeak > _maxHoursSincePeak) return false;

    // 3. RSI был в перекупленности и только начал загибаться.
    //    RSI считается по живой цене, а не по последней часовой точке.
    final rsi = stats.rsiAt(price);
    final rsiDrop = stats.rsiPeak24h - rsi;
    if (stats.rsiPeak24h < _rsiOverbought) return false;
    if (rsiDrop < _minRsiDrop || rsiDrop > _maxRsiDrop) return false;

    // 4. Цена чуть отошла от максимума, но ещё у вершины.
    //    Если живая цена выше high24h, pullback < 0 — рост продолжается.
    final pullback = (high - price) / (high - low) * 100;
    if (pullback < _minPullbackPercent || pullback > _maxPullbackPercent) {
      return false;
    }

    // 5. Первый разворот: живая цена ниже последней часовой точки,
    //    но за 6 часов ещё рост (иначе затухание идёт уже давно).
    if (price >= stats.lastPrice) return false;
    final change6h = (price / stats.price6hAgo - 1) * 100;
    if (change6h <= 0) return false;

    return true;
  }
}

class _SparklineStats {
  const _SparklineStats({
    required this.dailyVolatility,
    required this.average,
    required this.rsi,
    required this.rsiPeak24h,
    required this.hoursSincePeak,
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

    // Сколько часов назад была максимальная цена за последние 24 точки.
    final last24 = prices.sublist(max(0, prices.length - 24));
    var peakIndex = 0;
    for (var i = 1; i < last24.length; i++) {
      if (last24[i] >= last24[peakIndex]) peakIndex = i;
    }

    return _SparklineStats(
      dailyVolatility: hourlyVolatility * sqrt(24) * 100,
      average: prices.reduce((a, b) => a + b) / prices.length,
      rsi: rsi.values.last,
      rsiPeak24h: rsi.values.skip(max(0, rsi.values.length - 24)).reduce(max),
      hoursSincePeak: last24.length - 1 - peakIndex,
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
  final int hoursSincePeak; // сколько часов назад был пик цены (0 — последняя точка)
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
// и сработали минимум 3 из 4 сигналов затухания импульса.
class OverheatedFadingFilter implements CoinFilter {
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

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins.where(_isOverheatedAndFading).toList();
  }

  bool _isOverheatedAndFading(CoinModel coin) {
    final prices = coin.sparkline7d;
    final high = coin.high24h;
    final low = coin.low24h;
    if (prices.length < 48 || high == null || low == null || high <= low) {
      return false;
    }
    if (coin.currentPrice == 0) return false;

    final change24h = coin.priceChangePercentage24h ?? 0;
    final change7d = coin.priceChangePercentage7d ?? 0;
    if (max(change24h, change7d) < _minRisePercent) return false;

    final stats = _statsCache[prices] ??= _SparklineStats.from(prices);
    final volatility = stats.dailyVolatility;
    if (volatility < _minDailyVolatility) return false;
    // Уже упала сильнее обычного дневного хода — откат состоялся, поздно.
    if (change24h < -volatility) return false;

    // 1. Перегрев: рост в типичных дневных ходах (за 7д ход растёт как √7).
    final heat = max(
      change24h / volatility,
      change7d / (volatility * sqrt(7)),
    );
    if (heat < _minHeat) return false;

    // 2. Затухание: считаем сработавшие сигналы.
    var signals = 0;

    // RSI был в перекупленности и разворачивается вниз.
    if (stats.rsiPeak24h >= _rsiOverbought &&
        stats.rsi <= stats.rsiPeak24h - _rsiDrop) {
      signals++;
    }

    // Цена отошла от дневного максимума (в % от диапазона high-low).
    final pullback = (high - coin.currentPrice) / (high - low) * 100;
    if (pullback >= _minPullbackPercent && pullback <= _maxPullbackPercent) {
      signals++;
    }

    // Импульс погас: последний час и последние 6 часов в минусе.
    final change6h = (coin.currentPrice / stats.price6hAgo - 1) * 100;
    if ((coin.priceChangePercentage1h ?? 0) < 0 && change6h < 0) signals++;

    // Цена оторвалась от средней за 7 дней (в типичных дневных ходах).
    final stretch = (coin.currentPrice / stats.average - 1) * 100 / volatility;
    if (stretch > _minStretch) signals++;

    return signals >= _minSignals;
  }
}

// Приток капитала: рост/отток капитализации выше 5% за 24 часа.
class CapitalInflowFilter implements CoinFilter {
  static const double _thresholdPercent = 5;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins
        .where((coin) => (coin.marketCapChangePercentage24h ?? 0).abs() > _thresholdPercent)
        .toList();
  }
}

// У дневного пика/дна: текущая цена у верхней или нижней границы диапазона high24h/low24h.
class DailyExtremumFilter implements CoinFilter {
  static const double _thresholdPercent = 5;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins.where((coin) {
      final high = coin.high24h;
      final low = coin.low24h;
      if (high == null || low == null || high == low) return false;
      final position = (coin.currentPrice - low) / (high - low) * 100;
      return position <= _thresholdPercent || position >= 100 - _thresholdPercent;
    }).toList();
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
