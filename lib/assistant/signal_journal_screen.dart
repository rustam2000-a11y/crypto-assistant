import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:crypto_assistant/core/ui/device_layout.dart';
import 'package:crypto_assistant/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../core/ui/ui_provider.dart';
import '../generated/l10n.dart';
import '../home/home_widget/custom_app_bar.dart';
import '../injection.dart';
import '../presentation/app_colors.dart';
import 'bloc/signal_journal_bloc.dart';
import 'bloc/signal_journal_effect.dart';
import 'bloc/signal_journal_event.dart';
import 'bloc/signal_journal_state.dart';
import 'domain/pump_reversal/journal_stats.dart';
import 'domain/pump_reversal/pump_reversal_detector.dart';
import 'domain/pump_reversal/signal_record.dart';

class SignalJournalScreen extends StatefulWidget {
  const SignalJournalScreen({super.key});

  @override
  State<SignalJournalScreen> createState() => _SignalJournalScreenState();
}

class _SignalJournalScreenState extends State<SignalJournalScreen> {
  late final SignalJournalBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<SignalJournalBloc>()..add(const LoadSignalJournalEvent());
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
    return BlocEffectBuilder<
      SignalJournalBloc,
      SignalJournalState,
      SignalJournalEffect
    >(
      bloc: _bloc,
      effectListener: (context, effect) {
        switch (effect) {
          case SignalJournalShowError(:final message):
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.haiti,
          appBar: CustomAppBar(text: S.of(context).signalJournal),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              CustomNewText(
                text: S.of(context).journalNote,
                fontSize: isTablet ? 16 : 13,
                color: AppColors.textSecondary,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 12),
              if (state.isLoading) const LinearProgressIndicator(),
              _StatsCard(
                title: S.of(context).formulaWithFilters,
                stats: state.formula,
                borderColor: AppColors.borderOrange,
              ),
              const SizedBox(height: 8),
              _StatsCard(
                title: S.of(context).patternOnly,
                stats: state.patternOnly,
                borderColor: AppColors.jacarta,
              ),
              const SizedBox(height: 12),
              if (state.records.isEmpty && !state.isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: CustomNewText(text: S.of(context).journalEmpty),
                ),
              for (final record in state.records) _RecordTile(record: record),
            ],
          ),
        );
      },
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.title,
    required this.stats,
    required this.borderColor,
  });

  final String title;
  final JournalStats stats;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.portGore,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          CustomNewText(
            text: '$title · ${S.of(context).tradesCount(stats.trades)}',
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          for (final MapEntry(key: hours, value: horizon)
              in stats.byHours.entries)
            CustomNewText(
              text:
                  '${S.of(context).hoursShort(hours)}:  '
                  '${S.of(context).profitable} ${horizon.winRate.toStringAsFixed(0)}%  ·  '
                  '${S.of(context).averageResult} ${_signed(horizon.average)}%',
              fontSize: 13,
              color: horizon.average > 0
                  ? AppColors.positive
                  : AppColors.negative,
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final SignalRecord record;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat(
      'dd.MM HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(record.entryTime));
    final setup = switch (record.setup) {
      ReversalSetup.wickRejection => S.of(context).wickRejection,
      ReversalSetup.structureBreak => S.of(context).structureBreak,
    };
    final filters = record.passedFilters
        ? S.of(context).filtersPassed
        : S.of(context).filtersNotPassed;
    final result = record.results[4];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.jacarta),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                CustomNewText(
                  text: '${record.name} · ${record.symbol}',
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                CustomNewText(
                  text: '$time · $setup · $filters',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          CustomNewText(
            text: result == null
                ? S.of(context).waitingForResult
                : '${S.of(context).hoursShort(4)}: ${_signed(result)}%',
            fontSize: 13,
            color: result == null
                ? AppColors.textSecondary
                : (result > 0 ? AppColors.positive : AppColors.negative),
          ),
        ],
      ),
    );
  }
}

String _signed(double value) =>
    '${value > 0 ? '+' : ''}${value.toStringAsFixed(2)}';
