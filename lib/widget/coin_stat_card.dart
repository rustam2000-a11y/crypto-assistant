import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/ui/device_layout.dart';
import '../core/ui/ui_provider.dart';
import '../presentation/app_colors.dart';
import 'custom_text.dart';

class CoinStatCard extends StatelessWidget {
  const CoinStatCard({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNewText(
            text: title,
            fontSize: isTablet ? 16 : 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          CustomNewText(
            text: value,
            fontSize: isTablet ? 20 : 15,
            color: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}
