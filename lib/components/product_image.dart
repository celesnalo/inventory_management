import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final code = productCode.trim();
    final photoRadius = radius - 3;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primarySoft, // light green ring
      child: Stack(
        children: [
          // Bottom layer: category picture, with the .jpg photo on top of it
          CircleAvatar(
            radius: photoRadius,
            backgroundImage: AssetImage(Product.imageForCategory(category)),
            foregroundImage: AssetImage('assets/images/$code.jpg'),
            onForegroundImageError: (error, stackTrace) {}, // no .jpg: ignore
          ),
          // Top layer: the .png photo (transparent if there is no .png)
          CircleAvatar(
            radius: photoRadius,
            backgroundColor: Colors.transparent,
            foregroundImage: AssetImage('assets/images/$code.png'),
            onForegroundImageError: (error, stackTrace) {}, // no .png: ignore
          ),
        ],
      ),
    );
  }
}
