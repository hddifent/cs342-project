import "package:cloud_firestore/cloud_firestore.dart";

class Dorm {
  final String dormName;
  final String dormDescription;
  final GeoPoint geoLocation;
  final String location;
  final double monthlyPrice;
  final Map<String, dynamic> contactInfo;

  const Dorm({
    required this.dormName,
    required this.dormDescription,
    required this.geoLocation,
    required this.location,
    required this.monthlyPrice,
    required this.contactInfo
  });

  factory Dorm.fromFirestore(Map<String, dynamic> map) {
    return Dorm(
      dormName: map["name"],
      dormDescription: map["description"],
      geoLocation: map["geoLocation"],
      location: map["location"],
      monthlyPrice: map["monthlyPrice"],
      contactInfo: map["contactInfo"]
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": dormName,
      "description": dormDescription,
      "geoLocation": geoLocation,
      "location": location,
      "monthlyPrice": monthlyPrice,
      "contactInfo": contactInfo
    };
  }
}