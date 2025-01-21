  import 'package:cloud_firestore/cloud_firestore.dart';

  class MenuModel {
    String? id;
    String nama;
    String kategori;
    String deskripsi;
    double harga;
    int stok;
    DateTime createdAt;

    MenuModel({
      this.id,
      required this.nama,
      required this.kategori,
      required this.deskripsi,
      required this.harga,
      required this.stok,
      required this.createdAt,
    });

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'nama': nama,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'harga': harga,
        'stok': stok,
        'createdAt': createdAt,
      };
    }

    factory MenuModel.fromJson(Map<String, dynamic> json) {
      return MenuModel(
        id: json['id'],
        nama: json['nama'],
        kategori: json['kategori'],
        deskripsi: json['deskripsi'],
        harga: json['harga'].toDouble(),
        stok: json['stok'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
      );
    }
  }
