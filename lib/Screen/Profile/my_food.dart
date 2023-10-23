import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Edit/editfood_page.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';

import '../../Models/foodmodels.dart';
import 'deleteFoodService.dart';

class MyFoods extends StatefulWidget {
  const MyFoods({super.key});

  @override
  State<MyFoods> createState() => _MyFoodsState();
}

class _MyFoodsState extends State<MyFoods> {
  List<FoodModel> foodModels = [];
  final TextEditingController edit_name = TextEditingController();
  final TextEditingController edit_description = TextEditingController();
  final TextEditingController edit_ingredients = TextEditingController();
  //Method ที่ทำงาน อ่านค่าที่อยู่ใน fire store

  @override
  void initState() {
    super.initState();
    readData();
  }

// _HomeFeedState(String id, {Key? key}) : super(key: key) {
//    // _documentReference = FirebaseFirestore.instance.collection('Foods').doc(id);
//    // _future = _documentReference.get();
//   }

  Future<void> readData() async {
    //read data
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection('Foods'); //collection Person  //await
    // await collectionReference.snapshots().listen((response) {
    //   List<DocumentSnapshot> snapshots =
    //       response.docs; //snapshot from firestore [array]
    //   for (var snapshot in snapshots) {
    //     //print("object");
    //     FoodModel foodModel =
    //         FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
    //     foodModel.food_id = snapshot.id;

    //     setState(() {
    //       //print("object");
    //       if (user?.uid == foodModel.user_id) {
    //         foodModels.add(foodModel);
    //       }
    //     });
    //   }
    // });
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.docs;
      for (var snapshot in snapshots) {
        FoodModel foodModel =
            FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
        foodModel.food_id = snapshot.id;

        if (user?.uid == foodModel.user_id) {
          if (mounted) {
            // Check if the widget is still mounted
            setState(() {
              foodModels.add(foodModel);
            });
          }
        }
      }
    });
  }

  //logout *
  Future<void> signOut() async {
    await AuthenticationController().signOut;
  }

  //Widget Show Current User *
  Widget _userUID() {
    return Text(user?.email ?? 'User email');
  }

  //Widget Logout Button *
  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      onPressed: signOut,
      child: const Text('ออกจากระบบ'),
    );
  }

  Widget showImage(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Image.network(
        foodModels[index].food_image,
      ),
    );
  }

  Widget showName(int index) {
    return Text(
      foodModels[index].food_name,
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      maxLines: 5,
      overflow: TextOverflow.fade,
    );
  }

  Widget showDescription(int index) {
    return Text(
      foodModels[index].food_description,
    );
  }

  Widget showIngredients(int index) {
    return Text(
      foodModels[index].food_ingredients,
    );
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: ListView.builder(
              itemCount: foodModels.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Card(
                    color: Colors.black,
                    child: Row(children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.5,
                          child: Image.network(
                            foodModels[index].food_image,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            showName(
                              index,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.amber,
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                onPressed: () {
                                  print(foodModels[index].food_id);
                                  Get.to(EditFoods(),
                                      arguments: foodModels[index].food_id);
                                },
                                child: Text(
                                  'แก้ไขข้อมูล',
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                // onPressed: () async {

                                // final docker = FirebaseFirestore.instance
                                //     .collection('Foods')
                                //     .doc(foodModels[index].food_id);

                                // try {
                                //   await docker.delete();
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text('ลบข้อมูลเรียบร้อยแล้ว')),
                                //   );
                                //   setState(() {
                                //     foodModels.removeAt(index);
                                //   });
                                // } catch (e) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //         content: Text('เกิดข้อผิดพลาดในการลบข้อมูล')),
                                //   );
                                // }
                                //},
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("ยืนยันการลบ"),
                                        content: Text(
                                            "คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("ยกเลิก"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("ลบ"),
                                            onPressed: () {
                                              // print('Fuufood =' +
                                              //     foodModels[index]
                                              //         .food_id
                                              //         .toString());

                                              final deleteFood =
                                                  DeleteFoodService();
                                              //
                                              deleteFood
                                                  .DeleteFoodReplyCommentData(
                                                      foodModels[index]
                                                          .food_id
                                                          .toString());
                                              //
                                              deleteFood.DeleteFoodReplyModData(
                                                  foodModels[index]
                                                      .food_id
                                                      .toString());
                                              //
                                              deleteFood
                                                  .DeleteFoodReplyReviewData(
                                                      foodModels[index]
                                                          .food_id
                                                          .toString());
                                              //
                                              deleteFood.DeleteFoodCommentData(
                                                  foodModels[index]
                                                      .food_id
                                                      .toString());
                                              //
                                              deleteFood.DeleteFoodModData(
                                                  foodModels[index]
                                                      .food_id
                                                      .toString());
                                              //
                                              deleteFood.DeleteFoodReviewData(
                                                  foodModels[index]
                                                      .food_id
                                                      .toString());
                                              //
                                              deleteFood.DeleteFoodData(
                                                  foodModels[index]
                                                      .food_id
                                                      .toString());

                                              Navigator.of(context)
                                                  .pop(); // ปิด AlertDialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },

                                child: Text(
                                  'ลบข้อมูล',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // showDescription(index),
                      // showIngredients(index),

                      // IconButton(
                      //   icon: new Icon(Icons.edit),
                      //   highlightColor: Colors.pink,
                      //   onPressed: () {
                      //     print("kuay");
                      //     MaterialPageRoute route = MaterialPageRoute(
                      //       builder: (Index) => UploadFoodPage(),
                      //     );
                      //   },
                      // ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    //Stream<List<PersonModel>> readData
  }
}
