import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../models/candle.dart';

/// Публичный REST Binance USDT-M Futures: ключ не нужен.
@singleton
class BinanceFuturesClient {
  static const _baseUrl = 'https://fapi.binance.com';
  static const _symbolsTtl = Duration(hours: 6);

  Set<String>? _symbols;
  DateTime? _symbolsLoadedAt;

  /// Торгуемые бессрочные контракты к USDT, например {'BTCUSDT', '1000PEPEUSDT'}.
  Future<Set<String>> perpetualSymbols() async {
    final loadedAt = _symbolsLoadedAt;
    if (_symbols != null &&
        loadedAt != null &&
        DateTime.now().difference(loadedAt) < _symbolsTtl) {
      return _symbols!;
    }
    final data = await _get('/fapi/v1/exchangeInfo') as Map<String, dynamic>;
    _symbols = (data['symbols'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .where(
          (s) =>
              s['contractType'] == 'PERPETUAL' &&
              s['quoteAsset'] == 'USDT' &&
              s['status'] == 'TRADING',
        )
        .map((s) => s['symbol'] as String)
        .toSet();
    _symbolsLoadedAt = DateTime.now();
    return _symbols!;
  }

  /// Контракт для монеты с тикером [coinSymbol]. Мелкие монеты торгуются
  /// пачками (PEPE -> 1000PEPEUSDT): [scale] — во сколько раз цена контракта
  /// больше цены монеты.
  static ({String symbol, double scale})? contractFor(
    String coinSymbol,
    Set<String> symbols,
  ) {
    final base = coinSymbol.toUpperCase();
    for (final (prefix, scale) in const [
      ('', 1.0),
      ('1000', 1e3),
      ('1000000', 1e6),
    ]) {
      final symbol = '$prefix${base}USDT';
      if (symbols.contains(symbol)) return (symbol: symbol, scale: scale);
    }
    return null;
  }

  /// Текущие цены всех контрактов одним запросом.
  Future<Map<String, double>> lastPrices() async {
    final data = await _get('/fapi/v1/ticker/price') as List<dynamic>;
    return {
      for (final item in data.cast<Map<String, dynamic>>())
        item['symbol'] as String: double.parse(item['price'] as String),
    };
  }

  /// Текущая ставка фандинга всех контрактов (за 8 часов, в долях).
  Future<Map<String, double>> fundingRates() async {
    final data = await _get('/fapi/v1/premiumIndex') as List<dynamic>;
    return {
      for (final item in data.cast<Map<String, dynamic>>())
        if (double.tryParse(item['lastFundingRate'] as String? ?? '')
            case final rate?)
          item['symbol'] as String: rate,
    };
  }

  /// Изменение открытого интереса (в USDT) за последние [hours] часов, в долях.
  Future<double?> openInterestChange(
    String symbol, {
    required int hours,
  }) async {
    final data =
        await _get('/futures/data/openInterestHist', {
              'symbol': symbol,
              'period': '1h',
              'limit': '${hours + 1}',
            })
            as List<dynamic>;
    if (data.length < hours + 1) return null;
    double value(Object? item) => double.parse(
      (item! as Map<String, dynamic>)['sumOpenInterestValue'] as String,
    );
    final before = value(data.first);
    return before > 0 ? value(data.last) / before - 1 : null;
  }

  /// Соотношение лонг/шорт по позициям топ-трейдеров за последний час.
  Future<double?> topTraderPositionRatio(String symbol) async {
    final data =
        await _get('/futures/data/topLongShortPositionRatio', {
              'symbol': symbol,
              'period': '1h',
              'limit': '1',
            })
            as List<dynamic>;
    if (data.isEmpty) return null;
    return double.tryParse(
      (data.last as Map<String, dynamic>)['longShortRatio'] as String,
    );
  }

  /// Последние свечи вместе с ещё не закрытой, от старых к новым.
  Future<List<Candle>> recentKlines(
    String symbol, {
    required String interval,
    required int limit,
  }) async {
    final data =
        await _get('/fapi/v1/klines', {
              'symbol': symbol,
              'interval': interval,
              'limit': '$limit',
            })
            as List<dynamic>;
    return data.map((k) => Candle.fromJson(k as List<dynamic>)).toList();
  }

  /// Только закрытые свечи, от старых к новым.
  Future<List<Candle>> closedKlines(
    String symbol, {
    required String interval,
    required int limit,
    int? startTime,
  }) async {
    final data =
        await _get('/fapi/v1/klines', {
              'symbol': symbol,
              'interval': interval,
              'limit': '$limit',
              if (startTime != null) 'startTime': '$startTime',
            })
            as List<dynamic>;
    final now = DateTime.now().millisecondsSinceEpoch;
    return data
        .map((k) => Candle.fromJson(k as List<dynamic>))
        .where((c) => c.closeTime < now)
        .toList();
  }

  Future<dynamic> _get(String path, [Map<String, String>? query]) async {
    final url = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Binance ${response.statusCode}: ${response.body}',
        url,
      );
    }
    return jsonDecode(response.body);
  }
}
