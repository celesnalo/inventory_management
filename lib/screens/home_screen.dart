import 'package:flutter/material.dart';
import '../components/delete_dialog.dart';
import '../components/header.dart';
import '../components/product_tile.dart';
import '../data/product_store.dart';
import '../theme/app_colors.dart';
import 'add_screen.dart';
import 'detail_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final store = ProductStore.instance;

  @override
  void initState() {
    super.initState();
    store.load(); // read products.txt on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final products = store.products;
            return Column(
              children: [
                Header(
                  headerTitle: 'Products',
                  subtitle: store.loaded ? '${products.length} record(s)' : null,
                ),
                Expanded(
                  child: !store.loaded
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : products.isEmpty
                          ? const Center(
                              child: Text(
                                'No products yet. Tap + to add one.',
                                style: TextStyle(color: AppColors.muted),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductTile(
                                  product: product,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetail(productCode: product.productCode),
                                    ),
                                  ),
                                  onLongPress: () async {
                                    if (await confirmDelete(context, product)) {
                                      await store.delete(product.productCode);
                                    }
                                  },
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddProduct()),
        ),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
