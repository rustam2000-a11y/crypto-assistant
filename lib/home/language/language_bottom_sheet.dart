import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../../presentation/app_images.dart';
import '../../widget/custom_button.dart';
import 'bloc/language_bloc.dart';
import 'bloc/language_effect.dart';
import 'bloc/language_event.dart';
import 'bloc/language_state.dart';
import 'bottom_sheet_wrapper.dart';
import 'data/models/language.dart';
import 'language_card_widget.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late final LanguageBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<LanguageBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocEffectBuilder<LanguageBloc, LanguageState, LanguageEffect>(
      bloc: _bloc,
      effectListener: (context, effect) {
        switch (effect) {
          case LanguageApplied():
            Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return BottomSheetWrapper(
          body: Column(
            spacing: 8,
            children: [
              LanguageCardWidget(
                active: state.selectedLanguage == Language.english,
                icon: AppImages.englishFlag,
                language: Language.english.label,
                onTap: () =>
                    _bloc.add(const SelectLanguageEvent(Language.english)),
              ),
              LanguageCardWidget(
                active: state.selectedLanguage == Language.russian,
                icon: AppImages.russianFlag,
                language: Language.russian.label,
                onTap: () =>
                    _bloc.add(const SelectLanguageEvent(Language.russian)),
              ),
            ],
          ),
          bottomWidget: CustomButton(
            onTap: () => _bloc.add(const ApplyLanguageEvent()),
            name: S.of(context).apply,
          ),
        );
      },
    );
  }
}
