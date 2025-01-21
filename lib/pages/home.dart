import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:manganjawa/pages/pages_models/menu_model.dart';
import 'package:manganjawa/pages/pages_controller/menu_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TableMenuController menuController = Get.put(TableMenuController());
  final ImagePicker _picker = ImagePicker();

  Future<void> _showAddMenuDialog() async {
    String? kategori;
    String nama = '';
    String deskripsi = '';
    double harga = 0;
    int stok = 0;
    File? imageFile;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Kategori'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                kategori = 'Makanan';
                Navigator.pop(context);
              },
              child: const Text('Makanan'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                kategori = 'Minuman';
                Navigator.pop(context);
              },
              child: const Text('Minuman'),
            ),
          ],
        ),
      ),
    );

    if (kategori != null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Tambah $kategori Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Nama'),
                  onChanged: (value) => nama = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  onChanged: (value) => deskripsi = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => harga = double.tryParse(value) ?? 0,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Stok'),
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
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                {
                  await menuController.addMenu(
                    nama,
                    kategori!,
                    deskripsi,
                    harga,
                    stok,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      );
    }
  }
  void _showEditMenuDialog(MenuModel menu) async {
  String nama = menu.nama;
  String deskripsi = menu.deskripsi;
  double harga = menu.harga;
  int stok = menu.stok;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit ${menu.kategori}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nama'),
              controller: TextEditingController(text: nama),
              onChanged: (value) => nama = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              controller: TextEditingController(text: deskripsi),
              onChanged: (value) => deskripsi = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: harga.toString()),
              onChanged: (value) => harga = double.tryParse(value) ?? harga,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: stok.toString()),
              onChanged: (value) => stok = int.tryParse(value) ?? stok,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            await menuController.updateMenu(
              menu.id!,
              nama,
              menu.kategori,
              deskripsi,
              harga,
              stok,
            );
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMenuDialog,
          ),
        ],
      ),
      body: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Nama')),
              DataColumn(label: Text('Kategori')),
              DataColumn(label: Text('Deskripsi')),
              DataColumn(label: Text('Harga')),
              DataColumn(label: Text('Stok')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: menuController.menuList.map((menu) {
              return DataRow(
                cells: [
                  DataCell(Text(menu.nama)),
                  DataCell(Text(menu.kategori)),
                  DataCell(Text(menu.deskripsi)),
                  DataCell(Text('Rp ${menu.harga}')),
                  DataCell(Text('${menu.stok}')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditMenuDialog(menu);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            menuController.deleteMenu(menu.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
