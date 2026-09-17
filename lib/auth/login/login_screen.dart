import 'package:bloc_after_effect/bloc_after_effect.dart';
import 'package:crypto_assistant/home/home_widget/custom_app_bar.dart';
import 'package:crypto_assistant/presentation/app_images.dart';
import 'package:crypto_assistant/auth/registration/registration_screen.dart';
import 'package:crypto_assistant/widget/custom_button.dart';
import 'package:crypto_assistant/widget/custom_text.dart';
import 'package:crypto_assistant/widget/login_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ui/device_layout.dart';
import '../../core/ui/ui_provider.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../../presentation/app_colors.dart';
import '../../widget/custom_divider.dart';
import '../../widget/custom_text_field.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_effect.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginBloc _bloc;

  @override
  void initState() {
    _bloc = getIt<LoginBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocEffectBuilder<LoginBloc, LoginState, LoginEffect>(
      bloc: _bloc,
      effectListener: (context, effect) {
        switch (effect) {
          case LoginSucceeded():
            Navigator.pop(context);
          case LoginFailed(:final message):
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;

        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginTitle(
                  firstText: S.of(context).welcomeBack,
                  secondaryText: S.of(context).logInToKeepFollowingTheMarket,
                ),
                SizedBox(height: 30),
                CustomTextField(
                  label: 'Email',
                  onChanged: (value) => _bloc.add(LoginEmailChanged(value)),
                  hintText: 'Email',
                  leftIcon: Icons.email_outlined,
                ),
                SizedBox(height: 15),
                CustomPasswordTextField(
                  label: S.of(context).password,
                  error: state.error,
                  onChanged: (value) =>
                      _bloc.add(LoginPasswordChanged(value)),
                ),
                SizedBox(height: 30),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    onTap: () => _bloc.add(const SignInWithEmailPressed()),
                    name: S.of(context).logIn,
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
                            _bloc.add(const SignInWithGooglePressed());
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
                            _bloc.add(const SignInWithApplePressed());
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
                  text: S.of(context).dontHaveAnAccount,
                  fontSize: 18,
                ),
                InkWell(
                  onTap: () async {
                    final registered = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                    if (registered == true && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: CustomNewText(
                    text: S.of(context).signUp,
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
