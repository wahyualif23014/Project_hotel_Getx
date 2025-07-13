import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Hotel'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearForm();
          Get.toNamed(Routes.ADD_HOTEL);
        },
        child: Icon(Icons.add),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.hotelList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.hotelList.isEmpty) {
            return Center(
              child: Text(
                "Belum ada data hotel.\nTekan tombol + untuk menambah.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }

          // Tampilkan list jika data sudah ada
          return RefreshIndicator(
            onRefresh: () async => controller.fetchHotels(),
            child: ListView.builder(
              itemCount: controller.hotelList.length,
              itemBuilder: (context, index) {
                final hotel = controller.hotelList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias, 
                  child: InkWell( 
                    onTap: () {
                      Get.snackbar("Info", "Anda menekan hotel: ${hotel.name}");
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: ClipRRect( // Membuat gambar memiliki sudut melengkung
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: hotel.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(
                                width: 80, height: 80,
                                color: Colors.grey[200],
                                child: Center(child: CircularProgressIndicator()),
                              ),
                          errorWidget: (context, url, error) =>
                              Container(
                                width: 80, height: 80,
                                color: Colors.grey[200],
                                child: Icon(Icons.broken_image, color: Colors.grey),
                              ),
                        ),
                      ),
                      title: Text(
                        hotel.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          hotel.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                        onPressed: () {
                          // Fungsi dialog konfirmasi Anda sudah benar
                          controller.deleteHotel(hotel.id);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}