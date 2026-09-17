import 'package:crypto_assistant/core/ui/device_layout.dart';
import 'package:crypto_assistant/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../coin_card/coin_screen.dart';
import '../core/ui/ui_provider.dart';
import '../generated/l10n.dart';
import '../home/home_widget/custom_app_bar.dart';
import '../injection.dart';
import '../presentation/app_colors.dart';
import '../widget/coin_card.dart';
import 'bloc/filter_detailing_bloc.dart';
import 'bloc/filter_detailing_event.dart';
import 'bloc/filter_detailing_state.dart';
import 'domain/filter_type.dart';

class FilterDetailingScreen extends StatefulWidget {
  const FilterDetailingScreen({
    super.key,
    required this.type,
    required this.description,
  });

  final FilterType type;
  final String description;

  @override
  State<FilterDetailingScreen> createState() => _FilterDetailingScreenState();
}

class _FilterDetailingScreenState extends State<FilterDetailingScreen> {
  late final FilterDetailingBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<FilterDetailingBloc>()..add(LoadFilteredCoinsEvent(widget.type));
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
    return Scaffold(
      backgroundColor: AppColors.haiti,
      appBar: CustomAppBar(text: S.of(context).detailing),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.blueBell),

                ),
                child: CustomNewText(text: widget.description,fontSize: isTablet?20:14,)),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<FilterDetailingBloc, FilterDetailingState>(
                bloc: _bloc,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.coins.isEmpty) {
                    return  Center(child: Text(S.of(context).noData));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.coins.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final coin = state.coins[index];
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
