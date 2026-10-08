import 'package:equatable/equatable.dart';

/// Свеча Binance (kline). Время — в миллисекундах UTC.
class Candle extends Equatable {
  const Candle({
    required this.openTime,
    required this.closeTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.quoteVolume,
    required this.takerBuyQuoteVolume,
  });

  /// Формат Binance: [openTime, open, high, low, close, volume, closeTime,
  /// quoteVolume, trades, takerBuyVolume, takerBuyQuoteVolume, ...],
  /// числа приходят строками.
  factory Candle.fromJson(List<dynamic> json) {
    return Candle(
      openTime: json[0] as int,
      open: double.parse(json[1] as String),
      high: double.parse(json[2] as String),
      low: double.parse(json[3] as String),
      close: double.parse(json[4] as String),
      closeTime: json[6] as int,
      quoteVolume: double.parse(json[7] as String),
      takerBuyQuoteVolume: double.parse(json[10] as String),
    );
  }

  final int openTime;
  final int closeTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double quoteVolume; // оборот свечи в USDT
  // Оборот агрессивных покупок (рыночные ордера на покупку), USDT.
  final double takerBuyQuoteVolume;

  @override
  List<Object?> get props => [
    openTime,
    open,
    high,
    low,
    close,
    quoteVolume,
    takerBuyQuoteVolume,
  ];
}
