import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonKind { primary, secondary, danger }

/// Rounded button. Fills the width it is given, so wrap it in Expanded inside a Row.
class Button extends StatelessWidget {
  final String buttonText;
  final ButtonKind kind;
  final VoidCallback? onTap;

  const Button({super.key, required this.buttonText, this.kind = ButtonKind.primary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color background;
    Color textColor;
    Color borderColor;
    switch (kind) {
      case ButtonKind.primary:
        background = AppColors.primary;
        textColor = Colors.white;
        borderColor = AppColors.primary;
        break;
      case ButtonKind.danger:
        background = AppColors.danger;
        textColor = Colors.white;
        borderColor = AppColors.danger;
        break;
      case ButtonKind.secondary:
        background = Colors.white;
        textColor = AppColors.ink;
        borderColor = AppColors.border;
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
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
