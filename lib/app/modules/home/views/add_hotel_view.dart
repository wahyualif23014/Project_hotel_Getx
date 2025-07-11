import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class AddHotelView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Hotel Baru'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview Gambar
            GetBuilder<HomeController>(
              builder: (c) {
                return c.pickedImage != null
                    ? Image.file(File(c.pickedImage!.path), height: 200, fit: BoxFit.cover)
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                      );
              },
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => controller.pickImage(),
              icon: Icon(Icons.photo_library),
              label: Text("Pilih Gambar"),
            ),
            SizedBox(height: 20),
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
            // Tombol Simpan
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: controller.isLoading.value ? null : () => controller.addHotel(),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("SIMPAN", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}