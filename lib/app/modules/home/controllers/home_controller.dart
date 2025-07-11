// lib/app/modules/home/controllers/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/hotel_models.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/providers/firebase_provider.dart';

class HomeController extends GetxController {
  // Instance dari provider kita
  final ApiProvider apiProvider = ApiProvider();
  final FirebaseProvider firebaseProvider = FirebaseProvider();

  // Variabel untuk menyimpan state aplikasi, .obs membuatnya reaktif
  var isLoading = false.obs;
  var hotelList = <Hotel>[].obs;
  XFile? pickedImage; // Untuk menyimpan file gambar yang dipilih

  // Controller untuk form text field
  late TextEditingController nameC;
  late TextEditingController addressC;
  late TextEditingController descriptionC;

  // Method yang dijalankan saat controller pertama kali dibuat
  @override
  void onInit() {
    super.onInit();
    nameC = TextEditingController();
    addressC = TextEditingController();
    descriptionC = TextEditingController();
    fetchHotels(); // Langsung ambil data hotel saat halaman dibuka
  }

  // Method untuk membersihkan controller saat tidak digunakan
  @override
  void onClose() {
    nameC.dispose();
    addressC.dispose();
    descriptionC.dispose();
    super.onClose();
  }

  // --- LOGIKA CRUD ---

  // R - READ: Mengambil data dari API
  void fetchHotels() async {
    try {
      isLoading(true);
      final hotels = await apiProvider.getHotels();
      hotelList.assignAll(hotels);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data hotel: $e');
    } finally {
      isLoading(false);
    }
  }

  // C - CREATE: Menambah hotel baru
  void addHotel() async {
    if (nameC.text.isEmpty || addressC.text.isEmpty || pickedImage == null) {
      Get.snackbar('Error', 'Nama, Alamat, dan Gambar wajib diisi.');
      return;
    }

    try {
      isLoading(true);
      // 1. Upload gambar ke Firebase
      String? imageUrl = await firebaseProvider.uploadImage(pickedImage!, nameC.text);

      if (imageUrl != null) {
        // 2. Jika upload berhasil, simpan data ke MySQL via PHP API
        bool success = await apiProvider.addHotel(
          name: nameC.text,
          address: addressC.text,
          description: descriptionC.text,
          imageUrl: imageUrl,
          latitude: -6.200000, // Placeholder, ganti dengan lokasi asli
          longitude: 106.816666, // Placeholder, ganti dengan lokasi asli
        );

        if (success) {
          Get.back(); // Kembali ke halaman utama
          fetchHotels(); // Refresh daftar hotel
          Get.snackbar('Sukses', 'Hotel berhasil ditambahkan.');
          clearForm();
        } else {
          Get.snackbar('Error', 'Gagal menyimpan data hotel ke database.');
        }
      } else {
        Get.snackbar('Error', 'Gagal mengunggah gambar.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }
  
  // D - DELETE: Menghapus hotel
  void deleteHotel(int id) async {
    try {
      isLoading(true);
      bool success = await apiProvider.deleteHotel(id);

      if (success) {
        fetchHotels(); // Refresh list setelah hapus
        Get.snackbar('Sukses', 'Hotel berhasil dihapus.');
      } else {
        Get.snackbar('Error', 'Gagal menghapus hotel.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat menghapus: $e');
    } finally {
      isLoading(false);
    }
  }
  
  // --- Fungsi Bantuan ---

  // Memilih gambar dari galeri
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage = image;
        update(); // Memperbarui UI untuk menampilkan preview gambar
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  void clearForm() {
    nameC.clear();
    addressC.clear();
    descriptionC.clear();
    pickedImage = null;
  }
}