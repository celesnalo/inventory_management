import 'package:flutter/material.dart';
import '../components/details_form.dart';
import '../components/header.dart';
import '../data/product_store.dart';
import '../models/product.dart';

class EditProduct extends StatelessWidget {
  final Product product;
  const EditProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Header(headerTitle: 'Edit Product'),
              FormFields(
                initial: product,
                submitLabel: 'Update',
                onSave: (updated) async {
                  await ProductStore.instance.update(product.productCode, updated);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
