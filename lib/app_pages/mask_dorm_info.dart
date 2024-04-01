import 'package:cs342_project/app_pages/page_dorm_info.dart';
import 'package:cs342_project/app_pages/page_dorm_review.dart';
import 'package:cs342_project/constants.dart';
import 'package:cs342_project/models/dorm.dart';
import 'package:flutter/material.dart';

class DormInfoMask extends StatefulWidget {
  final Dorm dorm;

  const DormInfoMask({super.key, required this.dorm});

  @override
  State<DormInfoMask> createState() => _DormInfoMaskState();
}

class _DormInfoMaskState extends State<DormInfoMask> {
  bool _loading = true;

  int _pageIndex = 0;
  late List<Widget> _pageWidgets;

  @override
  void initState() {
    super.initState();
    _pageWidgets = [DormInfoPage(dorm: widget.dorm), DormReviewPage()];
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? const Center(child: Text("Loading...")) : Scaffold(
      appBar: AppBar(
        title: const Text("Dorm Information"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),

      body: _pageWidgets[_pageIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        selectedItemColor: AppPalette.darkGreen,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Information"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Reviews")
        ],

        onTap: (index) => setState( () => _pageIndex = index )
      )
    );
  }
}