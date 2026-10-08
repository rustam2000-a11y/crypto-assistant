import 'package:equatable/equatable.dart';

abstract class SignalJournalEffect extends Equatable {
  const SignalJournalEffect();

  @override
  List<Object?> get props => [];
}

class SignalJournalShowError extends SignalJournalEffect {
  const SignalJournalShowError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
