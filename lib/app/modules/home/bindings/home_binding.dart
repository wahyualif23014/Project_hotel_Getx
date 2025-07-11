// lib/app/modules/home/bindings/home_binding.dart

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan HomeController agar bisa digunakan di HomeView
    // lazyPut berarti controller baru akan dibuat saat benar-benar pertama kali digunakan
    Get.lazyPut<HomeController>(() => HomeController());
  }
}