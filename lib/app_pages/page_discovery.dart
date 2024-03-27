import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(13.736717, 100.523186)
        )
      )
    );
  }
}
