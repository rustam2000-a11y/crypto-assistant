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
import '../widget/format_utils.dart';
import 'bloc/filter_detailing_bloc.dart';
import 'bloc/filter_detailing_event.dart';
import 'bloc/filter_detailing_state.dart';
import 'domain/filter_type.dart';
import 'domain/key_levels/key_level.dart';
import 'domain/level_radar/level_approach.dart';
import 'domain/overbought/overbought_signal.dart';
import 'domain/overload/overload_signal.dart';
import 'domain/pump_reversal/pump_reversal_status.dart';
import 'signal_journal_screen.dart';

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
      appBar: CustomAppBar(
        text: S.of(context).detailing,
        action: [
          if (widget.type == FilterType.priceMovement)
            IconButton(
              tooltip: S.of(context).signalJournal,
              icon: const Icon(Icons.history, color: AppColors.whiteColor),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignalJournalScreen()),
              ),
            ),
        ],
      ),
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
                  final status = state.reversalStatus;
                  if (state.coins.isEmpty) {
                    return Column(
                      children: [
                        if (status != null) _ReversalStatusBar(status: status),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: CustomNewText(
                                text: _emptyText(context, status),
                                fontSize: isTablet ? 18 : 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.coins.length + (status != null ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (status != null && index == 0) {
                        return _ReversalStatusBar(status: status);
                      }
                      final coin =
                          state.coins[index - (status != null ? 1 : 0)];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoinScreen(coinId: coin.id),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CoinCard(
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
                            switch (state.details[coin.id]) {
                              final KeyLevel level => _KeyLevelLine(level: level),
                              final OverboughtSignal signal => _OverboughtLine(
                                signal: signal,
                              ),
                              final LevelApproach approach => _LevelApproachLine(
                                approach: approach,
                              ),
                              final OverloadSignal signal => _OverloadLine(
                                signal: signal,
                              ),
                              _ => const SizedBox.shrink(),
                            },
                          ],
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

  String _emptyText(BuildContext context, PumpReversalStatus? status) {
    if (status == null || status.isActive) return S.of(context).noData;
    return status.isBearRegime
        ? S.of(context).pausedMarketRising
        : S.of(context).pausedBullRegime;
  }
}

class _ReversalStatusBar extends StatelessWidget {
  const _ReversalStatusBar({required this.status});

  final PumpReversalStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.isActive ? AppColors.positive : AppColors.amber;
    String percent(double value) =>
        '${value > 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: CustomNewText(
        text:
            '${status.isActive ? S.of(context).signalsActive : S.of(context).signalsPaused}  ·  '
            '${S.of(context).btcTrend30d} ${percent(status.btcChange30d)}  ·  '
            '${S.of(context).market1h} ${percent(status.marketChange1h)}',
        fontSize: 13,
        color: color,
      ),
    );
  }
}

class _KeyLevelLine extends StatelessWidget {
  const _KeyLevelLine({required this.level});

  final KeyLevel level;

  @override
  Widget build(BuildContext context) {
    final corridor = level.corridor;
    final kind = corridor != null
        ? (level.isResistance
              ? S.of(context).corridorUpperBound
              : S.of(context).corridorLowerBound)
        : (level.isResistance
              ? S.of(context).resistance
              : S.of(context).support);
    final range = corridor == null
        ? ''
        : '  ·  ${formatPrice(corridor.low)}–${formatPrice(corridor.high)}';
    final state = level.isAtLevel
        ? S.of(context).atLevel
        : S.of(context).approachingLevel;
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
      child: CustomNewText(
        text:
            '$kind ${formatPrice(level.price)}$range  ·  $state  ·  '
            '${S.of(context).strongBounces(level.touches, level.avgBouncePercent.toStringAsFixed(0))}  ·  '
            '${S.of(context).distanceToLevel(level.distancePercent.toStringAsFixed(2))}',
        fontSize: 13,
        color: level.isResistance ? AppColors.borderRed : AppColors.positive,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _OverboughtLine extends StatelessWidget {
  const _OverboughtLine({required this.signal});

  final OverboughtSignal signal;

  @override
  Widget build(BuildContext context) {
    String fixed(double value) => value.toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
      child: CustomNewText(
        text:
            'RSI ${fixed(signal.rsi)}  ·  '
            '${S.of(context).rise24h(fixed(signal.rise24hPercent), signal.heat.toStringAsFixed(1))}  ·  '
            '${S.of(context).volumeChange(fixed(signal.volumeChangePercent))}  ·  '
            '${S.of(context).buyersShare(fixed(signal.buyersSharePercent), fixed(signal.previousBuyersSharePercent))}',
        fontSize: 13,
        color: AppColors.amber,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _LevelApproachLine extends StatelessWidget {
  const _LevelApproachLine({required this.approach});

  final LevelApproach approach;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final kind = approach.isResistance ? s.resistance : s.support;
    final state = approach.isAtLevel
        ? s.atLevel
        : s.radarApproaching(approach.distancePercent.toStringAsFixed(2));
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
      child: CustomNewText(
        text:
            '$kind ${formatPrice(approach.levelPrice)}  ·  $state  ·  '
            '${s.volumeAtLevel(approach.volumeMultiple.toStringAsFixed(1))}  ·  '
            '${s.strongBounces(approach.touches, approach.avgBouncePercent.toStringAsFixed(0))}',
        fontSize: 13,
        color: approach.isResistance ? AppColors.borderRed : AppColors.positive,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class _OverloadLine extends StatelessWidget {
  const _OverloadLine({required this.signal});

  final OverloadSignal signal;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    String percent(double share, {int digits = 0}) =>
        '${share >= 0 ? '+' : ''}${(share * 100).toStringAsFixed(digits)}';
    final items = [
      for (final sign in OverloadSign.values)
        if (signal.points.contains(sign))
          switch (sign) {
            OverloadSign.extension => s.overloadExtension(
              signal.extension.toStringAsFixed(1),
            ),
            OverloadSign.rsi1h => s.overloadRsi1h(
              signal.rsi1h.toStringAsFixed(0),
            ),
            OverloadSign.rsi4h => s.overloadRsi4h(
              signal.rsi4h.toStringAsFixed(0),
            ),
            OverloadSign.openInterest => s.overloadOpenInterest(
              percent(signal.openInterestChange ?? 0),
            ),
            OverloadSign.funding => s.overloadFunding(
              (signal.fundingRate! * 100).toStringAsFixed(3),
            ),
            OverloadSign.topTraders => s.overloadTopTraders(
              signal.topTraderRatio!.toStringAsFixed(1),
            ),
            OverloadSign.volumeSpike => s.overloadVolume(
              signal.volumeSpike.toStringAsFixed(1),
            ),
          },
    ];
    final squeeze = signal.squeezeRisk
        ? '\n${s.overloadSqueeze(percent(signal.openInterestChange!))}'
        : '';
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
      child: CustomNewText(
        text:
            '${s.overloadPoints(signal.points.length)}: ${items.join(' · ')}'
            '$squeeze',
        fontSize: 13,
        color: AppColors.amber,
        textAlign: TextAlign.start,
      ),
    );
  }
}
