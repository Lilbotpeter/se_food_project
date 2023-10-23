import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';
import 'detail.dart';

class detailLevelfood extends StatefulWidget {
  const detailLevelfood({super.key});

  @override
  State<detailLevelfood> createState() => _detailLevelfoodState();
}

class _detailLevelfoodState extends State<detailLevelfood> {
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
              flexibleSpace: ClipPath(
                child: Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 127, 8),
                        Color.fromARGB(255, 255, 198, 55),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Text('Food Homework Commu',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white,),),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ListView.builder(
              itemCount: FoodList.length,
              itemBuilder: (context, index) {
                final FoodData = FoodList[index];
                if (getfoodID.toString() == FoodData['Food_Level']) {
                  return Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Get.to(DetailFood(), arguments: FoodData['Food_id']);
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 5.0, 20.0, 5.0),
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding:  const EdgeInsets.fromLTRB(160, 20.0, 20.0, 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                      width: 80,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${FoodData['Food_Name']}',
                                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), maxLines: 2,overflow: TextOverflow.fade,),
                                          Text('${FoodData['Food_Level']}',
                                                  style: TextStyle(fontSize: 14,color: Colors.black54), maxLines: 2,overflow: TextOverflow.fade,),
                                        ],
                                      ),
                                    ),

                                     Column(
                                      
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.star,color: Colors.yellow,),
                                            Text('${FoodData['Food_Point']}',
                                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), maxLines: 5),
                                          ],
                                        ),
                                        SizedBox(height: 50,),
                                        
                                      ],
                                    ),
                              
                              ],
                            ),
                            
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                       Positioned(
                      left: 20.0,
                      top: 5,
                      bottom: 5.0,
                      child: GestureDetector(
                        onTap: (){
                          Get.to(DetailFood(), arguments: FoodData['Food_id']);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(FoodData['Food_Image'],fit: BoxFit.cover,width: 150,)),
                      )),
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
