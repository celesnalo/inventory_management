import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import 'button.dart';

/// Shows a confirmation AlertDialog. Returns true only if the user confirms.
Future<bool> confirmDelete(BuildContext context, Product product) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.dangerSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Confirm DELETE',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Remove "${product.productName}" ?',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.ink),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This action cannot be undone', style: TextStyle(fontSize: 13, color: AppColors.muted)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Button(
                  buttonText: 'Cancel',
                  kind: ButtonKind.secondary,
                  onTap: () => Navigator.pop(ctx, false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  buttonText: 'Delete',
                  kind: ButtonKind.danger,
                  onTap: () => Navigator.pop(ctx, true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}
