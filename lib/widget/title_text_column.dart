import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/ui/device_layout.dart';
import '../core/ui/ui_provider.dart';
import '../presentation/app_colors.dart';
import 'custom_text.dart';

class TitleTextColumn extends StatelessWidget {
  const TitleTextColumn({
    super.key,
    required this.title,
    required this.text,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.fonSizeFirst,
    this.fonSizeLast,
  });

  final String title;
  final String text;
  final CrossAxisAlignment crossAxisAlignment;
  final double? fonSizeFirst;
  final double? fonSizeLast;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      spacing: 4,
      children: [
        CustomNewText(
          text: title,
          fontSize: fonSizeFirst ?? (isTablet ? 18 : 14),
          color: AppColors.titanWhite,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        CustomNewText(
          text: text,
          fontSize: fonSizeFirst ?? (isTablet ? 18 : 12),
          color: AppColors.victoria,
        ),
      ],
    );
  }
}
