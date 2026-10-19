import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/ui/device_layout.dart';
import '../core/ui/ui_provider.dart';
import '../presentation/app_colors.dart';
import 'custom_text.dart';

class CoinStatColumn extends StatelessWidget {
  const CoinStatColumn({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        CustomNewText(
          text: title,
          fontSize: isTablet ? 15 : 11,
          color: AppColors.victoria,
        ),
        CustomNewText(
          text: text,
          fontSize: isTablet ? 17 : 13,
          color: AppColors.blueBell,
        ),
      ],
    );
  }
}
