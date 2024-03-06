import "package:cs342_project/models/dorm.dart";
import "package:cs342_project/widgets/dorm_card.dart";
import "package:flutter/material.dart";

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const SearchBar(
              leading: Icon(Icons.search),
              hintText: "Search Dorm..."
            ),
          ),
          
          const SizedBox(height: 10),

          const DormCard(
            dorm: Dorm(dormName: "KU Home", dormDescription: "Right there, inside the university. You can't get any better than this."),
          )
        ]
      ),
    );
  }
}
