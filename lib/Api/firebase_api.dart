import 'dart:io';
import 'dart:typed_data';

//Firebase import
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    //Upload Picture
    try {
      final dbRef = FirebaseStorage.instance.ref(destination);

      return dbRef.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    //Upload mp4,mp3
    try {
      final dbRef = FirebaseStorage.instance.ref(destination);

      return dbRef.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
