import 'dart:async';

import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:injectable/injectable.dart';

import '../../home/language/data/models/language.dart';
import '../../home/language/data/repository/language_repository.dart';
import 'app_locale_effect.dart';
import 'app_locale_event.dart';
import 'app_locale_state.dart';

@lazySingleton
class AppLocaleBloc
    extends EffectBloc<AppLocaleEvent, AppLocaleState, AppLocaleEffect> {
  AppLocaleBloc({required LanguageRepositoryI languageRepository})
    : _languageRepository = languageRepository,
      super(AppLocaleState(language: languageRepository.currentLanguage)) {
    on<LanguageChangedEvent>((event, emit) {
      emit(AppLocaleState(language: event.language));
    });
    init();
  }

  final LanguageRepositoryI _languageRepository;
  late final StreamSubscription<Language> _languageSubscription;
  init(){
    _languageSubscription = _languageRepository.languageStream.listen((
        language,
        ) {
      add(LanguageChangedEvent(language));
    });
  }
  @override
  Future<void> close() {
    _languageSubscription.cancel();
    return super.close();
  }
}
