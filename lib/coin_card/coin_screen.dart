import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:crypto_assistant/core/ui/device_layout.dart';
import 'package:crypto_assistant/home/home_widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/ui/ui_provider.dart';
import '../generated/l10n.dart';
import '../injection.dart';
import '../auth/login/login_screen.dart';
import '../presentation/app_colors.dart';
import '../widget/coin_avatar.dart';
import '../widget/coin_price_change.dart';
import '../widget/coin_price_chart.dart';
import '../widget/coin_stat_card.dart';
import '../widget/custom_button.dart';

import '../widget/format_utils.dart';
import '../widget/title_text_column.dart';
import 'bloc/coin_bloc.dart';
import 'bloc/coin_effect.dart';
import 'bloc/coin_event.dart';
import 'bloc/coin_state.dart';

class CoinScreen extends StatefulWidget {
  const CoinScreen({super.key, required this.coinId});

  final String coinId;

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  late final CoinBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<CoinBloc>()..add(LoadCoinDetailsEvent(widget.coinId));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return BlocEffectBuilder<CoinBloc, CoinState, CoinEffect>(
      bloc: _bloc,
      effectListener: (context, effect) {
        switch (effect) {
          case CoinShowError(:final message):
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          case CoinNavigateToLogin():
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
        }
      },
      builder: (context, state) {
        final coin = state.coin;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            text: coin?.name ?? '',
            colors: AppColors.background,
          ),
          body: coin == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CoinAvatar(imageUrl: coin.image),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TitleTextColumn(//
                                          title: coin.name,
                                          text:
                                              '${coin.symbol.toUpperCase()} - #${coin.marketCapRank}',
                                          fonSizeFirst: isTablet?22:18,
                                          fonSizeLast: isTablet?22:14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  CoinPriceChange(
                                    currentPrice: coin.currentPrice,
                                    priceChangePercentage24h:
                                        coin.priceChangePercentage24h,
                                  ),
                                ],
                              ),
                            ),

                            CoinPriceChart(
                              points: state.chartPoints,
                              isLoading: state.isChartLoading,
                              selectedPeriod: state.chartPeriod,
                              onPeriodChanged: (period) => _bloc.add(
                                ChangeChartPeriodEvent(period),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CoinStatCard(
                                title: S
                                    .of(context)
                                    .currentPricePositionInDailyRange0100,
                                value: formatPriceRangePosition(
                                  coin.currentPrice,
                                  coin.low24h,
                                  coin.high24h,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: CoinStatCard(
                                title: S.of(context).volume24Hours,
                                value: formatVolume(coin.totalVolume),
                              ),
                            ),
                            Expanded(
                              child: CoinStatCard(
                                title: S.of(context).capitalization,
                                value:
                                    '\$${formatVolume(coin.marketCap.toInt())}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: CoinStatCard(
                                title: S.of(context).max24Hours,
                                value: coin.high24h != null
                                    ? '\$${coin.high24h!.toStringAsFixed(2)}'
                                    : '—',
                              ),
                            ),
                            Expanded(
                              child: CoinStatCard(
                                title: 'Min 24 hours',
                                value: coin.low24h != null
                                    ? '\$${coin.low24h!.toStringAsFixed(2)}'
                                    : '—',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: CoinStatCard(
                                title: S.of(context).historicalMaximum,
                                value: coin.ath != null
                                    ? '\$${coin.ath!.toStringAsFixed(2)}'
                                    : '—',
                              ),
                            ),
                            Expanded(
                              child: CoinStatCard(
                                title: S.of(context).historicalMinimum,
                                value: coin.atl != null
                                    ? '\$${coin.atl!.toStringAsFixed(2)}'
                                    : '—',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        const SizedBox(height: 20),
                        SafeArea(
                          top: false,
                          child: CustomButton(
                            name: state.isFavorite
                                ? S.of(context).removeFromFavorites
                                : S.of(context).addToFavorites,
                            onTap: () =>
                                _bloc.add(const ToggleBriefcaseEvent()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
