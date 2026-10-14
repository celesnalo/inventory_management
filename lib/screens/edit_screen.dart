import 'package:flutter/material.dart';
import '../components/details_form.dart';
import '../data/product_store.dart';
import '../models/product.dart';

class EditProduct extends StatelessWidget {
  final Product product;
  const EditProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              FormFields(
                initial: product,
                submitLabel: 'Update',
                onSave: (updated) async {
                  await ProductStore.instance.update(product.productCode, updated);
                  if (context.mounted) Navigator.pop(context, updated); // send the updated product back
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
