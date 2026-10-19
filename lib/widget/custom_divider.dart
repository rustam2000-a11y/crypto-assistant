import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../presentation/app_colors.dart';
import 'custom_text.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        CustomNewText(text: S.of(context).or, color: AppColors.textSecondary),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
