import 'package:crypto_assistant/presentation/app_colors.dart';
import 'package:crypto_assistant/widget/coin_avatar.dart';
import 'package:crypto_assistant/widget/coin_price_change.dart';
import 'package:crypto_assistant/widget/coin_stat_column.dart';
import 'package:crypto_assistant/widget/format_utils.dart';
import 'package:crypto_assistant/widget/title_text_column.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class CoinCard extends StatelessWidget {
  const CoinCard({
    super.key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    required this.high24h,
    required this.marketCapRank,
    this.onTap,
    this.onLongPress,
  });

  final String name;
  final String symbol;
  final String imageUrl;
  final double currentPrice;
  final double? priceChangePercentage24h;
  final int totalVolume;
  final double? high24h;
  final int marketCapRank;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.containerColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.jacarta),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CoinAvatar(imageUrl: imageUrl),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TitleTextColumn(
                              title: name,
                              text: '${symbol.toUpperCase()} - #$marketCapRank',
                            ),
                          ),
                        ],
                      ),
                    ),
                    CoinPriceChange(
                      currentPrice: currentPrice,
                      priceChangePercentage24h: priceChangePercentage24h,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  spacing: 20,
                  children: [
                    CoinStatColumn(
                      title: S.of(context).volume24Hours,
                      text: formatVolume(totalVolume),
                    ),
                    CoinStatColumn(
                      title: S.of(context).max24Hours,
                      text: high24h != null
                          ? '\$${high24h!.toStringAsFixed(2)}'
                          : '—',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
