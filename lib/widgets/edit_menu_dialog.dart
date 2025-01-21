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
      title: const Text('Edit Menu'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nama'),
              controller: TextEditingController(text: name),
              onChanged: (value) => name = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              controller: TextEditingController(text: description),
              onChanged: (value) => description = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: price.toString()),
              onChanged: (value) => price = double.tryParse(value) ?? price,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Stok'),
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
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            onSave(name, description, price, stock);
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
