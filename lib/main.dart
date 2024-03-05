import 'package:cs342_project/app_page/mask_main.dart';
import 'package:cs342_project/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KU Dorm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.green),
        useMaterial3: true,
      ),
      home: const MainMask(),
    );
  }
}
