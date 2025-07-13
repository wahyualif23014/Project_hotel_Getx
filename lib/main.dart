// 1. TAMBAHKAN IMPORT INI
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:agaproject/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan GetMaterialApp, bukan MaterialApp
    return GetMaterialApp(
      title: "Aplikasi Perhotelan",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.pages.first.name,
      getPages: AppPages.pages,
    );
  }
}