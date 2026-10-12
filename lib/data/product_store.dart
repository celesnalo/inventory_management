import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Holds the product list and keeps products.txt in sync.
/// Screens listen to this object (ChangeNotifier) and rebuild when it changes.
class ProductStore extends ChangeNotifier {
  ProductStore._();
  static final ProductStore instance = ProductStore._();

  final List<Product> _products = [];
  File? _file;
  bool loaded = false;

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

  /// Called at startup: read products.txt, creating it if it does not exist.
  Future<void> load() async {
    final file = await _locateFile();
    final lines = await file.readAsLines(encoding: utf8);
    _products.clear();
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      final p = Product.fromLine(line);
      if (p != null) _products.add(p);
    }
    loaded = true;
    notifyListeners();
  }

  /// Rewrites products.txt with the current records.
  Future<void> _save() async {
    final file = await _locateFile();
    final text = _products.map((p) => p.toLine()).join('\n');
    await file.writeAsString(_products.isEmpty ? '' : '$text\n');
  }

  Future<void> add(Product product) async {
    _products.add(product);
    await _save();
    notifyListeners();
  }

  /// Replaces the product that had [oldCode] with [updated].
  Future<void> update(String oldCode, Product updated) async {
    final i = _products.indexWhere((p) => p.productCode == oldCode);
    if (i == -1) return;
    _products[i] = updated;
    await _save();
    notifyListeners();
  }

  Future<void> delete(String code) async {
    _products.removeWhere((p) => p.productCode == code);
    await _save();
    notifyListeners();
  }
}
