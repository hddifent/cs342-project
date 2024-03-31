import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageDatabase {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final String parentPath;

  StorageDatabase(this.parentPath);

  Future<String> _uploadImage(String fileName, Uint8List file) async {
    final Reference reference = storage.ref().child('$parentPath/$fileName.jpg');
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String imageURL = await snapshot.ref.getDownloadURL();
    return imageURL;
  }

  Future<String?> saveImage(String fileName, Uint8List file) async {
    try {
      final imageURL = await _uploadImage(fileName, file);
      return imageURL;
    } on FirebaseException { rethrow; }
  }

}