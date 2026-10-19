import 'package:crypto_assistant/presentation/app_colors.dart';
import 'package:crypto_assistant/widget/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.name,  this.icon, this.color});
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
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400,
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Image.asset(icon!, width: 20, height: 20),
                SizedBox(width: 8),
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
