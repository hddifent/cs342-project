import 'package:camera/camera.dart';
import '../app_pages/page_log_in.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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
      home: const LogInPage(),
    );
  }
}
