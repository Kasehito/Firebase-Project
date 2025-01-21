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
      // Upload image ke Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      var lastDoc = await _firestore
          .collection('menu')
          .orderBy('id', descending: true)
          .limit(1)
          .get();
      int newId = 1;
      if (lastDoc.docs.isNotEmpty) {
        var lastMenu = MenuModel.fromJson(
            lastDoc.docs.first.data() as Map<String, dynamic>);
        newId = int.parse(lastMenu.id!) + 1; // Menambahkan 1 ke ID terakhir
      }

      // Simpan data ke Firestore
      DocumentReference docRef = await _firestore.collection('menu').add({
        'id': newId.toString(),
        'nama': menu.nama,
        'kategori': menu.kategori,
        'deskripsi': menu.deskripsi,
        'harga': menu.harga,
        'stok': menu.stok,
        'createdAt': DateTime.now(),
      });
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

      await _firestore.collection('menu').doc(menu.id).update(data);
    } catch (e) {
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
