import 'package:flutter/material.dart';
import '../components/details_form.dart';
import '../components/header.dart';
import '../data/product_store.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Header(headerTitle: 'Add Product'),
              FormFields(
                onSave: (product) async {
                  await ProductStore.instance.add(product);
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
