import 'package:equatable/equatable.dart';

import 'pump_reversal_detector.dart';

/// Сигнал разворота в журнале и его результат через 1–4 часа.
class SignalRecord extends Equatable {
  const SignalRecord({
    required this.coinId,
    required this.name,
    required this.symbol,
    required this.setup,
    required this.entryTime,
    required this.signalPrice,
    required this.high24h,
    required this.passedFilters,
    this.results = const {},
  });

  factory SignalRecord.fromJson(Map<String, dynamic> json) {
    return SignalRecord(
      coinId: json['coinId'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      setup: ReversalSetup.values.byName(json['setup'] as String),
      entryTime: json['entryTime'] as int,
      signalPrice: (json['signalPrice'] as num).toDouble(),
      high24h: (json['high24h'] as num).toDouble(),
      passedFilters: json['passedFilters'] as bool,
      results: (json['results'] as Map<String, dynamic>? ?? const {}).map(
        (hours, value) => MapEntry(int.parse(hours), (value as num).toDouble()),
      ),
    );
  }

  final String coinId;
  final String name;
  final String symbol; // контракт Binance, например 1000PEPEUSDT
  final ReversalSetup setup;

  /// Открытие свечи после сигнальной — момент входа, мс UTC.
  final int entryTime;
  final double signalPrice;
  final double high24h;

  /// Сработали ли фильтры режима BTC и рынка. Записываются и сигналы без
  /// них — чтобы на новых данных видеть, помогают ли фильтры.
  final bool passedFilters;

  /// Результат шорта за N часов, % после издержек.
  final Map<int, double> results;

  bool get isResolved => results.isNotEmpty;

  SignalRecord copyWith({Map<int, double>? results}) {
    return SignalRecord(
      coinId: coinId,
      name: name,
      symbol: symbol,
      setup: setup,
      entryTime: entryTime,
      signalPrice: signalPrice,
      high24h: high24h,
      passedFilters: passedFilters,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toJson() => {
    'coinId': coinId,
    'name': name,
    'symbol': symbol,
    'setup': setup.name,
    'entryTime': entryTime,
    'signalPrice': signalPrice,
    'high24h': high24h,
    'passedFilters': passedFilters,
    'results': results.map((hours, value) => MapEntry('$hours', value)),
  };

  @override
  List<Object?> get props => [symbol, entryTime, setup, passedFilters, results];
}
