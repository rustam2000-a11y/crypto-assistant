import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:crypto_assistant/widget/login_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/errors/auth_error_type.dart';
import '../../core/ui/device_layout.dart';
import '../../core/ui/ui_provider.dart';
import '../../generated/l10n.dart';
import '../../home/home_widget/custom_app_bar.dart';
import '../../injection.dart';
import '../../presentation/app_colors.dart';
import '../../presentation/app_images.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_divider.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_text_field.dart';
import 'bloc/registration_bloc.dart';
import 'bloc/registration_effect.dart';
import 'bloc/registration_event.dart';
import 'bloc/registration_state.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final RegistrationBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<RegistrationBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocEffectBuilder<
      RegistrationBloc,
      RegistrationState,
      RegistrationEffect
    >(
      bloc: _bloc,
      effectListener: (context, effect) {
        switch (effect) {
          case RegistrationSucceeded():
            Navigator.pop(context, true);
          case RegistrationFailed(:final errorType):
            final message = switch (errorType) {
              AuthErrorType.weakPassword => S.of(context).weakPassword,
              AuthErrorType.emailAlreadyInUse =>
                S.of(context).emailAlreadyInUse,
              AuthErrorType.invalidEmail => S.of(context).invalidEmail,
              AuthErrorType.unknown => S.of(context).failedToSignUp,
            };
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;

        final content = Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginTitle(
                  firstText: S.of(context).createAnAccount,
                  secondaryText: S.of(context).itTakesLessThanAMinute,
                ),
                SizedBox(height: 30),
                CustomTextField(
                  label: S.of(context).name,
                  onChanged: (value) => _bloc.add(RegisterNameChanged(value)),
                  hintText: 'Name',
                  leftIcon: Icons.email_outlined,
                ),
                SizedBox(height: 15),
                CustomTextField(
                  label: 'Email',
                  onChanged: (value) => _bloc.add(RegisterEmailChanged(value)),
                  hintText: 'Email',
                  leftIcon: Icons.email_outlined,
                ),
                SizedBox(height: 15),
                CustomPasswordTextField(
                  label: S.of(context).password,
                  error: state.error,
                  onChanged: (value) =>
                      _bloc.add(RegisterPasswordChanged(value)),
                ),
                SizedBox(height: 30),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    onTap: () => _bloc.add(const RegisterWithEmailPressed()),
                    name: S.of(context).signUp,
                  ),
                SizedBox(height: 30),
                CustomDivider(),
                SizedBox(height: 30),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          if (!_bloc.state.isLoading) {
                            _bloc.add(const RegisterWithGooglePressed());
                          }
                        },
                        name: 'Google',
                        icon: AppImages.google,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          if (!_bloc.state.isLoading) {
                            _bloc.add(const RegisterWithApplePressed());
                          }
                        },
                        name: 'Apple',
                        icon: AppImages.apple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                CustomNewText(
                  text: S.of(context).alreadyHaveAnAccount,
                  fontSize: 18,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CustomNewText(
                    text: S.of(context).logIn,
                    fontSize: 18,
                    color: AppColors.activeBorder,
                  ),
                ),
              ],
            ),
          ],
        );

        return Scaffold(
          appBar: CustomAppBar(text: ''),
          backgroundColor: AppColors.haiti,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              child: isTablet
                  ? Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: content,
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(child: content),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
