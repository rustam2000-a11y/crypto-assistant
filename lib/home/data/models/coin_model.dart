import 'package:equatable/equatable.dart';

class CoinModel extends Equatable {
  const CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.totalVolume, //Объём торгов за 24 часа
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h, //Рост/падение в %
    required this.priceChangePercentage1h,
    required this.priceChangePercentage7d,
    required this.sparkline7d, //Почасовые цены за 7 дней
    required this.marketCapChangePercentage24h,
    required this.ath, //самая высокая цена за всю историю монеты
    required this.athChangePercentage,
    required this.athDate,
    required this.atl, //на сколько сейчас цена ниже ATH
    required this.atlChangePercentage,
    required this.atlDate,
    required this.lastUpdated,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      image: json['image'] as String? ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
      totalVolume: (json['total_volume'] as num?)?.toInt() ?? 0,
      high24h: (json['high_24h'] as num?)?.toDouble(),
      low24h: (json['low_24h'] as num?)?.toDouble(),
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)
          ?.toDouble(),
      priceChangePercentage1h:
          (json['price_change_percentage_1h_in_currency'] as num?)?.toDouble(),
      priceChangePercentage7d:
          (json['price_change_percentage_7d_in_currency'] as num?)?.toDouble(),
      sparkline7d:
          ((json['sparkline_in_7d'] as Map<String, dynamic>?)?['price']
                  as List<dynamic>?)
              ?.whereType<num>()
              .map((p) => p.toDouble())
              .toList() ??
          const [],
      marketCapChangePercentage24h:
          (json['market_cap_change_percentage_24h'] as num?)?.toDouble(),
      ath: (json['ath'] as num?)?.toDouble(),
      athChangePercentage: (json['ath_change_percentage'] as num?)?.toDouble(),
      athDate: DateTime.tryParse(json['ath_date'] as String? ?? ''),
      atl: (json['atl'] as num?)?.toDouble(),
      atlChangePercentage: (json['atl_change_percentage'] as num?)?.toDouble(),
      atlDate: DateTime.tryParse(json['atl_date'] as String? ?? ''),
      lastUpdated: DateTime.tryParse(json['last_updated'] as String? ?? ''),
    );
  }

  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final int totalVolume;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double? priceChangePercentage24h;
  final double? priceChangePercentage1h;
  final double? priceChangePercentage7d;
  final List<double> sparkline7d;
  final double? marketCapChangePercentage24h;
  final double? ath;
  final double? athChangePercentage;
  final DateTime? athDate;
  final double? atl;
  final double? atlChangePercentage;
  final DateTime? atlDate;
  final DateTime? lastUpdated;

  CoinModel copyWith({
    String? id,
    String? name,
    String? symbol,
    String? image,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    int? totalVolume,
    double? high24h,
    double? low24h,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? priceChangePercentage1h,
    double? priceChangePercentage7d,
    List<double>? sparkline7d,
    double? marketCapChangePercentage24h,
    double? ath,
    double? athChangePercentage,
    DateTime? athDate,
    double? atl,
    double? atlChangePercentage,
    DateTime? atlDate,
    DateTime? lastUpdated,
  }) {
    return CoinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      totalVolume: totalVolume ?? this.totalVolume,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h:
          priceChangePercentage24h ?? this.priceChangePercentage24h,
      priceChangePercentage1h:
          priceChangePercentage1h ?? this.priceChangePercentage1h,
      priceChangePercentage7d:
          priceChangePercentage7d ?? this.priceChangePercentage7d,
      sparkline7d: sparkline7d ?? this.sparkline7d,
      marketCapChangePercentage24h:
          marketCapChangePercentage24h ?? this.marketCapChangePercentage24h,
      ath: ath ?? this.ath,
      athChangePercentage: athChangePercentage ?? this.athChangePercentage,
      athDate: athDate ?? this.athDate,
      atl: atl ?? this.atl,
      atlChangePercentage: atlChangePercentage ?? this.atlChangePercentage,
      atlDate: atlDate ?? this.atlDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    symbol,
    image,
    currentPrice,
    marketCap,
    marketCapRank,
    totalVolume,
    high24h,
    low24h,
    priceChange24h,
    priceChangePercentage24h,
    priceChangePercentage1h,
    priceChangePercentage7d,
    sparkline7d,
    marketCapChangePercentage24h,
    ath,
    athChangePercentage,
    athDate,
    atl,
    atlChangePercentage,
    atlDate,
    lastUpdated,
  ];
}
