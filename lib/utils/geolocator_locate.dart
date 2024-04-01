import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocator {
  static Future<LatLng> getUserLocation() async {
    try {
      Position pos = await _getLocationGeoLocator();
      return LatLng(pos.latitude, pos.longitude);
    }
    catch (e) {
      return const LatLng(0, 0);
    }
  }

  static Future<Position> _getLocationGeoLocator() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) { return Future.error("Location services are disabled."); }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { return Future.error("Location permissions are denied."); }
    }
    else if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition();
  }
}