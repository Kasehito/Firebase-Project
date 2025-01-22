import 'package:flutter/material.dart';

class AddMenuDialog extends StatelessWidget {
  final Function(String, String, String, double, int) onAdd;

  const AddMenuDialog({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? kategori;
    String nama = '';
    String deskripsi = '';
    double harga = 0;
    int stok = 0;

    return AlertDialog(
      title: const Text('Pilih Kategori',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Container(
        width: 343,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCategoryButton(
              context,
              'Makanan',
              Icons.fastfood,
              Color(0xFFF5D4C1),
            ),
            const SizedBox(width: 16),
            _buildCategoryButton(
              context,
              'Minuman',
              Icons.local_drink,
              Color(0xFFFDEBC8),
            ),
            const SizedBox(width: 16),
            _buildCategoryButton(
              context,
              'Snack',
              Icons.cake,
              Color(0xFFD0F1EB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String label, IconData icon, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          _showDetailDialog(context, label);
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, size: 32),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String kategori) {
    String nama = '';
    String deskripsi = '';
    double harga = 0;
    int stok = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah $kategori Baru',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => nama = value,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => deskripsi = value,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => harga = double.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => stok = int.tryParse(value) ?? 0,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              onAdd(nama, kategori, deskripsi, harga, stok);
              Navigator.pop(context);
            },
            child: const Text('Tambah', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
