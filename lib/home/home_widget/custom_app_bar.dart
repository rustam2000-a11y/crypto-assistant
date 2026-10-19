import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/ui/device_layout.dart';
import '../../core/ui/ui_provider.dart';
import '../../presentation/app_colors.dart';
import '../../widget/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.text,
    this.colors = AppColors.haiti,
    this.leadingIcon = true,
    this.action,
  });

  final String text;
  final Color colors;
  final bool leadingIcon;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return AppBar(
      title: CustomNewText(
        text: text,
        color: AppColors.whiteColor,
        fontSize: isTablet ? 22 : 16,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: colors,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: leadingIcon
          ? IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
            )
          : const SizedBox(),
      actions: [
        if (action != null)
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Row(
              spacing: 13,
              mainAxisSize: MainAxisSize.min,
              children: action!,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
