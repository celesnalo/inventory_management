// Group members
// JVM Madona 224078135
// MS Cele    221011743
// N Zulu     224009178
// A Maseko   224115442
// E Simelane 224020386
// AJ Saal    223054706
// NN Ntseke  224063526
// RP Moloi 	 224104274

/// Model for one product record.
class Product {
  final String productCode;
  final String productName;
  final String category;
  final double unitPrice;
  final int quantityInStock;
  final String status;

  Product({
    required this.productCode,
    required this.productName,
    required this.category,
    required this.unitPrice,
    required this.quantityInStock,
    required this.status,
  });

  static const List<String> categories = [
    'Beverages',
    'Groceries',
    'Bakery',
    'Dairy',
    'Household',
    'Personal Care',
    'Electronics',
    'Other',
  ];

  static const List<String> statuses = ['Available', 'Low Stock', 'Out of Stock'];

  /// Image is derived from the category
  static String imageForCategory(String category) {
    final name = category.toLowerCase().replaceAll(' ', '_');
    return 'assets/images/$name.png';
  }

  String get image => imageForCategory(category);

  /// Format: ProductCode,ProductName,Category,Price,Quantity,Status
  String toLine() =>
      '$productCode,$productName,$category,${unitPrice.toStringAsFixed(2)},$quantityInStock,$status';

  /// Returns null when the line is malformed.
  static Product? fromLine(String line) {
    final parts = line.split(',');
    if (parts.length != 6) return null;
    final price = double.tryParse(parts[3].trim());
    final qty = int.tryParse(parts[4].trim());
    if (price == null || qty == null) return null;
    return Product(
      productCode: parts[0].trim(),
      productName: parts[1].trim(),
      category: parts[2].trim(),
      unitPrice: price,
      quantityInStock: qty,
      status: parts[5].trim(),
    );
  }
}
