import '../../home/language/data/models/language.dart';

abstract class AppLocaleEvent {
  const AppLocaleEvent();
}

class LanguageChangedEvent extends AppLocaleEvent {
  const LanguageChangedEvent(this.language);

  final Language language;
}
