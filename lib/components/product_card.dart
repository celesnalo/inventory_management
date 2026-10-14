import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import 'product_image.dart';

/// Big image + name card at the top of the detail screen.
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: Colors.black26,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ProductImage(productCode: product.productCode, category: product.category, radius: 70),
              const SizedBox(height: 14),
              Text(
                product.productName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink),
              ),
              const SizedBox(height: 4),
              Text(product.category, style: const TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
