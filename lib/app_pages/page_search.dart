import "package:cs342_project/constants.dart";
import "package:cs342_project/models/dorm.dart";
import "package:cs342_project/widgets/dorm_card.dart";
import "package:flutter/material.dart";

import "../widgets/category_button.dart";

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  int current = 0;

  List<String> categorys = ['A - Z', 'Nearest', 'Rating', 'Price'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: "Search Dorm...",
              controller: _searchController,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: _categoryTabBar(),
          ),

          _dormList()
        ]
      ),
    );
  }

  Widget _categoryTabBar() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        itemBuilder: (context, index) => 
          GestureDetector(
            onTap: () async {
              if (current != index) {
                setState(() {
                  current = index;
                });
              }
            },
            child: CategoryButton(
              category: categorys[index],
              backgroundColor: current == index ? AppPalette.green : Colors.white,
            ),
          ),
        itemCount: categorys.length,
      ),
    );
  }

  Widget _dormList() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const DormCard(
            dorm: Dorm(dormName: "KU Home", dormDescription: "Right there, inside the university. You can't get any better than this."),
          )
        ],
      )
    );
  }
}
