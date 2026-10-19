import 'package:flutter/material.dart';

import '../../presentation/app_colors.dart';
import '../../widget/custom_text.dart';

class LanguageCardWidget extends StatelessWidget {
  const LanguageCardWidget({
    super.key,
    required this.active,
    required this.icon,
    required this.language,
    required this.onTap,
  });

  final bool active;
  final String icon;
  final String language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? AppColors.selectedItemBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          spacing: 8,
          children: [
            Image.asset(icon, height: 20, width: 20),
            CustomNewText(text: language, fontSize: 18),
            const Spacer(),
            if (active)
              const Icon(Icons.check, color: AppColors.negative)
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
