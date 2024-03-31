import 'package:cs342_project/app_pages/page_account.dart';
import 'package:cs342_project/app_pages/page_discovery.dart';
import 'package:cs342_project/app_pages/page_search.dart';
import 'package:cs342_project/constants.dart';
import 'package:cs342_project/database/firebase_auth.dart';
import 'package:cs342_project/global.dart';
import 'package:flutter/material.dart';

class MainMask extends StatefulWidget {
  const MainMask({super.key});

  @override
  State<MainMask> createState() => _MainMaskState();
}

class _MainMaskState extends State<MainMask> {
  int pageIndex = 0;
  List<Widget> pageWidgets = const [DiscoveryPage(), SearchPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KU Dorm"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _logOut, 
            icon: const Icon(Icons.exit_to_app)
          )
        ],
      ),

      body: pageWidgets[pageIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        selectedItemColor: AppPalette.darkGreen,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Discovery"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account")
        ],

        onTap: (index) => setState( () => pageIndex = index )
      )
    );
  }

  void _logOut() async {
    if (currentUser != null) { await AuthenticationDatabase.logOutUser(); }
    setState(() { Navigator.pop(context); });
  }

}