import 'package:injectable/injectable.dart';

import '../client/binance_futures_client.dart';
import '../models/candle.dart';

/// Часовые свечи Binance Futures с кэшем до закрытия следующей свечи:
/// общие для фильтров уровней и перегрева, чтобы не качать их дважды.
@LazySingleton(as: HourlyCandlesRepositoryI)
class HourlyCandlesRepository extends HourlyCandlesRepositoryI {
  HourlyCandlesRepository(this._binance);

  final BinanceFuturesClient _binance;

  // 22.5 дня: уровням нужно 20 дней + 2 суток на ATR, перегреву — неделя
  // и разгон RSI.
  static const int _limit = 540;
  static const int _parallelRequests = 10;
  // Binance публикует закрытую свечу с небольшой задержкой.
  static const Duration _publishDelay = Duration(seconds: 5);

  final _cache = <String, ({List<Candle> candles, DateTime validUntil})>{};

  @override
  Future<Map<String, List<Candle>>> closedCandles(
    Iterable<String> symbols,
  ) async {
    final unique = symbols.toSet().toList();
    final now = DateTime.now();
    final stale = unique
        .where((s) => !(_cache[s]?.validUntil.isAfter(now) ?? false))
        .toList();
    for (var i = 0; i < stale.length; i += _parallelRequests) {
      await Future.wait(stale.skip(i).take(_parallelRequests).map(_load));
    }
    return {
      for (final symbol in unique)
        if (_cache[symbol] case final cached?) symbol: cached.candles,
    };
  }

  Future<void> _load(String symbol) async {
    final candles = await _binance.closedKlines(
      symbol,
      interval: '1h',
      limit: _limit,
    );
    if (candles.isEmpty) return;
    _cache[symbol] = (
      candles: candles,
      validUntil: DateTime.fromMillisecondsSinceEpoch(
        candles.last.closeTime + 1,
      ).add(const Duration(hours: 1) + _publishDelay),
    );
  }
}

abstract class HourlyCandlesRepositoryI {
  /// Закрытые часовые свечи по контрактам; без данных — контракта нет в ответе.
  Future<Map<String, List<Candle>>> closedCandles(Iterable<String> symbols);
}
