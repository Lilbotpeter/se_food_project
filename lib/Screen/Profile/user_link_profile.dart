import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Detail/detail.dart';
//import 'package:se_project_food/Authen/authen_part.dart';

import '../../Models/foodmodels.dart';
import '../../Widgets/appbar_custom.dart';
import '../../Widgets/profile_picture.dart';
import '../../constants.dart';

//Authen Current User
final User? user = AuthenticationController().currentUser;
  
  

class UserLinkProfile extends StatefulWidget {
  const UserLinkProfile({Key? key}) : super(key: key);

  @override
  State<UserLinkProfile> createState() => UserLinkProfileState();
}

class UserLinkProfileState extends State<UserLinkProfile> {
  String? name = '';
  String? image = '';
  String? email = '';
  String? phone = '';
  File? imageXFile;

  List<FoodModel> foodModels = []; //List Model Food
  final userid = FirebaseAuth.instance.currentUser!.uid;
  final String getUserID = Get.arguments as String; //รับ Food ID

 Future<void> _getUserFromDatabase() async {
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
    .collection("users")
    .doc(getUserID)
    .get();
        
  if (snapshot.exists) {
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      setState(() {
        name = data["Name"];
        image = data["ImageP"];
        email = data["Email"];
        phone = data["Phone"];

      });
    }
  }
}

// //Get data fromdatabase
//   Future<void> _getDataFromDatabase() async {
    
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(getUserID)
//         .get()
//         .then((snapshot) {
//       if (snapshot.exists) {
//         setState(() {
//           name = snapshot.data()!["Name"];
//           email = snapshot.data()!["Email"];
//           phone = snapshot.data()!["Phone"];
//           image = snapshot.data()!["ImageP"];
//         });
//       }
//     });
//   }


  Future<void> readData() async {
  // Clear existing data
  setState(() {
    foodModels.clear();
  });

  // Read data
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collectionReference = firestore.collection('Foods');
  await collectionReference.snapshots().listen((response) {
    List<DocumentSnapshot> snapshots = response.docs;
    for (var snapshot in snapshots) {
      FoodModel foodModel = FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
      foodModel.food_id = snapshot.id;

      if (getUserID == foodModel.user_id) {
        setState(() {
          foodModels.add(foodModel);
          
        });
      }
    }
  });
}



   Future<void> clearData() async {
    setState(() {
      foodModels.clear();
    });
  }

  Future<void> logout() async {
    Get.snackbar('Logout', 'Logged out');
    
    await clearData();
    await readData();
  }


  @override
  void initState() {
    super.initState();
    //_getDataFromDatabase();
    _getUserFromDatabase();
    readData();
  }



  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    Widget buildFoodItem(int index) {
      return GestureDetector(
        onTap: () {
          Get.snackbar(foodModels[index].food_name,foodModels[index].user_id);
          Get.to(DetailFood(),arguments: foodModels[index].food_id); // ตัวส่ง Parameter
        },
        child: Container(
          child: Image.network(
            foodModels[index].food_image,
            fit: BoxFit.cover,
            height: 150,
            width: double.infinity,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: AppbarCustom(), //Appbar custom
          child: Container(
            height: 150,
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
                  Text('Food Homework Commu',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white,),),

                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                
                //profile picture
                ProfilePicture(imageXFile: imageXFile, image: image),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name ?? '', //Show Name เด้อจ้า
                      style: TextStyle(fontSize: 25.0),
                    ),
                    
                  ],
                ),
                const SizedBox(height: 5,),
                Text(
                  email ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){Get.snackbar("Check", "currect $getUserID");},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                      child: Text(
                        "ติดตาม",
                        style: TextStyle(
                        fontSize: 14,
                        color: kTextColor,
                        fontWeight: FontWeight.w600),
                      ),
                    ),
                     ),
                    
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 200,
                  width:300,
                //Stat Row
                child :Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Status
                    StatusText(foodModels.length,'สูตรอาหาร'),
                    StatusText(54,'ผู้ติดตาม'),
                    StatusText(4,'กำลังติดตาม'),
                  ],
                )
                ),
                

              ],
            ),
            
            ),

          
        Positioned(
          top: 335,
          right: 10,
          left: 10,
          bottom: 0,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // จำนวนคอลัมน์ในกริด
            mainAxisSpacing: 2, // ระยะห่างระหว่างรายการในแนวตั้ง
            crossAxisSpacing: 5, // ระยะห่างระหว่างรายการในแนวนอน
            childAspectRatio: 1, // อัตราส่วนของความกว้างต่อความสูงของรายการ
                  ),
                  itemCount: foodModels.length, // จำนวนรายการใน GridView
                  itemBuilder: (BuildContext buildContext, int index) {
                    
                    return buildFoodItem(index);
                    },
                  ),
        ),

        ],)
    );
  }

//Status Text
  Column StatusText(int number,String title) {
    return Column(
                    children: [
                      Text(
                        '$number',
                        style: TextStyle(
                          fontSize: 22,fontWeight: FontWeight.w500
                        )
                      ),
                      Text(
                            title,
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400,color: Color.fromARGB(221, 129, 129, 129)
                            ),
                          ),
                        ],
                  );
  }
}
