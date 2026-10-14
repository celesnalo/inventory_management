import 'package:flutter_test/flutter_test.dart';
import 'package:smartmart_inventory/models/product.dart';

void main() {
  test('Product line round trip', () {
    final p = Product.fromLine('PRD001,Coca-Cola 2L,Beverages,24.99,35,Available')!;
    expect(p.productName, 'Coca-Cola 2L');
    expect(p.unitPrice, 24.99);
    expect(p.quantityInStock, 35);
    expect(p.toLine(), 'PRD001,Coca-Cola 2L,Beverages,24.99,35,Available');
  });

  test('Malformed line returns null', () {
    expect(Product.fromLine('bad,line'), isNull);
  });
}
