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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.borderRed.withValues(alpha: 0.4),
                border: Border.all(color: AppColors.borderRed),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.exit,
                  width: 20,
                  height: 20,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            CustomNewText(
              text: S.of(context).areYouSureYouWantToLogOutOfYour,
              fontSize: 18,
            ),
            Row(
              spacing: 12,
              children: [
                Flexible(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context),
                    name: S.of(context).cancel,
                    color: AppColors.sheetHandle,
                  ),
                ),
                Flexible(
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
    );
  }
}
