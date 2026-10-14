import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Coloured pill for Available / Low Stock / Out of Stock.
class StatusLabel extends StatelessWidget {
  final String status;
  const StatusLabel({super.key, required this.status});

  static Color colorFor(String status) {
    switch (status) {
      case 'Available':
        return AppColors.primaryDark;
      case 'Low Stock':
        return AppColors.warning;
      default:
        return AppColors.danger;
    }
  }

  static Color softColorFor(String status) {
    switch (status) {
      case 'Available':
        return AppColors.primarySoft;
      case 'Low Stock':
        return AppColors.warningSoft;
      default:
        return AppColors.dangerSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: softColorFor(status),
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(width: 0.5)
      ),
      child: Text(
        status,
        style: TextStyle(color: colorFor(status), fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
