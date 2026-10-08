import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';

import '../data/signal_journal_repository.dart';
import 'signal_journal_effect.dart';
import 'signal_journal_event.dart';
import 'signal_journal_state.dart';

@injectable
class SignalJournalBloc
    extends
        EffectBloc<
          SignalJournalEvent,
          SignalJournalState,
          SignalJournalEffect
        > {
  SignalJournalBloc({required SignalJournalRepositoryI repository})
    : _repository = repository,
      super(const SignalJournalState()) {
    on<LoadSignalJournalEvent>((event, emit) {
      // Сначала показываем то, что уже есть, потом досчитываем результаты.
      emit(state.copyWith(records: _repository.records(), isLoading: true));
      _resolve();
    });
    on<SignalJournalLoadedEvent>((event, emit) {
      emit(state.copyWith(records: event.records, isLoading: false));
    });
  }

  final SignalJournalRepositoryI _repository;

  Future<void> _resolve() async {
    try {
      add(SignalJournalLoadedEvent(await _repository.resolvePending()));
    } catch (error) {
      emitEffect(SignalJournalShowError(error.toString()));
      add(SignalJournalLoadedEvent(_repository.records()));
    }
  }
}
