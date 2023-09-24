import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailFetch {
  final String
      mainCollection; // เพิ่ม field documentId เพื่อใช้เป็น ID ของเอกสาร
  final String docID;
  final String subCollection;

  DetailFetch(
      {required this.mainCollection,
      required this.docID,
      required this.subCollection});
}

class DetailService {
  Future<List<dynamic>> fetchReviewData(
      String mainCollection, String docID, String subCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> reviewDataList = [];

      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;

        String Snapidx = snapID;
        //pull id review
        DocumentSnapshot docFirestoreDoc = await firestore
            .collection(mainCollection)
            .doc(docID)
            .collection(subCollection)
            .doc(Snapidx)
            .get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> reviewData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          reviewDataList.add({
            'ID_Food': reviewData['ID_Food'],
            'ID_Mod': reviewData['ID_Mod'],
            'Comment': reviewData['Comment'],
            'Rating': reviewData['Rating'],
            'Time': reviewData['Time'],
            'Video': reviewData['Video'],
            'Uid' : reviewData['Uid'],
          });
        }
      }
      return reviewDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  Future<List<dynamic>> fetchModifyData(
      String mainCollection, String docID, String subCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> modDataList = [];

      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;

        String Snapidx = snapID;
        //pull id review
        DocumentSnapshot docFirestoreDoc = await firestore
            .collection(mainCollection)
            .doc(docID)
            .collection(subCollection)
            .doc(Snapidx)
            .get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> modData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          modDataList.add({
            'ID_Food': modData['ID_Food'],
            'ID_Mod': modData['ID_Mod'],
            'Comment': modData['Comment'],
            'Time': modData['Time'],
            'Video': modData['Video'],
            'Uid' : modData['Uid'],
          });
        }
      }
      return modDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  Future<List<List<String>>> fetchImagesReview(
      String mainCollection, String docID, String subCollection) async {
    List<List<String>> imageUrlsList = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseStorage storage = FirebaseStorage.instance;
      imageUrlsList = [];

      //ไอดี รีวิว
      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String reviewId = docSnapshot.id;
        List<String> urls = []; // เลื่อนรายการนี้ลงมาที่นี่

        //pack image
        ListResult result = await storage
            .ref()
            .child(mainCollection)
            .child(reviewId)
            .child('Image')
            .listAll();

        //loop add image to list
        for (Reference ref in result.items) {
          String imageURL = await ref.getDownloadURL();
          urls.add(imageURL);
        }

        // ส่วนของการเพิ่ม URLs ลงใน imageUrlsList
        imageUrlsList.add(urls);
      }
      return imageUrlsList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  Future<List<List<String>>> fetchImagesModify(
      String mainCollection, String docID, String subCollection) async {
    List<List<String>> imageUrlsList = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseStorage storage = FirebaseStorage.instance;
      List<String> urls = []; // เลื่อนรายการนี้ลงมาที่นี่

      //ไอดี รีวิว
      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String reviewId = docSnapshot.id;

        // รีเซ็ต urls ในแต่ละรอบ
        urls = [];

        //pack image
        ListResult result = await storage
            .ref()
            .child(mainCollection)
            .child(reviewId)
            .child('Image')
            .listAll();

        //loop add image to list
        for (Reference ref in result.items) {
          String imageURL = await ref.getDownloadURL();
          urls.add(imageURL);
        }

        // ส่วนของการเพิ่ม URLs ลงใน imageUrlsList
        imageUrlsList.add(urls);
      }
      return imageUrlsList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }
}
