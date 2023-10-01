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
          .collection('ReviewFood')
          .doc(foodDocId)
          .collection('ReviewID');
      QuerySnapshot querySnapshot_ID = await collection.get();

      double ratingSum = 0.0;
      int reviewCount = 0;

      for (QueryDocumentSnapshot doc in querySnapshot_ID.docs) {
        documentIds.add(doc.id);
        final DocumentReference documentRef = FirebaseFirestore.instance
            .collection("ReviewFood")
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
      double ratingAverage = ratingSum / (reviewCount);

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
        DocumentReference docRef =
            FirebaseFirestore.instance.collection("RatingMenu").doc(foodDocId);

        DocumentReference docRefFood =
            FirebaseFirestore.instance.collection("Foods").doc(foodDocId);

        try {
          DocumentSnapshot docSnapshot = await docRefFood.get();
          if (docSnapshot.exists) {
            String ratingAverageString = formattedRatingAverage.toString();

            Map<String, dynamic> dataMap = {
              'Rating_Average': ratingAverageString,
            };

            Map<String, dynamic> dataMapFood = {
              'Food_Point': ratingAverageString,
            };

            await docRefFood.update(dataMapFood);
            await docRef.update(dataMap);

            print("Data updated for Food: $foodDocId");
          } else {
            String foodDocIdString = foodDocId.toString();
            String ratingAverageString = formattedRatingAverage.toString();

            Map<String, dynamic> dataMap = {
              'Food_id': foodDocIdString,
              'Rating_Average': ratingAverageString,
            };
            Map<String, dynamic> dataMapFood = {
              'Food_id': foodDocIdString,
              'Food_Point': ratingAverageString,
            };

            await docRefFood.update(dataMapFood);
            await docRef.set(dataMap);
            print("Data added for Food: $foodDocId");
          }
        } catch (e) {
          print('Upload Error: $e');
          // จัดการข้อผิดพลาดที่เกิดขึ้นที่นี่
        }
      } catch (e) {
        print('data Error: $e');
        // จัดการข้อผิดพลาดที่เกิดขึ้นที่นี่
      }
      print('Food: $foodDocId, Rating Average: $formattedRatingAverage');
    }

    // print('ID_Food = ');
    // print(ID_Food);
    return documentIds;
  }
}
