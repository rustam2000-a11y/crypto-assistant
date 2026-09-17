import 'package:crypto_assistant/presentation/app_colors.dart';
import 'package:crypto_assistant/widget/custom_text.dart';
import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({
    super.key,
    required this.firstText,
    required this.secondaryText,
  });

  final String firstText;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        CustomNewText(text: firstText, fontSize: 30),
        CustomNewText(
          text: secondaryText,
          fontSize: 15,
          color: AppColors.textSecondary,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
