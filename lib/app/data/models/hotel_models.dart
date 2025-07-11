import 'dart:convert';

List<Hotel> hotelFromJson(String str) => List<Hotel>.from(json.decode(str).map((x) => Hotel.fromJson(x)));

String hotelToJson(Hotel data) => json.encode(data.toJson());

class Hotel {
    final int id;
    final String name;
    final String address;
    final String? description;
    final String imageUrl;
    final double latitude;
    final double longitude;
    final DateTime? createdAt;

    Hotel({
        required this.id,
        required this.name,
        required this.address,
        this.description,
        required this.imageUrl,
        required this.latitude,
        required this.longitude,
        this.createdAt,
    });

    factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        id: int.parse(json["id"].toString()), 
        name: json["name"],
        address: json["address"],
        description: json["description"],
        imageUrl: json["image_url"],
        latitude: double.parse(json["latitude"].toString()),
        longitude: double.parse(json["longitude"].toString()),
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "description": description,
        "image_url": imageUrl,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
    };
}