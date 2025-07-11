// lib/app/data/providers/firebase_provider.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // Dibutuhkan untuk tipe data XFile

class FirebaseProvider {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fungsi untuk upload gambar
  Future<String?> uploadImage(XFile imageFile, String hotelName) async {
    try {
      // Membuat nama file yang unik untuk menghindari tumpukan nama
      final fileName = '${hotelName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Membuat referensi path di Firebase Storage
      // Gambar akan disimpan dalam folder 'hotels/nama_file.jpg'
      Reference ref = _storage.ref().child('hotels/$fileName');

      // Mengambil file dari path lokal
      File file = File(imageFile.path);

      // Mulai proses upload
      UploadTask uploadTask = ref.putFile(file);

      // Menunggu sampai upload selesai
      TaskSnapshot snapshot = await uploadTask;

      // Setelah selesai, dapatkan URL download gambar tersebut
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print('Upload berhasil. URL: $downloadUrl');
      return downloadUrl;
      
    } catch (e) {
      print('Error saat upload gambar: $e');
      return null;
    }
  }
}