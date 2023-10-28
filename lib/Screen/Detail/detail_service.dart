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
            'ID_Review': reviewData['ID_Review'],
            'Comment': reviewData['Comment'],
            'Rating': reviewData['Rating'],
            'Time': reviewData['Time'],
            'Video': reviewData['Video'],
            'Uid': reviewData['Uid'],
          });
        }
      }
      return reviewDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  Future<List<dynamic>> fetchCommentData(
      String mainCollection, String docID, String subCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> commentDataList = [];

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
          Map<String, dynamic> commentData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          commentDataList.add({
            'ID_Food': commentData['ID_Food'],
            'ID_Comment': commentData['ID_Comment'],
            'Comment': commentData['Comment'],
            'Time': commentData['Time'],
            'Uid': commentData['Uid'],
          });
        }
      }
      return commentDataList;
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
            'Uid': modData['Uid'],
          });
        }
      }
      return modDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  Future<List<dynamic>> CountReviewData(
      String mainCollection, String docID, String subCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> reviewDataList = [];
      List<dynamic> reviewCount = [];
      String count;
      String Iid;

      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;

        String Snapidx = snapID;
        //pull id review
        QuerySnapshot docFirestoreDoc = await firestore
            .collection('ReplyReview')
            .doc(docSnapshot.id)
            .collection('ReplyReviewID')
            .get();

        for (QueryDocumentSnapshot docSnapshot2 in docFirestoreDoc.docs) {
          count = docSnapshot2.id;
          reviewCount.add(count);

          reviewDataList.add({
            'ID_ReplyReview': docSnapshot2['ID_ReplyReview'],
            'ID_Review': docSnapshot2['ID_Review'],
            'Comment': docSnapshot2['Comment'],
            'Time': docSnapshot2['Time'],
            'Uid': docSnapshot2['Uid'],
          });
        }
      }
      return reviewDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  //-----------------------------------------------------------------
  Future<List<dynamic>> CountModData(
      String mainCollection, String docID, String subCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> reviewDataList = [];
      List<dynamic> reviewCount = [];
      String count;
      String Iid;

      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;

        String Snapidx = snapID;
        //pull id review
        QuerySnapshot docFirestoreDoc = await firestore
            .collection('ReplyMod')
            .doc(docSnapshot.id)
            .collection('ReplyModID')
            .get();

        for (QueryDocumentSnapshot docSnapshot2 in docFirestoreDoc.docs) {
          count = docSnapshot2.id;
          reviewCount.add(count);

          reviewDataList.add({
            'ID_ReplyMod': docSnapshot2['ID_ReplyMod'],
            'ID_Mod': docSnapshot2['ID_Mod'],
            'Comment': docSnapshot2['Comment'],
            'Time': docSnapshot2['Time'],
            'Uid': docSnapshot2['Uid'],
          });
        }
      }
      return reviewDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  //-----------------------------------------------------------------
  Future<List<dynamic>> CountCommentData(
      String mainCollection, String docID, String subCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> reviewDataList = [];
      List<dynamic> reviewCount = [];
      String count;
      String Iid;

      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;

        String Snapidx = snapID;
        //pull id review
        QuerySnapshot docFirestoreDoc = await firestore
            .collection('ReplyComment')
            .doc(docSnapshot.id)
            .collection('ReplyCommentID')
            .get();

        for (QueryDocumentSnapshot docSnapshot2 in docFirestoreDoc.docs) {
          count = docSnapshot2.id;
          reviewCount.add(count);

          reviewDataList.add({
            'ID_ReplyComment': docSnapshot2['ID_ReplyComment'],
            'ID_Comment': docSnapshot2['ID_Comment'],
            'Comment': docSnapshot2['Comment'],
            'Time': docSnapshot2['Time'],
            'Uid': docSnapshot2['Uid'],
          });
        }
      }
      return reviewDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  // Future<List<List<String>>> fetchImagesReview(
  //     String mainCollection, String docID, String subCollection) async {
  //   List<List<String>> imageUrlsList = [];
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     imageUrlsList = [];

  //     //ไอดี รีวิว
  //     QuerySnapshot querySnapshot = await firestore
  //         .collection(mainCollection)
  //         .doc(docID)
  //         .collection(subCollection)
  //         .get();

  //     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //       String reviewId = docSnapshot.id;
  //       List<String> urls = []; // เลื่อนรายการนี้ลงมาที่นี่

  //       //pack image
  //       ListResult result = await storage
  //           .ref()
  //           .child(mainCollection)
  //           .child(reviewId)
  //           .child('Image')
  //           .listAll();

  //       //loop add image to list
  //       for (Reference ref in result.items) {
  //         String imageURL = await ref.getDownloadURL();
  //         urls.add(imageURL);
  //       }

  //       // ส่วนของการเพิ่ม URLs ลงใน imageUrlsList
  //       imageUrlsList.add(urls);
  //     }
  //     return imageUrlsList;
  //   } catch (e) {
  //     print("Error fetching images: $e");
  //     throw e;
  //   }
  // }
  Future<List<List<String>>> fetchImagesReview(
      String mainCollection, String docID, String subCollection) async {
    List<List<String>> imageAndVideoUrlsList = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseStorage storage = FirebaseStorage.instance;
      imageAndVideoUrlsList = [];

      QuerySnapshot querySnapshot = await firestore
          .collection(mainCollection)
          .doc(docID)
          .collection(subCollection)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String reviewId = docSnapshot.id;
        List<String> imageUrls = [];
        List<String> videoUrls = [];

        // Image URLs
        ListResult imageResult = await storage
            .ref()
            .child(mainCollection)
            .child(reviewId)
            .child('Image')
            .listAll();

        for (Reference ref in imageResult.items) {
          String imageURL = await ref.getDownloadURL();
          imageUrls.add(imageURL);
        }

        // Video URLs
        ListResult videoResult = await storage
            .ref()
            .child(mainCollection)
            .child(reviewId)
            .child('Video')
            .listAll();

        for (Reference ref in videoResult.items) {
          String videoURL = await ref.getDownloadURL();
          videoUrls.add(videoURL);
        }

        // Combine URLs of images and videos
        imageAndVideoUrlsList.add([...imageUrls, ...videoUrls]);
      }

      return imageAndVideoUrlsList;
    } catch (e) {
      print("Error fetching images and videos: $e");
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

//  Future<List<String>> fetchImagesModify(
//     String mainCollection, String docID, String subCollection) async {
//   List<String> imageAndVideoUrlsList = [];
//   try {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     FirebaseStorage storage = FirebaseStorage.instance;

//     QuerySnapshot querySnapshot = await firestore
//         .collection(mainCollection)
//         .doc(docID)
//         .collection(subCollection)
//         .get();

//     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
//       String reviewId = docSnapshot.id;

//       // URLs of images and videos
//       List<String> urls = [];

//       // Image URLs
//       ListResult imageResult = await storage
//           .ref()
//           .child(mainCollection)
//           .child(reviewId)
//           .child('Image')
//           .listAll();

//       for (Reference ref in imageResult.items) {
//         String imageURL = await ref.getDownloadURL();
//         urls.add(imageURL);
//       }

//       // Video URLs
//       ListResult videoResult = await storage
//           .ref()
//           .child(mainCollection)
//           .child(reviewId)
//           .child('Video')
//           .listAll();

//       for (Reference ref in videoResult.items) {
//         String videoURL = await ref.getDownloadURL();
//         urls.add(videoURL);
//       }

//       // Add URLs of images and videos to the list
//       imageAndVideoUrlsList.addAll(urls);
//     }

//     return imageAndVideoUrlsList;
//   } catch (e) {
//     print("Error fetching images and videos: $e");
//     throw e;
//   }
// }

  Future<List<dynamic>> fetchReplyModifyData(
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
            'ID_ReplyMod': modData['ID_ReplyMod'],
            'ID_Mod': modData['ID_Mod'],
            'Comment': modData['Comment'],
            'Time': modData['Time'],
            'Uid': modData['Uid'],
          });
        }
      }
      return modDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }
}
