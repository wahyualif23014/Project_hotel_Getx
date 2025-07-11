// lib/app/shared/constants/api_constants.dart

class ApiConstants {
  // Ganti IP address di bawah ini dengan IP address lokal komputer Anda
  // atau domain server Anda jika sudah di-hosting.
  //
  // Cara menemukan IP Lokal (Windows): Buka CMD -> ketik 'ipconfig' -> cari 'IPv4 Address'.
  // Cara menemukan IP Lokal (macOS): Buka Terminal -> ketik 'ifconfig' -> cari 'inet' di bagian en0/en1.
  //
  // Pastikan HP dan Komputer Anda terhubung ke jaringan WiFi yang sama.
  // JANGAN GUNAKAN 'localhost' atau '127.0.0.1' karena HP tidak akan mengenali itu.

  static const String baseUrl = "http://192.168.1.36/apiAGata"; // <== GANTI INI
  static const String hotelsUrl = "$baseUrl/read.php";
  static const String addHotelUrl = "$baseUrl/create.php";
  static const String updateHotelUrl = "$baseUrl/update.php";
  static const String deleteHotelUrl = "$baseUrl/delete.php";
}