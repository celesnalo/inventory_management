import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/delete_dialog.dart';
import '../components/detail_card.dart';
import '../components/header.dart';
import '../components/product_card.dart';
import '../data/product_store.dart';
import '../models/product.dart';
import 'edit_screen.dart';

class ProductDetail extends StatelessWidget {
  final String productCode;
  const ProductDetail({super.key, required this.productCode});

  @override
  Widget build(BuildContext context) {
    final store = ProductStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final Product? product = store.findByCode(productCode);
        if (product == null) {
          //  The screen closes itself if a Product was deleted or edited;
          return const Scaffold(body: SizedBox.shrink());
        }
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Header(headerTitle: 'Detail', showBack: true),
                  ProductCard(product: product),
                  const SizedBox(height: 12),
                  DetailCard(product: product),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          buttonText: 'Edit',
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            await navigator.push(
                              MaterialPageRoute(builder: (_) => EditProduct(product: product)),
                            );
                            // If the code was changed, the old code no longer exists: go back to the list.
                            if (store.findByCode(productCode) == null && navigator.mounted) {
                              navigator.maybePop();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Button(
                          buttonText: 'Delete',
                          kind: ButtonKind.danger,
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            if (await confirmDelete(context, product)) {
                              await store.delete(product.productCode);
                              if (navigator.mounted) navigator.pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
