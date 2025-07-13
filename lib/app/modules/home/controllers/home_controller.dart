import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/models/hotel_models.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/providers/firebase_provider.dart';

class HomeController extends GetxController {
  final ApiProvider apiProvider = ApiProvider();
  final FirebaseProvider firebaseProvider = FirebaseProvider();

  var isLoading = false.obs;
  var hotelList = <Hotel>[].obs;
  var pickedImage = Rx<XFile?>(null);
  var currentPosition = Rx<Position?>(null);

  final nameC = TextEditingController();
  final addressC = TextEditingController();
  final descriptionC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchHotels();
  }

  @override
  void onClose() {
    nameC.dispose();
    addressC.dispose();
    descriptionC.dispose();
    super.onClose();
  }

  // --- LOGIKA CRUD LENGKAP ---

  /// R - READ
  void fetchHotels() async {
    try {
      isLoading(true);
      hotelList.value = await apiProvider.getHotels();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data hotel: $e');
    } finally {
      isLoading(false);
    }
  }

  /// C - CREATE
  void createHotel() async {
    if (nameC.text.isEmpty || addressC.text.isEmpty || pickedImage.value == null || currentPosition.value == null) {
      Get.snackbar('Input Tidak Lengkap', 'Nama, Alamat, Gambar, dan Lokasi wajib diisi.');
      return;
    }
    try {
      isLoading(true);
      String? imageUrl = await firebaseProvider.uploadImage(pickedImage.value!, nameC.text);
      if (imageUrl == null) throw Exception("Gagal mengunggah gambar.");
      
      bool success = await apiProvider.addHotel(
        name: nameC.text,
        address: addressC.text,
        description: descriptionC.text,
        imageUrl: imageUrl,
        latitude: currentPosition.value!.latitude,
        longitude: currentPosition.value!.longitude,
      );

      if (success) {
        Get.back();
        fetchHotels();
        Get.snackbar('Sukses', 'Hotel berhasil ditambahkan.');
      } else {
        Get.snackbar('Error', 'Gagal menyimpan data hotel ke database.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
      clearForm();
    }
  }

  /// D - DELETE
  void deleteHotel(int id) async {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      middleText: "Anda yakin ingin menghapus hotel ini?",
      textConfirm: "Ya, Hapus",
      onConfirm: () async {
        Get.back();
        try {
          isLoading(true);
          bool success = await apiProvider.deleteHotel(id);
          if (success) {
            hotelList.removeWhere((hotel) => hotel.id == id);
            Get.snackbar('Sukses', 'Hotel berhasil dihapus.');
          } else {
            Get.snackbar('Error', 'Gagal menghapus hotel di server.');
          }
        } catch (e) {
          Get.snackbar('Error', 'Terjadi kesalahan saat menghapus: $e');
        } finally {
          isLoading(false);
        }
      }
    );
  }
  
  // --- FUNGSI BANTUAN ---

  void pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = image;
    }
  }

  void pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      pickedImage.value = image;
    }
  }

  /// Mengambil lokasi GPS saat ini dengan penanganan izin lengkap
  void getCurrentLocation() async {
    try {
      isLoading(true);

      // <-- 1. CEK APAKAH LAYANAN LOKASI (GPS) AKTIF -->
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Error", "Layanan lokasi (GPS) tidak aktif di perangkat Anda.");
        return; // Hentikan fungsi jika GPS mati
      }

      // <-- 2. CEK & MINTA IZIN LOKASI DARI PENGGUNA -->
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Izin Ditolak", "Anda menolak izin untuk mengakses lokasi.");
          return;
        }
      }
      
      // <-- 3. TANGANI JIKA IZIN DITOLAK PERMANEN -->
      if (permission == LocationPermission.deniedForever) {
        Get.defaultDialog(
          title: "Izin Dibutuhkan",
          middleText: "Anda telah menolak izin lokasi secara permanen. Harap aktifkan secara manual di pengaturan aplikasi.",
          textConfirm: "Buka Pengaturan",
          onConfirm: () async => await Geolocator.openAppSettings(),
        );
        return;
      } 

      // <-- 4. JIKA SEMUA AMAN, AMBIL POSISI SAAT INI -->
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      Get.snackbar("Lokasi", "Lokasi saat ini berhasil didapatkan.");

    } catch(e) {
       Get.snackbar("Error", "Gagal mendapatkan lokasi: $e");
    } finally {
      isLoading(false);
    }
  }

  void clearForm() {
    nameC.clear();
    addressC.clear();
    descriptionC.clear();
    pickedImage.value = null;
    currentPosition.value = null;
  }
}