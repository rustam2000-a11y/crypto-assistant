import 'package:crypto_assistant/presentation/app_colors.dart';
import 'package:crypto_assistant/widget/custom_text.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hintText,
    this.borderRadius = 12,
    this.leftIcon,
    this.rightIcon,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final double borderRadius;
  final IconData? leftIcon;
  final IconData? rightIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CustomNewText(
          text: label,
          textAlign: TextAlign.start,
          fontSize: 18,
          color: AppColors.titanWhite,
        ),
        TextField(
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.activeBorder,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.blueBell,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: leftIcon != null
                ? Icon(leftIcon, color: AppColors.blueBell, size: 20)
                : null,
            suffixIcon: rightIcon != null
                ? Icon(rightIcon, color: AppColors.blueBell)
                : null,
            filled: true,
            fillColor: AppColors.containerColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.jacarta, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: AppColors.activeBorder,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.hintText,
    this.borderRadius = 12,
    this.leftIcon = Icons.lock_outline,
    this.error = false,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final double borderRadius;
  final IconData? leftIcon;
  final bool error;

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CustomNewText(
          text: widget.label,
          textAlign: TextAlign.start,
          fontSize: 18,
          color: AppColors.titanWhite,
        ),
        TextField(
          onChanged: widget.onChanged,
          obscureText: _obscureText,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.skyBlue,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Password',
            hintStyle: const TextStyle(
              color: AppColors.blueBell,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: widget.leftIcon != null
                ? Icon(widget.leftIcon, color: AppColors.blueBell)
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.blueBell,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
            filled: true,
            fillColor: AppColors.containerColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: AppColors.jacarta, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: AppColors.activeBorder, width: 1),
            ),
            errorText: widget.error
                ? S.of(context).thePasswordMustBeAtLeast6CharactersLong
                : null,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.error ? AppColors.borderRed : AppColors.jacarta,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.error ? AppColors.borderRed : AppColors.jacarta,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
