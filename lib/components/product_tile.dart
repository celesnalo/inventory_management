import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import 'product_image.dart';
import 'status_label.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProductTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ProductImage(productCode: product.productCode, category: product.category, radius: 28),
        title: Text(
          product.productName,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink),
        ),
        subtitle: Text(
          '${product.productCode} | R${product.unitPrice.toStringAsFixed(2)}',
          style: const TextStyle(color: AppColors.muted),
        ),
        trailing: StatusLabel(status: product.status),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
