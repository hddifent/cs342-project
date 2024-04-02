import 'package:cs342_project/app_pages/page_account.dart';
import 'package:cs342_project/app_pages/page_discovery.dart';
import 'package:cs342_project/app_pages/page_search.dart';
import 'package:cs342_project/constants.dart';
import 'package:cs342_project/database/firebase_auth.dart';
import 'package:cs342_project/global.dart';
import 'package:flutter/material.dart';

class MainMask extends StatefulWidget {
  final int initialIndex;

  const MainMask({super.key, this.initialIndex = 0});

  @override
  State<MainMask> createState() => _MainMaskState();
}

class _MainMaskState extends State<MainMask> {
  late int pageIndex;
  List<Widget> pageWidgets = const [DiscoveryPage(), SearchPage(), AccountPage()];

  bool _isLogOut = true;

  @override
  void initState() {
    super.initState();
    pageIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      
      child: Scaffold(
        appBar: AppBar(
          title: const Text("KU Dorm"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: _logOut, 
              icon: const Icon(Icons.exit_to_app, size: 30),
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
      ),
    );
  }

  void _logOut() async {
    if (currentUser != null) { 
      _isLogOut = false;
      await showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          content: const Text(
            'Do you really want to \nlog out?', 
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            ElevatedButton(
              onPressed: () { 
                _isLogOut = true; 
                Navigator.pop(context);
              },
              child: const Text('Yes')
            ),
            ElevatedButton(
              onPressed: () {
                _isLogOut = false; 
                Navigator.pop(context);
              }, 
              child: const Text('No')
            )
          ],
          actionsAlignment: MainAxisAlignment.center,
        )
      );
      if (_isLogOut) {
        await AuthenticationDatabase.logOutUser(); 
      }
    } 
    if (_isLogOut) { 
      setState(() { 
        Navigator.pop(context); 
      }); 
    }
  }

}