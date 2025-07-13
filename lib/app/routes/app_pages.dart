// lib/app/routes/app_pages.dart

import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/add_hotel_view.dart';
import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ADD_HOTEL,
      page: () => AddHotelView(),
      binding: HomeBinding(), 
    ),
  ];
}