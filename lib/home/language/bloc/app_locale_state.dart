import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../data/models/language.dart';

class AppLocaleState extends Equatable {
  const AppLocaleState({required this.language});

  final Language language;

  Locale get locale => language.locale;

  @override
  List<Object?> get props => [language];
}
