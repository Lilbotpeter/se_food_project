import 'package:cloud_firestore/cloud_firestore.dart';

class Calculator {
  final int number;
  final String foodID;
  final String reviewsID;

  Calculator(
      {required this.number, required this.foodID, required this.reviewsID});
}

class CalculatorService {
  Future<List<dynamic>> calRating() async {
    List<dynamic> ID_Food = [];
    CollectionReference collection_ID_Food =
        FirebaseFirestore.instance.collection('Foods');

    QuerySnapshot querySnapshot_ID2 = await collection_ID_Food.get();
    for (QueryDocumentSnapshot doc_fid in querySnapshot_ID2.docs) {
      ID_Food.add(doc_fid.id);
    }

    List<dynamic> documentIds = [];
    List<dynamic> points = [];
    double Allsum = 0.0;

    for (String foodDocId in ID_Food) {
      CollectionReference collection = FirebaseFirestore.instance
          .collection('Review')
          .doc(foodDocId)
          .collection('ReviewID');
      QuerySnapshot querySnapshot_ID = await collection.get();

      double ratingSum = 0.0;
      int reviewCount = 0;

      for (QueryDocumentSnapshot doc in querySnapshot_ID.docs) {
        documentIds.add(doc.id);
        final DocumentReference documentRef = FirebaseFirestore.instance
            .collection("Review")
            .doc(foodDocId)
            .collection('ReviewID')
            .doc(doc.id);

        final DocumentSnapshot snapshot = await documentRef.get();

        if (snapshot.exists) {
          int rating = snapshot['Rating'];
          if (rating is int) {
            points.add(rating);
          }

          // เพิ่มคะแนนไปยังผลรวมคะแนน
          ratingSum += rating;

          // เพิ่มจำนวนรีวิว
          reviewCount++;
        }
      }

      // คำนวณคะแนนเฉลี่ย (rating average)
      double ratingAverage = ratingSum / reviewCount;

      // ปรับเศษให้เหลือ 2 ตำแหน่งทศนิยม
      String formattedRatingAverage;
      // ตรวจสอบว่า ratingAverage มีค่าเป็น NaN หรือไม่
      if (ratingAverage.isNaN) {
        // กำหนดค่า formattedRatingAverage เป็น 0.0
        formattedRatingAverage = "0.0";
      } else {
        // ปรับเศษให้เหลือ 2 ตำแหน่งทศนิยม
        formattedRatingAverage = ratingAverage.toStringAsFixed(2);
      }
// เก็บคะแนนเฉลี่ยที่ถูกปรับเศษในตัวแปร formattedRatingAverage หรือทำสิ่งที่คุณต้องการในอนาคต
      try {
        // สร้าง DocumentReference สำหรับเก็บข้อมูลใน Firebase Firestore
        DocumentReference docRef = FirebaseFirestore.instance
            .collection("RatingMenu")
            .doc(foodDocId)
            .collection("ReviewPoint")
            .doc();

        DocumentSnapshot docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          // ข้อมูลมีอยู่แล้ว ไม่ต้องเพิ่มซ้ำ
          print("Data already exists for Food: $foodDocId");
        } else {
          String ID = foodDocId.toString();
          String Rating = formattedRatingAverage.toString();
// สร้าง dataMap ด้วยข้อมูลที่คุณต้องการเก็บ
          Map<String, dynamic> dataMap = {
            'Rating_Average': Rating,
          };
          try {
            // เขียนข้อมูลลง Firebase Firestore ด้วย await
            await docRef.set(dataMap);
            print("Upload complete");
          } catch (e) {
            print('Upload Error: $e');
            // จัดการข้อผิดพลาดที่เกิดขึ้นที่นี่
          }
          print('Food: $foodDocId, Rating Average: $formattedRatingAverage');
        }
      } catch (e) {
        print('data Error: $e');
        // จัดการข้อผิดพลาดที่เกิดขึ้นที่นี่
      }
    }

    // print('ID_Food = ');
    // print(ID_Food);
    return documentIds;
  }
}
