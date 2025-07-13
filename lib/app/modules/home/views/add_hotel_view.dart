import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class AddHotelView extends GetView<HomeController> {
  const AddHotelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.clearForm();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Hotel Baru'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              return Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  image: controller.pickedImage.value != null
                      ? DecorationImage(
                          image: FileImage(File(controller.pickedImage.value!.path)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: controller.pickedImage.value == null
                    ? Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                      )
                    : null,
              );
            }),
            SizedBox(height: 16),

            // === 2. Tombol Aksi untuk Gambar & Lokasi ===
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => controller.pickImageFromCamera(),
                  icon: Icon(Icons.photo_camera),
                  label: Text("Kamera"),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.pickImageFromGallery(),
                  icon: Icon(Icons.photo_library),
                  label: Text("Galeri"),
                ),
              ],
            ),
             SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => controller.getCurrentLocation(),
                icon: Icon(Icons.my_location),
                label: Text("Ambil Lokasi GPS Saat Ini"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            // === 3. Area Status & Feedback untuk Pengguna ===
            Obx(() {
              if (controller.currentPosition.value == null) {
                return SizedBox.shrink();
              }
              final pos = controller.currentPosition.value!;
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "✅ Lokasi terdeteksi:\nLat: ${pos.latitude.toStringAsFixed(6)}, Long: ${pos.longitude.toStringAsFixed(6)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green[700]),
                ),
              );
            }),
            SizedBox(height: 24),

            // === 4. Form Input Data ===
            TextField(
              controller: controller.nameC,
              decoration: InputDecoration(labelText: 'Nama Hotel', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.addressC,
              decoration: InputDecoration(labelText: 'Alamat', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.descriptionC,
              decoration: InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
              maxLines: 4,
            ),
            SizedBox(height: 32),

            // === 5. Tombol Simpan (Memanggil createHotel) ===
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                // Tombol akan nonaktif jika sedang loading
                onPressed: controller.isLoading.value ? null : () => controller.createHotel(),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("SIMPAN HOTEL", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}