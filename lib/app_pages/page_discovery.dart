import "package:cs342_project/utils/geolocator_locate.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  bool _loading = true;
  LatLng _userLocation = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loading ? const Text("Loading Map...") : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _userLocation,
          zoom: 12.5
        )
      )
    );
  }

  void _getUserLocation() async {
    LatLng uLoc = await UserLocator.getUserLocation();
    setState(() {
      _userLocation = uLoc;
      _loading = false;
    });
  }
}
