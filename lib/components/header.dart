import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Screen title with an optional record-count pill and an optional round back button.
class Header extends StatelessWidget {
  final String headerTitle;
  final String? subtitle;
  final bool showBack;

  const Header({super.key, required this.headerTitle, this.subtitle, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              headerTitle,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.ink),
            ),
            if (showBack)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.softShadow,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.ink),
                  ),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Divider(color: Colors.black, thickness: 1.5)
      ],
    );
  }
}
