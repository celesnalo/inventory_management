import 'package:flutter/material.dart';
import '../data/product_store.dart';
import '../models/product.dart';
import '../theme/app_colors.dart';
import 'button.dart';
import 'product_image.dart';

/// The brief asks for Status as a DropdownButtonFormField (false = dropdown).
/// Set to true to show the radio-style status boxes from the wireframe instead.
const bool kStatusAsRadio = false;

const Map<String, IconData> _categoryIcons = {
  'Beverages': Icons.emoji_food_beverage,
  'Groceries': Icons.shopping_basket,
  'Bakery': Icons.bakery_dining,
  'Dairy': Icons.local_drink,
  'Household': Icons.cleaning_services,
  'Personal Care': Icons.spa,
  'Electronics': Icons.devices,
  'Other': Icons.category,
};

/// Add/Edit form. When [initial] is given the fields are pre-filled (edit mode).
class FormFields extends StatefulWidget {
  final Product? initial;
  final String submitLabel;
  final Future<void> Function(Product product) onSave;

  const FormFields({super.key, this.initial, this.submitLabel = 'Save', required this.onSave});

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _qty;
  late String _category;
  late String _status;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _code = TextEditingController(text: p?.productCode ?? '');
    _name = TextEditingController(text: p?.productName ?? '');
    _price = TextEditingController(text: p?.unitPrice.toStringAsFixed(2) ?? '');
    _qty = TextEditingController(text: p?.quantityInStock.toString() ?? '');
    _category = p?.category ?? Product.categories.first;
    _status = p?.status ?? Product.statuses.first;
    _code.addListener(() => setState(() {})); // refresh the image preview while typing
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _price.dispose();
    _qty.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label must not be empty';
    if (v.contains(',')) return '$label must not contain commas';
    return null;
  }

  String? _validateCode(String? v) {
    final msg = _required(v, 'Product code');
    if (msg != null) return msg;
    final existing = ProductStore.instance.findByCode(v!.trim());
    final editingCode = widget.initial?.productCode;
    if (existing != null && existing.productCode != editingCode) {
      return 'This product code already exists';
    }
    return null;
  }

  String? _validatePrice(String? v) {
    final price = double.tryParse((v ?? '').trim());
    if (price == null) return 'Enter a valid number';
    if (price <= 0) return 'Price must be greater than zero';
    return null;
  }

  String? _validateQty(String? v) {
    final qty = int.tryParse((v ?? '').trim());
    if (qty == null) return 'Enter a whole number';
    if (qty < 0) return 'Quantity may not be negative';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final product = Product(
      productCode: _code.text.trim(),
      productName: _name.text.trim(),
      category: _category,
      unitPrice: double.parse(_price.text.trim()),
      quantityInStock: int.parse(_qty.text.trim()),
      status: _status,
    );
    await widget.onSave(product);
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      hintStyle: const TextStyle(color: AppColors.muted),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
    );
  }

  /// Label above the control, like the wireframe.
  Widget _labeled(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  Widget _statusRadios() {
    return Column(
      children: Product.statuses.map((s) {
        final selected = s == _status;
        return GestureDetector(
          onTap: () => setState(() => _status = s),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: selected ? AppColors.primarySoft : Colors.white,
              border: Border.all(color: selected ? AppColors.primary : AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, size: 14, color: selected ? AppColors.primary : AppColors.border),
                const SizedBox(width: 12),
                Text(s),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _status,
      isExpanded: true,
      decoration: _decoration(''),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: Product.statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (v) => setState(() => _status = v!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _labeled(
            'Product Code *',
            TextFormField(controller: _code, decoration: _decoration('e.g. PRD001'), validator: _validateCode),
          ),
          _labeled(
            'Product Name *',
            TextFormField(
              controller: _name,
              decoration: _decoration('e.g. Coca-Cola 2L'),
              validator: (v) => _required(v, 'Product name'),
            ),
          ),
          _labeled(
            'Category',
            DropdownButtonFormField<String>(
              initialValue: _category,
              isExpanded: true,
              decoration: _decoration(''),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: Product.categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          Icon(_categoryIcons[c] ?? Icons.category, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(c),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
          ),
          _labeled(
            'Unit Price (R) *',
            TextFormField(
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _decoration('0.00'),
              validator: _validatePrice,
            ),
          ),
          _labeled(
            'Quantity In Stock *',
            TextFormField(
              controller: _qty,
              keyboardType: TextInputType.number,
              decoration: _decoration('0'),
              validator: _validateQty,
            ),
          ),
          _labeled('Status', kStatusAsRadio ? _statusRadios() : _statusDropdown()),
          // Product image comes from the assets folder: assets/images/<ProductCode>.png
          Row(
            children: [
              ProductImage(productCode: _code.text, category: _category, radius: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Image: assets/images/${_code.text.trim().isEmpty ? '<ProductCode>' : _code.text.trim()}.png\n'
                  '(category picture is used if this file does not exist)',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Button(
                  buttonText: 'Cancel',
                  kind: ButtonKind.secondary,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Button(buttonText: widget.submitLabel, onTap: _submit)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
