import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/ui/device_layout.dart';
import '../../core/ui/ui_provider.dart';
import '../../presentation/app_colors.dart';
import '../../widget/custom_text.dart';

class AssistantCardInformation extends StatelessWidget {
  const AssistantCardInformation({
    super.key,
    required this.icon,
    required this.text,
    required this.description,
    required this.borderColor,
    this.onTap,
  });

  final String icon;
  final String text;
  final String description;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
          color: AppColors.portGore,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 220),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(icon, width: 30, height: 30),
                ),
                const SizedBox(height: 20),
                CustomNewText(
                  text: text,
                  fontSize: isTablet ? 20 : 15,
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
                CustomNewText(
                  fontSize: isTablet ? 18 : 14,
                  text: description,
                  color: AppColors.blueBell,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
