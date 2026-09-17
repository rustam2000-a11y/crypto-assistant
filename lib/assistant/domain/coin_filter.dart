import '../../home/data/models/coin_model.dart';
import 'filter_type.dart';

abstract class CoinFilter {
  List<CoinModel> filter(List<CoinModel> coins);

  factory CoinFilter.forType(FilterType type) {
    switch (type) {
      case FilterType.abnormalMovement:
        return AbnormalMovementFilter();
      case FilterType.priceMovement:
        return PriceMovementFilter();
      case FilterType.highVolatility:
        return HighVolatilityFilter();
      case FilterType.historicalExtremum:
        return HistoricalExtremumFilter();
      case FilterType.turnover:
        return TurnoverFilter();
      case FilterType.capitalInflow:
        return CapitalInflowFilter();
      case FilterType.dailyExtremum:
        return DailyExtremumFilter();
      case FilterType.confirmedAnomaly:
        return ConfirmedAnomalyFilter();
    }
  }
}

// Аномальное движение цены за последние 24 часа: рост/падение выше чем на 10%.
class AbnormalMovementFilter implements CoinFilter {
  static const double _thresholdPercent = 10;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins
        .where((coin) => (coin.priceChangePercentage24h ?? 0).abs() > _thresholdPercent)
        .toList();
  }
}

// Движение цены за последние 24 часа: рост/падение выше чем на 5%.
class PriceMovementFilter implements CoinFilter {
  static const double _thresholdPercent = 5;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins
        .where((coin) => (coin.priceChangePercentage24h ?? 0).abs() > _thresholdPercent)
        .toList();
  }
}

// Большая волатильность: размах между high24h и low24h относительно текущей цены.
class HighVolatilityFilter implements CoinFilter {
  static const double _thresholdPercent = 10;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins.where((coin) {
      final high = coin.high24h;
      final low = coin.low24h;
      if (high == null || low == null || coin.currentPrice == 0) return false;
      final rangePercent = (high - low) / coin.currentPrice * 100;
      return rangePercent > _thresholdPercent;
    }).toList();
  }
}

// Исторический максимум/минимум: цена приблизилась к ATH или ATL.
class HistoricalExtremumFilter implements CoinFilter {
  static const double _thresholdPercent = 5;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins.where((coin) {
      final athChange = coin.athChangePercentage;
      final atlChange = coin.atlChangePercentage;
      final nearAth = athChange != null && athChange.abs() <= _thresholdPercent;
      final nearAtl = atlChange != null && atlChange.abs() <= _thresholdPercent;
      return nearAth || nearAtl;
    }).toList();
  }
}

// Оборачиваемость: аномально высокий объём торгов относительно капитализации.
class TurnoverFilter implements CoinFilter {
  static const double _thresholdRatio = 0.5;

  @override
  List<CoinModel> filter(List<CoinModel> coins) {
    return coins.where((coin) {
      if (coin.marketCap == 0) return false;
      final turnoverRatio = coin.totalVolume / coin.marketCap;
      return turnoverRatio > _thresholdRatio;
    }).toList();
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
  static const double _priceThresholdPercent = 10;
  static const double _turnoverThresholdRatio = 0.5;

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
