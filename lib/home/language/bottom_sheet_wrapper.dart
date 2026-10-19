import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../presentation/app_colors.dart';
import '../../widget/custom_text.dart';

class BottomSheetWrapper extends StatelessWidget {
  const BottomSheetWrapper({super.key, required this.body, this.bottomWidget});

  final Widget body;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.sheetBackground,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 3,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.sheetHandle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomNewText(text: S.of(context).language, fontSize: 20),
                    Material(
                      shape: const CircleBorder(),
                      color: AppColors.closeButtonBackground,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.close, color: AppColors.closeIcon),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                body,
              ],
            ),
          ),
          SafeArea(child: bottomWidget ?? const SizedBox()),
        ],
      ),
    );
  }
}
