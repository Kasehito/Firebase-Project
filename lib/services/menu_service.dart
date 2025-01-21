import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manganjawa/pages/pages_models/menu_model.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create
  Future<void> addMenu(MenuModel menu) async {
    try {
      // Tetapkan ID dokumen secara manual
      String newId = DateTime.now().millisecondsSinceEpoch.toString();

      // Simpan data ke Firestore dengan ID yang ditentukan
      await _firestore.collection('menu').doc(newId).set({
        'id': newId,
        'nama': menu.nama,
        'kategori': menu.kategori,
        'deskripsi': menu.deskripsi,
        'harga': menu.harga,
        'stok': menu.stok,
        'createdAt': DateTime.now(),
      });

      // Update ID di model
      menu.id = newId;
    } catch (e) {
      rethrow;
    }
  }

  // Read
  Stream<List<MenuModel>> getMenus() {
    return _firestore
        .collection('menu')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Update
  Future<void> updateMenu(MenuModel menu) async {
    try {
      Map<String, dynamic> data = menu.toJson();

      // Tambahkan log untuk memeriksa ID
      print('Updating document with ID: ${menu.id}');

      // Gunakan metode set dengan merge: true
      await _firestore
          .collection('menu')
          .doc(menu.id)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating document: $e');
      rethrow;
    }
  }

  // Delete
  Future<void> deleteMenu(String id) async {
    try {
      // Hapus image dari Storage
      // Hapus data dari Firestore
      await _firestore.collection('menu').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
