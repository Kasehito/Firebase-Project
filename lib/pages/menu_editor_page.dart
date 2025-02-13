import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manganjawa/auth/auth_widgets/mycolors.dart';
import 'package:manganjawa/pages/widget/custom_input_field.dart';

class MenuEditor extends StatefulWidget {
  final Function(String, String, String, double, int) onSave;
  final String? initialName;
  final String? initialDescription;
  final String? initialCategory;
  final double? initialPrice;
  final int? initialStock;

  const MenuEditor({
    super.key,
    required this.onSave,
    this.initialName,
    this.initialDescription,
    this.initialCategory,
    this.initialPrice,
    this.initialStock,
  });

  @override
  State<MenuEditor> createState() => _MenuEditorPageState();
}

class _MenuEditorPageState extends State<MenuEditor> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _nameController.text = widget.initialName ?? '';
    _descController.text = widget.initialDescription ?? '';
    _priceController.text = widget.initialPrice?.toString() ?? '';
    _stockController.text = widget.initialStock?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(
          widget.initialName == null ? 'Add New Menu' : 'Edit Menu',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildCategoryOption(
                      'Makanan', Icons.fastfood, const Color(0xFFF5D4C1)),
                  const SizedBox(width: 16),
                  _buildCategoryOption(
                      'Minuman', Icons.local_drink, const Color(0xFFFDEBC8)),
                  const SizedBox(width: 16),
                  _buildCategoryOption('Snack', Icons.cake, const Color(0xFFD0F1EB)),
                ],
              ),
              if (_selectedCategory == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select a category',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              CustomInputField(
                controller: _nameController,
                label: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter menu name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _descController,
                label: 'Description',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter menu description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _priceController,
                label: 'Price',
                isPriceField: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  final price = int.parse(value.replaceAll('.', ''));
                  if (price <= 0) return 'Please enter valid price';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _stockController,
                label: 'Stock',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock amount';
                  }
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) {
                    return 'Please enter valid stock amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9F1C),
                  ),
                  child: Text(
                    widget.initialName == null ? 'Add Menu' : 'Save Changes',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(String category, IconData icon, Color color) {
    final isSelected = _selectedCategory == category;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: const Color(0xFFFF9F1C), width: 2)
                : null,
          ),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(category),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text,
        _selectedCategory!,
        _descController.text,
        double.parse(_priceController.text),
        int.parse(_stockController.text),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}