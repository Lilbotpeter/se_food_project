import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String? documentId; // เพิ่ม field documentId เพื่อใช้เป็น ID ของเอกสาร
  final String? foodID;
  final String? userID;

    Service(
      {this.documentId, this.foodID, this.userID});
}

class DataService {
  //ฟังก์ชันติดตาม
  // เพิ่มข้อมูลผู้ใช้งาน
  Future<List<dynamic>> getFood(String? foodID) async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(foodID)
        .get();
    List<dynamic> foodDataList = [];

    if (snapshot.exists) {
      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

          foodDataList.add({
            'Food_Description': data?['Food_Description'],
            'Food_Image': data?['Food_Image'],
            'Food_Ingredients': data?['Food_Ingredients'],
            'Food_Level': data?['Food_Level'],
            'Food_Name': data?['Food_Name'],
            'Food_Nation': data?['Food_Nation'],
            'Food_Point': data?['Food_Point'],
            'Food_Solution': data?['Food_Solution'],
            'Food_Time': data?['Food_Time'],
            'Food_Type': data?['Food_Type'],
            'Food_id': data?['Food_Point'],
            'User_id': data?['User_id'],
          });
        }
        return foodDataList;
    }

   Future<Map<String, dynamic>> getUser(String? userID) async {
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(userID)
      .get();

  Map<String, dynamic> userData = {}; // สร้าง Map เปล่าเพื่อเก็บข้อมูลผู้ใช้

  if (snapshot.exists) {
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    
    userData = {
      'Email': data?['Email'],
      'ImageP': data?['ImageP'],
      'Name': data?['Name'],
      'Phone': data?['Phone'],
      'Uid': data?['Uid'],
    };
  }

  return userData; // คืนข้อมูลผู้ใช้ในรูปแบบ Map
}

     Future<List<dynamic>> getReview(String? IDreview) async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(IDreview)
        .get();
    List<dynamic> reviewDataList = [];

    if (snapshot.exists) {
      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

          reviewDataList.add({
            'Email': data?['Email'],
            'ImageP': data?['ImageP'],
            'Name': data?['Name'],
            'Phone': data?['Phone'],
            'Uid': data?['Uid'],
          });
        }
        return reviewDataList;
    }    
  }

