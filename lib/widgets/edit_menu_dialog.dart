import 'package:flutter/material.dart';

class EditMenuDialog extends StatelessWidget {
  final String initialName;
  final String initialDescription;
  final double initialPrice;
  final int initialStock;
  final Function(String, String, double, int) onSave;

  const EditMenuDialog({
    Key? key,
    required this.initialName,
    required this.initialDescription,
    required this.initialPrice,
    required this.initialStock,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = initialName;
    String description = initialDescription;
    double price = initialPrice;
    int stock = initialStock;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text(
        'Edit Menu',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: name),
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: description),
              onChanged: (value) => description = value,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: price.toString()),
              onChanged: (value) => price = double.tryParse(value) ?? price,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Stok',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: stock.toString()),
              onChanged: (value) => stock = int.tryParse(value) ?? stock,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            onSave(name, description, price, stock);
            Navigator.pop(context);
          },
          child: const Text(
            'Simpan',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
