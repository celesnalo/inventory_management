import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';

/// Round product picture.
/// Looks for assets/images ProductCode.png (then .jpg, .jpeg).
/// If no photo exists for that code, falls back to the category picture.
class ProductImage extends StatelessWidget {
  final String productCode;
  final String category;
  final double radius;

  const ProductImage({
    super.key,
    required this.productCode,
    required this.category,
    required this.radius,
  });

  static const List<String> _extensions = ['png', 'jpg', 'jpeg'];

  Widget _load(int i) {
    if (i >= _extensions.length) {
      return Image.asset(Product.imageForCategory(category), fit: BoxFit.cover);
    }
    return Image.asset(
      'assets/images/${productCode.trim()}.${_extensions[i]}',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _load(i + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primarySoft),
      child: ClipOval(child: _load(0)),
    );
  }
}
