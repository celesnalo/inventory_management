import 'package:flutter/material.dart';
import '../components/delete_dialog.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // Read products.txt once when the app starts.
  Future<void> loadProducts() async {
    await store.load();
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = store.products;

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: SafeArea(
        child: Column(
                children: [
                  // Record count
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                      border: BoxBorder.all(width: 0.2)
                    ),
                    child: Text(
                      '${products.length} record(s)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                    ),
                  ),
                  Divider(color: Colors.black, thickness: 1.5, indent: 50, endIndent: 50),
                  Expanded(
                    child: products.isEmpty
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
                                // Detail screen refreshes.
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ProductDetail(product: product)),
                                  );
                                  setState(() {});
                                },
                                // Long press to confirm, then delete and refresh.
                                onLongPress: () async {
                                  final confirmed = await confirmDelete(context, product);
                                  if (confirmed) {
                                    await store.delete(product.productCode);
                                    setState(() {});
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        tooltip: 'Add Product',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProduct()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
