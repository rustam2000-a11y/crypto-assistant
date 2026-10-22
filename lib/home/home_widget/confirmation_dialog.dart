import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../presentation/app_colors.dart';
import '../../presentation/app_images.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bunting,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.jacarta),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.borderRed.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Image.asset(
                    AppImages.exit,
                    width: 24,
                    height: 24,
                    color: AppColors.borderRed,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomNewText(
                text: S.of(context).logOutTitle,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              CustomNewText(
                text: S.of(context).logOutDescription,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              const SizedBox(height: 24),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () => Navigator.pop(context),
                      name: S.of(context).cancel,
                      color: AppColors.jacarta,
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      onTap: onTap,
                      name: S.of(context).exit,
                      color: AppColors.borderRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
