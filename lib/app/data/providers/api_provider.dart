// lib/app/data/providers/api_provider.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel_models.dart';
import '../../shared/constants/api_constants.dart';

class ApiProvider {

  // READ: Mengambil semua data hotel
  Future<List<Hotel>> getHotels() async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.hotelsUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Hotel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Gagal memuat data dari server');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // CREATE: Menambah hotel baru
  // Menggunakan http.MultipartRequest karena PHP script kita menggunakan $_POST
  // dan ini lebih fleksibel untuk upload file nanti.
  Future<bool> addHotel({
    required String name,
    required String address,
    required String description,
    required String imageUrl,
    required double latitude,
    required double longitude,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.addHotelUrl));
      
      // Menambahkan field ke request
      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['description'] = description;
      request.fields['image_url'] = imageUrl;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Gagal menambahkan hotel: $e');
    }
  }

  // PHP script kita untuk update menerima raw JSON, jadi kita gunakan http.post biasa
  Future<bool> updateHotel(Hotel hotel) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.updateHotelUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(hotel.toJson()), // Mengirim data hotel dalam format JSON
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Gagal memperbarui hotel: $e');
    }
  }

  // DELETE: Menghapus hotel berdasarkan ID
  Future<bool> deleteHotel(int id) async {
    try {
      // Menambahkan ID sebagai query parameter di URL
      final Uri deleteUri = Uri.parse('${ApiConstants.deleteHotelUrl}?id=$id');
      final response = await http.get(deleteUri);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Gagal menghapus hotel: $e');
    }
  }
}