import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';
import 'detail.dart';

class detailNationfood extends StatefulWidget {
  const detailNationfood({super.key});

  @override
  State<detailNationfood> createState() => _detailNationfoodState();
}

class _detailNationfoodState extends State<detailNationfood> {
  List<dynamic> FoodList = [];
  String getfoodID = '';

  @override
  void initState() {
    super.initState();
    getfoodID = Get.arguments as String;
    fetchFoodData();
  }

  Future<void> fetchFoodData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;
        String Snapidx = snapID;
        DocumentSnapshot docFirestoreDoc =
            await firestore.collection('Foods').doc(Snapidx).get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> foodData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          FoodList.add({
            'Food_Description': foodData['Food_Description'],
            'Food_Image': foodData['Food_Image'],
            'Food_Ingredients': foodData['Food_Ingredients'],
            'Food_Level': foodData['Food_Level'],
            'Food_Name': foodData['Food_Name'],
            'Food_Nation': foodData['Food_Nation'],
            'Food_Point': foodData['Food_Point'],
            'Food_Solution': foodData['Food_Solution'],
            'Food_Time': foodData['Food_Time'],
            'Food_Type': foodData['Food_Type'],
            'Food_id': foodData['Food_id'],
            'User_id': foodData['User_id'],
          });
        }
      }

      setState(() {}); // Update the widget when data is fetched.
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตอบกลับ35'),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            child: ListView.builder(
              itemCount: FoodList.length,
              itemBuilder: (context, index) {
                final FoodData = FoodList[index];
                if (getfoodID.toString() == FoodData['Food_Nation']) {
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ชื่อ : ${FoodData['Food_Name']}',
                                  style: TextStyle(fontSize: 10), maxLines: 5),
                              Text('ประเภท : ${FoodData['Food_Type']}',
                                  style: TextStyle(fontSize: 10), maxLines: 5),
                              Text('สัญชาติ : ${FoodData['Food_Nation']}',
                                  style: TextStyle(fontSize: 10), maxLines: 5),
                              TextButton(
                                  onPressed: () {
                                    print(FoodData['Food_id']);
                                    Get.to(DetailFood(),
                                        arguments: FoodData['Food_id'],
                                        transition: Transition.rightToLeft);
                                  },
                                  child: Text('ดูข้อมูลอาหาร'))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  );
                } else {
                  return Container(); // Return an empty widget for non-matching items.
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
