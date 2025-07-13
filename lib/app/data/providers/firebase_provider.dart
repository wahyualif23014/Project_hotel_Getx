// lib/app/data/providers/firebase_provider.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- 1. IMPORT PACKAGE FIRESTORE

class FirebaseProvider {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // <-- 2. INISIALISASI FIRESTORE

  Future<String?> uploadImage(XFile imageFile, String hotelName) async {
    try {
      final fileName = '${hotelName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child('hotels/$fileName');
      File file = File(imageFile.path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Upload berhasil. URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error saat upload gambar: $e');
      return null;
    }
  }

  // --- FUNGSI BARU UNTUK CLOUD FIRESTORE ---

  Future<void> addHotelToFirestore(Map<String, dynamic> hotelData) async {
    try {
      await _firestore.collection('hotel').add(hotelData);
      print("Data berhasil disimpan ke Firestore.");
    } catch (e) {
      print("ERROR: Gagal menyimpan data ke Firestore: $e");
      // Melemparkan exception akan menghentikan alur, 
      // jadi kita hanya print error agar proses lain tetap berjalan.
    }
  }

  /// READ: Mengambil semua dokumen dari koleksi 'hotel1' di Firestore
  Future<List<Map<String, dynamic>>> getHotelsFromFirestore() async {
    try {
      // Mengambil data dari koleksi 'hotel', diurutkan berdasarkan waktu pembuatan
      QuerySnapshot snapshot = await _firestore
          .collection('hotel')
          .orderBy('createdAt', descending: true)
          .get();
      
      // Mengubah setiap dokumen menjadi Map dan menambahkannya ke list
      final hotelList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['firestore_id'] = doc.id; // Menyimpan ID unik dari Firestore
        return data;
      }).toList();

      return hotelList;
    } catch (e) {
      print("ERROR: Gagal membaca data dari Firestore: $e");
      return []; // Mengembalikan list kosong jika terjadi error
    }
  }
}