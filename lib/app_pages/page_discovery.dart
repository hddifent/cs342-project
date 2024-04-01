import "package:cloud_firestore/cloud_firestore.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/models/dorm.dart";
import "package:cs342_project/utils/geolocator_locate.dart";
import "package:cs342_project/widgets/dorm_card.dart";
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
  Set<Marker> _dormMarkers = { };

  final TextEditingController _searchController = TextEditingController();

  Dorm? selectedDorm;

  @override
  void initState() {
    super.initState();
    _getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loading ? const Text("Loading Map...") : Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              zoom: 12.5
            ),
            markers: _dormMarkers,
          ),

          selectedDorm == null ? const SizedBox(width: 0, height: 0) : Align(alignment: Alignment.bottomCenter, child: DormCard(dorm: selectedDorm!)),

          Padding(
            padding: const EdgeInsets.all(10),
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: "Search Dorm...",
              controller: _searchController
            )
          )
        ]
      )
    );
  }

  void _getInitData() async {
    await Future.wait([
      UserLocator.getUserLocation().then((value) => _userLocation = value),
      _getMarkersFromDB().then((value) => _dormMarkers = value)
    ]);

    if (!mounted) { return; }
    setState(() => _loading = false);
  }

  Future<Set<Marker>> _getMarkersFromDB() async {
    Set<Marker> markers = { };

    FirestoreDatabase db = FirestoreDatabase("dorms");
    db.collection.get().then((dormCollection) {
      if (dormCollection.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> doc in dormCollection.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Dorm dorm = Dorm.fromFirestore(doc.id, data);

          markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(dorm.geoLocation.latitude, dorm.geoLocation.longitude),
              onTap: () => setState(() {
                selectedDorm = dorm;
              })
            )
          );
        }
      }
    });

    return markers;
  }
}
