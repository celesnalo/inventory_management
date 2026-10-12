import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import 'status_label.dart';

class DetailCard extends StatelessWidget {
  final Product product;
  const DetailCard({super.key, required this.product});

  Widget _row(String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted)),
        value,
      ],
    );
  }

  Text _value(String text, {Color color = AppColors.ink}) =>
      Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: color));

  Widget _divider() => const Divider(color: AppColors.border, thickness: 1, height: 24);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          _row('Product Code', _value(product.productCode)),
          _divider(),
          _row('Category', _value(product.category)),
          _divider(),
          _row('Unit Price', _value('R${product.unitPrice.toStringAsFixed(2)}', color: AppColors.primaryDark)),
          _divider(),
          _row('Quantity In Stock', _value(product.quantityInStock.toString())),
          _divider(),
          _row('Status', StatusLabel(status: product.status)),
        ],
      ),
    );
  }
}
