import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/ui/device_layout.dart';
import '../core/ui/ui_provider.dart';
import '../presentation/app_colors.dart';
import 'app_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
  });

  final AppPage currentPage;
  final ValueChanged<AppPage> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.navBarBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: AppPage.values
            .map(
              (page) => _NavBarItem(
                page: page,
                isSelected: page == currentPage,
                onTap: () => onPageSelected(page),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  final AppPage page;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 14),
        color: Colors.transparent,
        child: Image.asset(
          page.icon,
          width: isTablet ? 24 : 20,
          height: isTablet ? 24 : 20,
          color: isSelected ? AppColors.whiteColor : AppColors.blueBell,
        ),
      ),
    );
  }
}
