import 'dart:async';
import 'dart:io';
import 'package:cs342_project/app_pages/mask_main.dart';
import 'package:cs342_project/app_pages/page_edit_profile.dart';
import 'package:cs342_project/constants.dart';
import '../global.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  final List<CameraDescription>? camera = cameras;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRearCameraSelected = true;

  Future initCamera() async {
    _controller = CameraController(
      camera![_isRearCameraSelected ? 0 : 1],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    } 
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      _controller.setFlashMode(FlashMode.off);
      XFile image = await _controller.takePicture();
      setState(() {
        profileImage = FileImage(File(image.path));
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const MainMask())
        );
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const EditProfilePage())
        );
      });
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take A Profile Picture'),
        backgroundColor: AppPalette.green,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(color: Colors.black),
                Center(
                  widthFactor: MediaQuery.of(context).size.width,
                  child: CameraPreview(_controller),
                ),
                _bottomButtons()
              ]
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _bottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          color: Colors.black
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _switchRearButton(),
            _takePictureButton()
          ],
        )
      ),
    );
  }

  Widget _switchRearButton() {
    return Expanded(
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 30,
        icon: Icon(
          _isRearCameraSelected ?
          Icons.cameraswitch : Icons.cameraswitch_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() => _isRearCameraSelected = !_isRearCameraSelected);
          initCamera();
        },
      )
    );
  }

  Widget _takePictureButton() {
    return Expanded(
      child: IconButton(
        icon: const Icon(Icons.circle),
        onPressed: takePicture,
        iconSize: 50,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      )
    );
  }

}