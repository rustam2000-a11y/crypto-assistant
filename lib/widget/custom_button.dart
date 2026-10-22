import 'package:flutter/material.dart';
import '../presentation/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.name,
    this.icon,
    this.color,
  });

  final String name;
  final Color? color;
  final String? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.jacarta,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
       borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Image.asset(icon!, width: 20, height: 20),
                const SizedBox(width: 8),
              ],
              CustomNewText(
                text: name,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
