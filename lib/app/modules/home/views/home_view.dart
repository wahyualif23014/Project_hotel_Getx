import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Hotel'),
        centerTitle: true,
      ),
      // Tombol untuk pindah ke halaman tambah hotel
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Bersihkan form sebelum pindah halaman
          controller.clearForm();
          Get.toNamed(Routes.ADD_HOTEL);
        },
        child: Icon(Icons.add),
      ),
      body: Obx(
        // Obx akan otomatis rebuild widget di dalamnya jika state isLoading berubah
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async => controller.fetchHotels(),
                child: ListView.builder(
                  itemCount: controller.hotelList.length,
                  itemBuilder: (context, index) {
                    final hotel = controller.hotelList[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: hotel.imageUrl,
                          width: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        title: Text(hotel.name),
                        subtitle: Text(hotel.address),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Tampilkan dialog konfirmasi sebelum menghapus
                            Get.defaultDialog(
                              title: "Konfirmasi Hapus",
                              middleText: "Anda yakin ingin menghapus hotel ${hotel.name}?",
                              onConfirm: () {
                                Get.back(); // Tutup dialog
                                controller.deleteHotel(hotel.id);
                              },
                              onCancel: () {}, // Biarkan kosong untuk tombol batal
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}