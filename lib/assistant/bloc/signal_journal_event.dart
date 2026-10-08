import '../domain/pump_reversal/signal_record.dart';

abstract class SignalJournalEvent {
  const SignalJournalEvent();
}

class LoadSignalJournalEvent extends SignalJournalEvent {
  const LoadSignalJournalEvent();
}

class SignalJournalLoadedEvent extends SignalJournalEvent {
  const SignalJournalLoadedEvent(this.records);

  final List<SignalRecord> records;
}
