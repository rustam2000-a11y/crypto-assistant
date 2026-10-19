import 'package:flutter/material.dart';
import '../presentation/app_colors.dart';

class CustomNewText extends StatelessWidget {
  const CustomNewText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.center,
    this.underline = false,
    this.height = 1.33,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final bool underline;
  final double height;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: fontSize,
        color: color ?? AppColors.whiteColor,
        fontWeight: fontWeight,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        height: height,
      ),
    );
  }
}
