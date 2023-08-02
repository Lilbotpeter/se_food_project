import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Detail/detail.dart';
import 'package:se_project_food/Screen/Profile/user_link_profile.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
import 'package:se_project_food/Screen/Search/search_food.dart';
import 'package:se_project_food/Screen/Search/search_page.dart';
import 'package:se_project_food/Widgets/food_slide.dart';
import 'package:se_project_food/Widgets/title_cus_more.dart';
//import 'package:se_project_food/Screen/Profile/my_food.dart';
//import 'package:se_project_food/constants.dart';

import '../../Models/foodmodels.dart';
import '../../Widgets/food_card.dart';
import '../../global.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  
  AuthenticationController auth = AuthenticationController.instanceAuth;
  List<FoodModel> foodModels = [];
    //User
  String? name = '';
  String? image = '';
  String? email = '';
  String? phone = '';
  File? imageXFile;

  String? uname = '';
  String? uimage = '';
  String? uemail = '';
  String? uphone = '';
  
  

   final userid = FirebaseAuth.instance.currentUser!.uid;
   
  @override
  void initState() {
    super.initState();
    readData();
    _getUserDataFromDatabase();
    //_getUserToDataFromDatabase();
  }
  
  Future<void> _getUserDataFromDatabase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userid)
          .get();

      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!["Name"];
          email = snapshot.data()!["Email"];
          phone = snapshot.data()!["Phone"];
          image = snapshot.data()!["ImageP"];
        });
      } else {
        print("ไม่พบข้อมูลผู้ใช้ใน Firestore");
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการค้นหาข้อมูลผู้ใช้: $e");
    }
  }

  void onMenuProffile() {
    // เรียกใช้ฟังก์ชัน GetX ที่ต้องการ
    Get.to((UserProfile())
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }



  // Future<void> _getUserToDataFromDatabase() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc()
  //         .get();

  //     if (snapshot.exists) {
  //       setState(() {
  //         uname = snapshot.data()!["Name"];
  //         uemail = snapshot.data()!["Email"];
  //         uphone = snapshot.data()!["Phone"];
  //         uimage = snapshot.data()!["ImageP"];
  //       });
  //     } else {
  //       print("ไม่พบข้อมูลผู้ใช้ใน Firestore");
  //     }
  //   } catch (e) {
  //     print("เกิดข้อผิดพลาดในการค้นหาข้อมูลผู้ใช้: $e");
  //   }
  // }


  Future<void> readData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
   setState(() {
      showProgressBar = true;// เริ่มแสดง CircularProgressIndicator
    });

  CollectionReference collectionReference = firestore.collection('Foods');
  final snapshots = await collectionReference.get();

  List<FoodModel> newFoodModels = []; // สร้างรายการของ FoodModel ใหม่

  for (var snapshot in snapshots.docs) {
    FoodModel foodModel =
        FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
    foodModel.food_id = snapshot.id;

    newFoodModels.add(foodModel); // เพิ่ม FoodModel เข้าในรายการใหม่
  }
  try{
  setState(() {
    foodModels = newFoodModels; // อัปเดต foodModels ด้วยรายการใหม่
  });
  }catch(e){
    '';
  }
}

  //Widget Logout Button *
  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      onPressed: (){AuthenticationController().signOut();},
      child: const Text('ออกจากระบบ'),
    );
  }


  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
      return Material(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          
          child: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 145, 0), Color.fromARGB(255, 255, 253, 249), const Color.fromARGB(255, 255, 255, 255)],
            stops: [0.1, 0.5, 0.9],
              ),
          ),

          child: Column(
            children: [
              SizedBox(height: 0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("ยินดีต้อนรับ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(134, 255, 255, 255),
                          fontWeight: FontWeight.w800,
                        ),),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          children: [
                            Icon(Icons.person,color: Color.fromARGB(255, 255, 182, 134),),
                            Text(" คุณ $name",
                                overflow: TextOverflow.fade, 
                                maxLines: 1,
                                textWidthBasis: TextWidthBasis.longestLine,
                                style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                  Stack(
                      children: [
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(child: Text('โปรไฟล์'),value: 1,),
                            const PopupMenuItem(child: Text('ออกจากระบบ'),value: 2,)
                          ],
                          onSelected: (value){
                              if(value ==1){
                                onMenuProffile();
                              }else if(value==2){
                                signOut();
                              }
                          },
                          
                          child: Padding(
                            padding: const EdgeInsets.only(right:10.0,bottom: 25),
                            child: Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage("$image"),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                          ),
                        ),
                        //Red Dot Profile
                        // Positioned(child: Container(
                        //   margin: EdgeInsets.all(5),
                        //   padding: EdgeInsets.all(5),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.white,width: 3),
                        //     color: Colors.red,
                        //     shape: BoxShape.circle,
                        //   ),
                        // )),

                      ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(SearchFoodStream());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.1,
                  
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 13),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(135, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    child: const Center(
                      child: Row(
                        children: [
                          Icon(Icons.search,color: Colors.black45,),
                          Text("ค้นหาอาหาร",style: TextStyle(color: Colors.black45),),
                        ],
                      ),
                    ),
                      ),
                  ),
                ],
              ),
                const SizedBox(height: 20,),
                SizedBox(
                height: 150,
                child: Container(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 15),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                        //   gradient: LinearGradient(
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                        // colors: [Color.fromARGB(255, 255, 145, 0), Color.fromARGB(255, 255, 211, 123), Color.fromARGB(255, 255, 132, 16)],
                        // stops: [0.1, 0.5, 0.9],
                        //   ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "images/food.jpg",
                              height: 80,
                              width: 80,
                            ),
                            Text("หมวดทดลอง"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
                SizedBox(height: 20,),
                TitleCustomWithMore(text: "เมนูแนะนำ!"),
                SizedBox(height: 20,),
                CarouseSlide(foodModels: foodModels,ownername: '$uname',),

                SizedBox(height: 25,),
                TitleCustomWithMore(text: "เมนูใหม่"),
                SizedBox(height: 15,),
                Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: foodModels.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext buildContext, int index) {
                                  return Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(children: <Widget>[
                                        ShowFoodCard(image: foodModels[index].food_image, title: foodModels[index].food_name, owner: foodModels[index].user_id, rating: 4.4, press: (){
                                          Get.to(DetailFood(), arguments: foodModels[index].food_id, transition: Transition.rightToLeft);
                                        }),
                                      
                                      ]
                                      ),
                                  );
                                },  
                              ),
                            ),
                
            ],
          ),
        ),
        )
      );

  }
}

class CarouseSlide extends StatelessWidget {
  const CarouseSlide({
    super.key,
    required this.foodModels, required this.ownername,
  });

  final List<FoodModel> foodModels;
  final String ownername;


  @override
  Widget build(BuildContext context) {
    return Container(
                height: 200,
                child: CarouselSlider(
  options: CarouselOptions(
    height: 200,
    enableInfiniteScroll: true,
    autoPlay: true,
  ),
  items: foodModels.map((foodModel) {
    return Builder(
      builder: (BuildContext context) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset.infinite,
                    blurRadius: 10,
                    spreadRadius: 10,
                    
                    )
                ]
              ),
              padding: const EdgeInsets.only(right: 10),
              child: SlideFoodCard(
                image: foodModel.food_image,
                title: foodModel.food_name,
                owner: foodModel.user_id,
                rating: foodModel.food_point,
                press: () {
                  Get.to(DetailFood(), arguments: foodModel.food_id , transition: Transition.rightToLeft);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 15,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10)
                  
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodModel.food_name,
                      style: TextStyle(color: Colors.white, fontSize: 24,
                      fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, 
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star,color: Color.fromARGB(255, 240, 179, 11),),
                        Text(foodModel.food_point,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
                
              ),
            ),
          ],
        );
      },
    );
  }).toList(),
),

              );
  }
}





//SafeArea(
      //       child: Padding(
      // padding: const EdgeInsets.symmetric(vertical: 30),
      // child: Column(
      //   children: [
      //     TitleCustomWithMore(text: "เมนูวันนี้"),
      //     SizedBox(height: 20),
      //     Container(
      //       height: 200,
      //       child: CarouselSlider(
      //         options: CarouselOptions(
      //           height: 200,
      //           enableInfiniteScroll: true,
      //           autoPlay: true,
      //         ),
      //         items: foodModels.map((foodModel) {
      //           return Builder(
      //             builder: (BuildContext context) {
      //               return Container(
      //                 padding: EdgeInsets.only(right: 10),
      //                 child: SlideFoodCard(
      //                   image: foodModel.food_image,
      //                   title: foodModel.food_name,
      //                   owner: foodModel.user_id,
      //                   rating: 4.4,
      //                   press: () {
      //                     Get.to(DetailFood(), arguments: foodModel.food_id);
      //                   },
      //                 ),
      //               );
      //             },
      //           );
      //         }).toList(),
      //       ),
      //     ),
      //     SizedBox(height: 25,),
      //     TitleCustomWithMore(text: "เมนูใหม่"),
      //     SizedBox(height: 15,),
      //             Expanded(
      //               child: Container(
      //                   height: 200,
      //                   child: ListView.builder(
      //                     scrollDirection: Axis.horizontal,
      //                     itemCount: foodModels.length,
      //                     shrinkWrap: true,
      //                     itemBuilder: (BuildContext buildContext, int index) {
      //                       return Container(
      //                           padding: EdgeInsets.only(right: 10),
      //                           child: Column(children: <Widget>[
      //                             ShowFoodCard(image: foodModels[index].food_image, title: foodModels[index].food_name, owner: foodModels[index].user_id, rating: 4.4, press: (){
      //                               Get.to(DetailFood(), arguments: foodModels[index].food_id);
      //                             }),
                                
      //                           ]
      //                           ),
      //                       );
      //                     },  
      //                   ),
      //                 ),
      //               ),
                  
                
      //           ],
      //         ),
      //       ),
      //     );