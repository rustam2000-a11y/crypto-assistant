import 'package:equatable/equatable.dart';

import '../domain/pump_reversal/journal_stats.dart';
import '../domain/pump_reversal/signal_record.dart';

class SignalJournalState extends Equatable {
  const SignalJournalState({this.records = const [], this.isLoading = false});

  final List<SignalRecord> records;
  final bool isLoading;

  /// Сигналы, прошедшие фильтры режима BTC и рынка, — это и есть формула.
  JournalStats get formula =>
      JournalStats.from(records.where((r) => r.passedFilters));

  /// Все паттерны без фильтров — для сравнения.
  JournalStats get patternOnly => JournalStats.from(records);

  SignalJournalState copyWith({List<SignalRecord>? records, bool? isLoading}) {
    return SignalJournalState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [records, isLoading];
}
