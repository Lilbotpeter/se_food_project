import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:se_project_food/Authen/authen_part.dart';
//import 'package:se_project_food/Screen/Profile/my_food.dart';
//import 'package:se_project_food/constants.dart';

import '../../Models/foodmodels.dart';
import '../../Widgets/food_card.dart';


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
    Size size = MediaQuery.of(context).size;
      return SafeArea(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodModels.length,
              itemBuilder: (BuildContext buildContext, int index) {
                return Container(
                    child: Column(children: <Widget>[
                      ShowFoodCard(image: foodModels[index].food_image, title: foodModels[index].food_name, owner: foodModels[index].user_id, rating: 4.4, press: (){}),
                      
                    ]),

                );
              },
            ),
          );

  }
}

//   SafeArea(
//         child: Column(
//           children: <Widget>[
//             //Search box
//             HeadSearch(size: size,curuser: "Worapong", image: "images/james-person-1.jpg",),//<-uid.name
//             //Recommend
//             TitleCustomWithMore(text: "เมนูแนะนำ",),
//             SizedBox(height: 10,),

//             //New menu
//             Row(
//               children: [
//                 ListView.builder(
//                    itemCount: foodModels.length,
//                    itemBuilder: (BuildContext buildContext, int index) {
//                     return Row(
//                     children: <Widget>[
//                       ShowFoodCard(
//                         image: foodModels[index].food_image,
//                         title: foodModels[index].food_name,
//                         owner: foodModels[index].user_id,
//                         rating: 4.4,
//                         press: (){
//                         },
//                       ),
//                     ],
//                     );
            
//                    }
//                 ),
//               ],
//             ),
  

//             //New menu title
//             TitleCustomWithMore(text: "เมนูเก่า"),
//             SizedBox(height: 10,),
//             //New Menu card

//              //New menu title
//             TitleCustomWithMore(text: "เมนูที่ติดตาม"),
//             SizedBox(height: 10,),
//             //New Menu card
            

//           ],
//         ),
//       );
//   }
// }


//Scaffold(
    //   body: ListView(
    //     padding: EdgeInsets.zero,
    //     children: <Widget>[
    //       Container(
    //         padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
    //         height: 180,
    //         width: double.infinity,
    //         decoration: const BoxDecoration(
    //           color: Colors.orange,
    //           borderRadius: const BorderRadius.only(
    //             bottomRight: Radius.circular(20),
    //             bottomLeft: Radius.circular(20),
    //           ),
    //           gradient: LinearGradient(
    //             colors:[
    //               Color.fromARGB(255, 255, 127, 8),
    //               Color.fromARGB(255, 255, 198, 55),],
    //               begin: Alignment.topLeft,
    //               end: Alignment.bottomRight, 
    //             ),
    //         ),
    //         child: Column(
    //           children: [
    //             const SizedBox(height:30),
    //             ListTile(
    //               title: Text("Hi You!",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    //                 color: Colors.white
    //               )),
    //               subtitle: Text("welcome!",style: Theme.of(context).textTheme.titleSmall?.copyWith(
    //                 color: Colors.white
    //               )),
    //               trailing: CircleAvatar(
    //                 radius: 30,
    //                 //backgroundImage: AssetImage('assets/images/logo.png'),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],

    //   ),

// Center(
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