import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
//import 'package:se_project_food/Authen/authen_part.dart';

import '../../Edit/editUser_page.dart';
import '../../Models/foodmodels.dart';

import '../../Widgets/profile_picture.dart';
import '../../constants.dart';
import '../../follow.dart';
import '../Detail/detail.dart';

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
  int countfollow = 0;
  int countbookmark = 0;
  List<FoodModel> foodModels = []; //List Model Food
  List<FoodModel> follower = []; //List Model Food
  final userid = FirebaseAuth.instance.currentUser!.uid;

  FollowerService followerService = FollowerService();

//Get data fromdatabase
  Future<void> _getDataFromDatabase() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userid)
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
    } catch (error) {
      print('เกิดข้อผิดพลาด : $error');
    }
  }

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
        FoodModel foodModel =
            FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
        foodModel.food_id = snapshot.id;

        if (userid == foodModel.user_id) {
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

  AuthenticationController auth = AuthenticationController.instanceAuth;
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    auth.signOut();
  }

  Future<void> logout() async {
    Get.snackbar('Logout', 'Logged out');
    signOut();
    // await clearData();
    // await readData();
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    readData();
    bookmark();
    follow();
  }

  Future follow() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('followers')
        .doc(userid)
        .collection('followersID')
        .get();
    countfollow = querySnapshot.size;
    // for (QueryDocumentSnapshot countFollow in querySnapshot.docs) {
    //   countfollow = countFollow.id
    // }
  }

  Future bookmark() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('bookmark')
        .doc(userid)
        .collection('bookmarkID')
        .get();
    countbookmark = querySnapshot.size;
    // for (QueryDocumentSnapshot countFollow in querySnapshot.docs) {
    //   countfollow = countFollow.id
    // }
  }
//   Widget buildFoodItem(int index) {
//   return GestureDetector(
//     onTap: () {
//       Get.snackbar(foodModels.fo, "Tapped");
//     },
//     child: Container(
//       child:Image.network(
//           food. food_image, // ใช้ฟิลด์ food.image เพื่อระบุ URL ของรูปภาพ
//           fit: BoxFit.cover, // ปรับขนาดรูปภาพให้พอดีกับพื้นที่ที่กำหนด
//           height: 150, // กำหนดความสูงของรูปภาพ
//           width: double.infinity, // กำหนดความกว้างของรูปภาพเต็มพื้นที่ที่มีอยู่
//         )

//         // ... โค้ดส่วนอื่น ๆ ของรายการอาหาร
//     ),
//   );
// }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    Widget buildFoodItem(int index) {
      return GestureDetector(
        onTap: () {
          Get.to(DetailFood(), arguments: foodModels[index].food_id);
          //Get.snackbar(foodModels[index].food_name, foodModels[index].user_id);
          //Get.to(const EditUser(), arguments: userid); // ตัวส่ง Parameter
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

    // Capture the index value
    return Scaffold(
        appBar: AppBar(
          title: Text('หน้าโปรไฟล์'),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
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
                  const SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name ?? '', //Show Name เด้อจ้า
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        email ?? '',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45),
                      ),
                      SizedBox(
                        height: 25,
                        child: const VerticalDivider(
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                      ),
                      Icon(
                        Icons.phone,
                        size: 20,
                        color: Colors.black38,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        phone ?? '',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.snackbar("Check", "currect $userid");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Get.to(const EditUser(), arguments: userid);
                          },
                          child: const Text(
                            'แก้ไขข้อมูลส่วนตัว',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: FittedBox(
                            child: FloatingActionButton(
                              elevation: 2,
                              backgroundColor: Colors.redAccent,
                              onPressed: () {
                                signOut();
                                AuthenticationController().signOut();
                              },
                              child: const Icon(
                                Icons.logout,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 200,
                      width: 300,
                      //Stat Row
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Status
                          StatusText(foodModels.length, 'สูตรอาหาร'),
                          const VerticalDivider(
                            thickness: 1,
                            indent: 10,
                            endIndent: 160,
                          ),
                          StatusText(countfollow, 'ผู้ติดตาม'),
                          const VerticalDivider(
                            thickness: 1,
                            indent: 10,
                            endIndent: 160,
                          ),
                          StatusText(countbookmark, 'อาหารที่ชอบ'),
                        ],
                      )),
                ],
              ),
            ),
            Positioned(
              top: 350,
              right: 10,
              left: 10,
              bottom: 0,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // จำนวนคอลัมน์ในกริด
                  mainAxisSpacing: 2, // ระยะห่างระหว่างรายการในแนวตั้ง
                  crossAxisSpacing: 5, // ระยะห่างระหว่างรายการในแนวนอน
                  childAspectRatio:
                      1, // อัตราส่วนของความกว้างต่อความสูงของรายการ
                ),
                itemCount: foodModels.length, // จำนวนรายการใน GridView
                itemBuilder: (BuildContext buildContext, int index) {
                  return buildFoodItem(index);
                },
              ),
            ),
          ],
        ));
  }

//Status Text
  Column StatusText(int number, String title) {
    return Column(
      children: [
        Text('$number',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        Text(
          title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(221, 129, 129, 129)),
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

