// ui/widgets/calculator_button.dart
import 'package:flutter/material.dart';
import '../../ui/themes/color_palette.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool isSelected;

  const CalculatorButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.backgroundColor = AppColors.secondaryDark,
    this.textColor = AppColors.textPrimary,
    this.fontSize = 24,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.accentBlue.withOpacity(0.3) : backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
        ),
        child: icon != null
            ? Icon(icon, size: fontSize)
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}