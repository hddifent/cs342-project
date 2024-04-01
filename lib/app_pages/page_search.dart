import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:cs342_project/constants.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/models/dorm.dart";
import "package:cs342_project/utils/geolocator_locate.dart";
import "package:cs342_project/widgets/dorm_card.dart";
import "package:cs342_project/widgets/text_field_icon.dart";
import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

import "../widgets/category_button.dart";

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;
  LatLng _userLocation = const LatLng(0, 0);

  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  int sortType = 0;
  List<String> categories = ['A - Z', 'Nearest', 'Rating', 'Price'];

  @override
  Widget build(BuildContext context) {
    return _loading ? const Center(child: Text("Loading Data...")) : Padding(
      padding: const EdgeInsets.all(10),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _categoryTabBar()
          ),

          _dormList(sortType, _searchTerm)
        ]
      )
    );
  }

  Widget _categoryTabBar() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (sortType != index) {
                setState(() => sortType = index);
              }
            },
            child: CategoryButton(
              category: categories[index],
              backgroundColor: sortType == index ? AppPalette.green : Colors.white,
            )
          );
        },
        itemCount: categories.length,
      )
    );
  }

  Widget _dormList(int sortType, String search) {
    FirestoreDatabase db = FirestoreDatabase("dorms");
    return StreamBuilder<QuerySnapshot>(
      stream: db.getStream("name"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Object?>> dormDocList = snapshot.data?.docs ?? [];
          List<Dorm> dormList = [];
          List<Widget> dormCardList = [];

          // Get dorm from DB
          for (QueryDocumentSnapshot<Object?> doc in dormDocList) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            Dorm dorm = Dorm.fromFirestore(doc.id, data);

            if (
              search.isEmpty ||
              dorm.dormName.toLowerCase().contains(search.toLowerCase()) ||
              dorm.location.toLowerCase().contains(search.toLowerCase())
            ) {
              dormList.add(dorm);
            }
          }

          // Sort
          if (sortType == 0) {
            dormList.sort((a, b) => a.dormName.compareTo(b.dormName));
          }
          else if (sortType == 1) {
            Map<int, double> distanceIndexMap = { };
            Point userPoint = Point(_userLocation.latitude, _userLocation.longitude);

            for (int i = 0; i < dormList.length; i++) {
              Dorm d = dormList[i];
              Point dormPoint = Point(d.geoLocation.latitude, d.geoLocation.longitude);
              distanceIndexMap.addAll({i: userPoint.distanceTo(dormPoint)});
            }

            List<MapEntry<int, double>> sortedEntries = distanceIndexMap.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
            distanceIndexMap..clear()..addEntries(sortedEntries);
            List<Dorm> sorted = [];

            for (int i = 0; i < distanceIndexMap.length; i++) {
              sorted.add(dormList[distanceIndexMap.keys.toList()[i]]);
            }

            dormList = List.from(sorted);
          }
          else if (sortType == 3) {
            dormList.sort((a, b) => a.monthlyPrice.compareTo(b.monthlyPrice));
          }
          else {
            dormList.sort((a, b) => a.dormName.compareTo(b.dormName));
          }

          // Add DormCard
          for (Dorm d in dormList) {
            dormCardList.add(DormCard(dorm: d));
          }

          return Expanded(
            child: SingleChildScrollView(
              child: Column(children: dormCardList)
            ),
          );
        }
        else {
          return const Text("No Dorm in database...");
        }
      }
    );
  }

  void _getUserLocation() async {
    LatLng uLoc = await UserLocator.getUserLocation();
    if (!mounted) { return; }
    setState(() {
      _userLocation = uLoc;
      _loading = false;
    });
  }
}
