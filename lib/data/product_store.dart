import 'dart:io';
import '../models/product.dart';

/// Holds the product list and keeps products.txt in sync.
/// Screens call setState after add / edit / delete to refresh themselves.

class ProductStore {
  ProductStore._();
  static final ProductStore instance = ProductStore._();

  // For browser execution, store falls back to the sample data below and keeps changes in memory only.
  static const String _sampleData = 
  '''
  PRD001,Coca-Cola 2L,Beverages,24.99,35,Available
  PRD002,White Bread,Bakery,18.50,12,Available
  PRD003,Fresh Milk 2L,Dairy,32.99,4,Low Stock
  PRD004,Washing Powder 2kg,Household,79.99,0,Out of Stock
  PRD005,USB Keyboard,Electronics,199.99,8,Available
  ''';

  final List<Product> _products = [];
  File? _file;
  bool loaded = false;
  bool _memoryOnly = false; // true when no file access (web browser)

  List<Product> get products => List.unmodifiable(_products);

  Product? findByCode(String code) {
    for (final p in _products) {
      if (p.productCode.toLowerCase() == code.toLowerCase()) return p;
    }
    return null;
  }

  /// Finds products.txt (project folder on desktop, temp folder as fallback).
  Future<File> _locateFile() async {
    if (_file != null) return _file!;
    try {
      final f = File('${Directory.current.path}${Platform.pathSeparator}products.txt');
      if (!await f.exists()) await f.create();
      _file = f;
    } catch (_) {
      final f = File('${Directory.systemTemp.path}${Platform.pathSeparator}products.txt');
      if (!await f.exists()) await f.create();
      _file = f;
    }
    return _file!;
  }

  void _parseLines(List<String> lines) {
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      final p = Product.fromLine(line);
      if (p != null) _products.add(p);
    }
  }

  /// Called at startup to read products.txt, creating it if it does not exist.
  /// If files are not available (web), use the sample data in memory instead.
  Future<void> load() async {
    _products.clear();
    try {
      final file = await _locateFile();
      final lines = await file.readAsLines();
      _parseLines(lines);
    } catch (_) {
      _memoryOnly = true;
      _products.clear();
      _parseLines(_sampleData.split('\n'));
    }
    loaded = true;
  }

  /// Rewrite products.txt with the current records.
  Future<void> _save() async {
    if (_memoryOnly) return;
    try {
      final file = await _locateFile();
      final text = _products.map((p) => p.toLine()).join('\n');
      await file.writeAsString(_products.isEmpty ? '' : '$text\n');
    } catch (_) {
      _memoryOnly = true; // keep the app working even if the file cannot be written
    }
  }

  Future<void> add(Product product) async {
    _products.add(product);
    await _save();
  }

  /// Replaces the product that had [oldCode] with [updated].
  Future<void> update(String oldCode, Product updated) async {
    final i = _products.indexWhere((p) => p.productCode == oldCode);
    if (i == -1) return;
    _products[i] = updated;
    await _save();
  }

  Future<void> delete(String code) async {
    _products.removeWhere((p) => p.productCode == code);
    await _save();
  }
}
