import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Profile/my_food.dart';

import '../../Models/foodmodels.dart';
import '../../Models/user.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  AuthenticationController auth = AuthenticationController.instanceAuth;
  List<FoodModel> foodModels = [];
  final TextEditingController edit_name = TextEditingController();
  final TextEditingController edit_description = TextEditingController();
  final TextEditingController edit_ingredients = TextEditingController();

    @override
  void initState() {
    super.initState();
    readData();
  }
  


  Future<void> readData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference collectionReference = firestore.collection('Foods');
  final snapshots = await collectionReference.get();

  List<FoodModel> newFoodModels = []; // สร้างรายการของ FoodModel ใหม่

  for (var snapshot in snapshots.docs) {
    FoodModel foodModel =
        FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
    foodModel.food_id = snapshot.id;

    newFoodModels.add(foodModel); // เพิ่ม FoodModel เข้าในรายการใหม่
  }

  setState(() {
    foodModels = newFoodModels; // อัปเดต foodModels ด้วยรายการใหม่
  });
}


  // //logout *
  // Future<void> signOut() async {
  //   await AuthenticationController().signOut();
  // }

  //Widget Logout Button *
  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      onPressed: (){AuthenticationController().signOut();},
      child: const Text('ออกจากระบบ'),
    );
  }

  //Show All
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
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 19),
            alignment: Alignment.bottomCenter,
            height: 120,
            decoration: BoxDecoration(color: Colors.orange),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ยินดีต้อนรับ",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),  
                  ),
                  Text(
                    'คุณ Your name',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white54.withOpacity(.5)
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        
                      ),
                      onPressed: (){
                        //Search Page
                      },
                    ),
                  )
                ],
              )
            ]),
          ),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(text: const TextSpan(
                  text: "เมนูแนะนำ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ),
                InkWell(
                      onTap: (){
                        //jump to register sceen
                        Get.to(MyFoods());
                      },
                      child: const Text(
                        "+เพิ่มเติม",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
              ],
            ),
          )
        ],)


    );
  }
}



// SafeArea(
//         child: Center(
//           child: Container(
//             child: ListView.builder(
//               itemCount: foodModels.length,
//               itemBuilder: (BuildContext buildContext, int index) {
//                 return Card(
//                   child: Column(children: <Widget>[
//                     showImage(index),
//                     showName(
//                       index,
//                     ),
//                     Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             primary: Color.fromARGB(255, 255, 115, 0),
//                             textStyle: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
                              
                              
//                             )),
//                         onPressed: () {
//                           print('Show Start');
//                           readData();
//                           showDialog<void>(
//                             context: context,
//                             barrierDismissible: false, // user must tap button!
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('รายละเอียด:'),
//                                 content: SingleChildScrollView(
//                                   child: ListBody(
//                                     children: <Widget>[
//                                       Text("ชื่อสูตรอาหาร : "),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Text(
//                                         foodModels[index].food_name,
//                                       ),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Text("วัตถุดิบ : "),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Text(
//                                         foodModels[index].food_ingredients,
//                                       ),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Text("รายละเอียด : "),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                       Text(
//                                         foodModels[index].food_description,
//                                       ),
//                                       SizedBox(
//                                         height: 10.0,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
                              
//                               );
//                             },
//                           );
//                         },
//                         child: Text('ดูสูตรอาหาร'),
//                       ),
//                     ),
//                   ]),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),