import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:crypto_assistant/core/ui/device_layout.dart';
import 'package:crypto_assistant/home/bloc/home_bloc.dart';
import 'package:crypto_assistant/home/bloc/home_effect.dart';
import 'package:crypto_assistant/home/bloc/home_event.dart';
import 'package:crypto_assistant/home/bloc/home_state.dart';
import 'package:crypto_assistant/presentation/app_colors.dart';
import 'package:crypto_assistant/presentation/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../coin_card/coin_screen.dart';
import '../core/ui/ui_provider.dart';
import '../generated/l10n.dart';
import '../injection.dart';
import '../widget/coin_card.dart';
import 'home_widget/coin_search_field.dart';
import 'home_widget/custom_app_bar.dart';
import 'language/language_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<HomeBloc>();
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
    return BlocEffectBuilder<HomeBloc, HomeState, HomeEffect>(
      bloc: _bloc,
      effectListener: (context, effect) {
        switch (effect) {
          case HomeShowError(:final message):
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.haiti,
          appBar: CustomAppBar(
            text: "Crypto Assistant",
            leadingIcon: false,
            action: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return LanguageBottomSheet();
                    },
                  );
                },
                child: Image.asset(
                  AppImages.languages,
                  width: isTablet ? 27 : 24,
                  height: isTablet ? 27 : 24,
                  color: AppColors.whiteColor,
                ),
              ),
              if (state.isLoggedIn)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _bloc.add(LogOutEvent()),
                  child: Image.asset(
                    AppImages.exit,
                    width: 19,
                    height: 19,
                    color: AppColors.whiteColor,
                  ),
                ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.items.isEmpty) {
                return Center(child: Text(S.of(context).noData));
              }
              return Column(
                children: [
                  CoinSearchField(
                    onChanged: (value) {
                      _bloc.add(SearchQueryChangedEvent(query: value));
                    },
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final coin = state.filteredItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CoinScreen(coinId: coin.id),
                              ),
                            );
                          },
                          child: CoinCard(
                            name: coin.name,
                            symbol: coin.symbol,
                            imageUrl: coin.image,
                            currentPrice: coin.currentPrice,
                            priceChangePercentage24h:
                                coin.priceChangePercentage24h,
                            totalVolume: coin.totalVolume,
                            high24h: coin.high24h,
                            marketCapRank: coin.marketCapRank,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
