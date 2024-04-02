import "package:cloud_firestore/cloud_firestore.dart";
import "package:cs342_project/constants.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/models/dorm.dart";
import "package:cs342_project/utils/geolocator_locate.dart";
import "package:cs342_project/widgets/dorm_card.dart";
import "package:cs342_project/widgets/text_field_icon.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
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

  late GoogleMapController _googleMapController;

  String _searchTerm = "";
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
            onMapCreated: (controller) => _googleMapController = controller,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _userLocation,
              zoom: 14
            ),
            markers: _dormMarkers,
          ),

          selectedDorm == null ? const SizedBox(width: 0, height: 0) : Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () => setState(() => selectedDorm = null),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    label: const Text("Hide")
                  ),
                  DormCard(dorm: selectedDorm!)
                ]
              )
            )
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextFieldWithIcon(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchTerm.isEmpty ? null : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchTerm = _searchController.text);
                    }
                  ),
                  prompt: "Search Dorm...",
                  controller: _searchController,
                
                  onChanged: (value) => setState(() => _searchTerm = value),
                ),

                _searchTerm.isEmpty ? const SizedBox(width: 0, height: 0) : const SizedBox(height: 10),

                _searchTerm.isEmpty ? const SizedBox(width: 0, height: 0) : _getMatchedEntries(_searchTerm)
              ]
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
    await db.collection.get().then((dormCollection) {
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

  Widget _getMatchedEntries(String search) {
    FirestoreDatabase db = FirestoreDatabase("dorms");
    return StreamBuilder<QuerySnapshot>(
      stream: db.getStream("name"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Object?>> dormDocList = snapshot.data?.docs ?? [];
          List<Widget> widgetList = [];

          // Get dorm from DB
          for (QueryDocumentSnapshot<Object?> doc in dormDocList) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            Dorm dorm = Dorm.fromFirestore(doc.id, data);

            if (
              search.isEmpty ||
              dorm.dormName.toLowerCase().contains(search.toLowerCase()) ||
              dorm.location.toLowerCase().contains(search.toLowerCase())
            ) {
              widgetList.add(
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
                      LatLng(dorm.geoLocation.latitude, dorm.geoLocation.longitude),
                      14
                    ));
                    setState(() {
                      _searchTerm = _searchController.text;
                      selectedDorm = dorm;
                    });
                  },

                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 160,
                            child: Text(dorm.dormName, style: AppTextStyle.bold, overflow: TextOverflow.ellipsis, maxLines: 2)
                          ),
                          SizedBox(
                            width: 160,
                            child: Text(dorm.location, overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.right)
                          )
                        ]
                      ),
                    )
                  ),
                )
              );
            }
          }

          return SizedBox(
            height: 160,
            child: SingleChildScrollView(
              child: Column(children: widgetList)
            ),
          );
        }
        else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}
