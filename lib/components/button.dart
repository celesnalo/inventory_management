import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Rounded button.
class Button extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? onTap;

  const Button({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // White buttons with a light grey border.
    final borderColor = buttonColor == Colors.white ? AppColors.border : buttonColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          buttonText,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
