import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Widgets/food_card.dart';
//import 'package:se_project_food/Authen/authen_part.dart';

import '../../Models/foodmodels.dart';
import '../../Widgets/profile_picture.dart';
import '../../constants.dart';

//Authen Current User
final User? user = AuthenticationController().currentUser;

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? name = '';
  String? image = '';
  String? email = '';
  String? phone = '';
  File? imageXFile;

  List<FoodModel> foodModels = []; //List Model Food



//Get data fromdatabase
  Future<void> _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!["Name"];
          email = snapshot.data()!["Email"];
          phone = snapshot.data()!["Phone"];
          image = snapshot.data()!["ImageP"];
        });
      }
    });
  }

  Future<void> readData() async {
    //read data
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection('Foods'); //collection Person  //await
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots =
          response.docs; //snapshot from firestore [array]
      for (var snapshot in snapshots) {
        //print("object");
        FoodModel foodModel =
            FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
        foodModel.food_id = snapshot.id;

        setState(() {
          //print("object");
          if (user?.uid == foodModel.user_id) {
            foodModels.add(foodModel);
          }
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    readData();
  }

  Widget buildFoodItem(FoodModel food) {
  return GestureDetector(
    onTap: () {
      Get.snackbar(food.food_name, "Tapped");
    },
    child: Container(
      child:Image.network(
          food. food_image, // ใช้ฟิลด์ food.image เพื่อระบุ URL ของรูปภาพ
          fit: BoxFit.cover, // ปรับขนาดรูปภาพให้พอดีกับพื้นที่ที่กำหนด
          height: 150, // กำหนดความสูงของรูปภาพ
          width: double.infinity, // กำหนดความกว้างของรูปภาพเต็มพื้นที่ที่มีอยู่
        ),
        
        // ... โค้ดส่วนอื่น ๆ ของรายการอาหาร
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                //profile picture
                ProfilePicture(imageXFile: imageXFile, image: image),
                SizedBox(height: 20,),
                Text(
                  name ?? '', //Show Name เด้อจ้า
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 5,),
                Text(
                  email ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  width:250,
                //Stat Row
                child :Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Status
                    StatusText(12,'สูตรอาหาร'),
                    StatusText(54.2,'ผู้ติดตาม'),
                    StatusText(4.4,'เรทติ้ง'),
                  ],
                )
                ),
                

              ],
            ),
            
            ),
          
        Positioned(
          top: 330,
          right: 10,
          left: 10,
          bottom: 0,
          child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // จำนวนคอลัมน์ในกริด
                    mainAxisSpacing: 2, // ระยะห่างระหว่างรายการในแนวตั้ง
                    crossAxisSpacing: 5, // ระยะห่างระหว่างรายการในแนวนอน
                    childAspectRatio: 1, // อัตราส่วนของความกว้างต่อความสูงของรายการ
                  ),
                  itemCount: foodModels.length, // จำนวนรายการใน GridView
                  itemBuilder: (context, index) {
                  FoodModel food = foodModels[index]; // รายการอาหารที่กำลังวนรอบ
                    return buildFoodItem(food);
                        
                    },
                  ),
        )
        ],)
    );
  }

//Status Text
  Column StatusText(double number,String title) {
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


// //Button EditProfile
                // ElevatedButton(onPressed: (){},
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: kPrimaryColor,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(100),
                //   ),
                // ),
                // child: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 15),
                //   child: Text(
                //     "แก้ไขโปรไฟล์",
                //     style: TextStyle(
                //     fontSize: 14,
                //     color: kTextColor,
                //     fontWeight: FontWeight.w600),
                //   ),
                // ),
                //  ),

