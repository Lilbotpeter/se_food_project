import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io';

class Foodservice extends GetxController {
  late String foodid;

  Foodservice({required this.foodid});

  Future<List<String>> fetchFoodImaage(String foodid) async {
    List<String> imageUrls = [];

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage
          .ref()
          .child('files')
          .child(foodid)
          .child('Image')
          .listAll();

      try {
        ListResult result = await storage
            .ref()
            .child('files')
            .child(foodid)
            .child('Image')
            .listAll();

        List<String> urls = [];
        for (Reference ref in result.items) {
          String imageURL = await ref.getDownloadURL();
          urls.add(imageURL);
        }
        imageUrls = urls;
      } catch (e) {
        print("Error fetching images: $e");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }

    return imageUrls;
  }
}
