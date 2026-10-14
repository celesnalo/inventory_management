import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/delete_dialog.dart';
import '../components/detail_card.dart';
import '../components/product_card.dart';
import '../data/product_store.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import 'edit_screen.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  // Edit screen returns the updated product when the user saves.
  Future<void> editProduct() async {
    final updated = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => EditProduct(product: product)),
    );
    if (updated != null) {
      setState(() {
        product = updated;
      });
    }
  }

  Future<void> deleteProduct() async {
    final confirmed = await confirmDelete(context, product);
    if (!confirmed) return;
    await ProductStore.instance.delete(product.productCode);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ProductCard(product: product),
              const SizedBox(height: 12),
              DetailCard(product: product),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Button(buttonText: 'Edit', buttonColor: AppColors.primary, onTap: editProduct),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Button(buttonText: 'Delete', buttonColor: AppColors.danger, onTap: deleteProduct),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
