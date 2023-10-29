// ignore_for_file: public_member_api_docs, sort_constructors_first
// DropdownButton<String>(
//   value: dropdownValue,
//   onChanged: (String? newValue) {
//     setState(() {
//       dropdownValue = newValue!;
//     });
//   },
//   items: typefood.map((String value) {
//     return DropdownMenuItem<String>(
//       value: value,
//       child: Text(value),
//     );
//   }).toList(),
// )

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Detail/detail.dart';
import 'package:se_project_food/Screen/Detail/detail_service.dart';
import 'package:se_project_food/Screen/Profile/user_link_profile.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
import 'package:se_project_food/Screen/Search/search_food.dart';
import 'package:se_project_food/Screen/Search/search_page.dart';
import 'package:se_project_food/Widgets/food_slide.dart';
import 'package:se_project_food/Widgets/title_cus_more.dart';
import 'package:se_project_food/Screen/Profile/my_food.dart';
//import 'package:se_project_food/constants.dart';

import '../../Models/foodmodels.dart';
import '../../Widgets/food_card.dart';
import '../../Widgets/profile_picture.dart';
import '../../global.dart';
import '../Detail/detailLevelfood.dart';
import '../Detail/detailNationfood.dart';
import '../Detail/detailTypefood.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  AuthenticationController auth = AuthenticationController.instanceAuth;
  List<FoodModel> foodModels = [];
  List<FoodModel> SortfoodModels = [];
  List<dynamic> followUser = [];
  List<dynamic> followFoods = [];
  List<dynamic> countFollows = [];
  List<String> levelfood = [
    'ไม่มี',
    'ง่ายมาก',
    'ง่าย',
    'ปานกลาง',
    'ยาก',
    'ยากมาก',
  ];
  List<String> imagelevelfood = [
    'images/0star.png',
    'images/1star.png',
    'images/2star.png',
    'images/3star.png',
    'images/4star.png',
    'images/5star.png',
  ];
  List<String> imagenationfood = [
    'images/nation/china.jpg',
    'images/nation/japan.jpg',
    'images/nation/france.png',
    'images/nation/spain.png',
    'images/nation/english.png',
    'images/nation/italy.png',
    'images/nation/india.png',
    'images/nation/nations.jpeg',
    'images/nation/usa.png',
    'images/nation/korea.png',
    'images/nation/germany.png',
    'images/nation/thai.png',
  ];

  List<String> nationfood = [
    'จีน',
    'ญี่ปุ่น',
    'ฝรั่งเศษ',
    'สเปน',
    'อังกฤษ',
    'อิตาลี',
    'อินเดีย',
    'อื่นๆ',
    'อเมริกา',
    'เกาหลี',
    'เยอรมัน',
    'ไทย',
  ];

  //
  List<String> typefood = [
    "กาแฟ/ชา",
    "ของทานเล่น/ขนมขบเขี้ยว",
    "ของหวาน",
    "ของทอด",
    "ชาบู/สุกี้",
    "ชานมไข่มุก",
    "ติ่มซำ",
    "ซูชิ",
    "สเต็ก",
    "โจ๊ก",
    "โรตี",
    "โยเกิร์ต/ไอศกรีม",
    "ปิ้งย่าง/บาร์บีคิว",
    "อาหารจานด่วน",
    "อาหารทะเล",
    "อาหารตามสั่ง",
    "อาหารสุขภาพ",
    "อาหารอีสาน",
    "อาหารใต้",
    "อาหารเจ",
    "อาหารเหนือ",
    "อาหารเส้น",
    "ยำ",
    "อื่นๆ",
    "หม่าล่า",
    "ฟาสต์ฟู้ด"
  ];

  List<String> imageTypefood = [
    'images/food.jpg', // 'ไม่มี',
    'images/food.jpg', // 'อาหารอีสาน',
    'images/food.jpg', // 'อาหารใต้',
    'images/food.jpg', // 'อาหารเหนือ',
    'images/food.jpg', // 'อาหารเส้น',
    'images/food.jpg', // 'อาหารสุขภาพ',
    'images/food.jpg', // 'อาหารตามสั่ง',
    'images/food.jpg', // 'อาหารทะเล',
    'images/food.jpg', // 'ของทอด',
    'images/food.jpg', // 'ชา/กาแฟ',
    'images/food.jpg', // 'ชาบู/สุกี้',
    'images/food.jpg', // 'ชานมไข่มุก',
    'images/food.jpg', // 'ซูชิ',
    'images/food.jpg', // 'ของหวาน',
    'images/food.jpg', // 'ฟาสต์ฟู้ด',
    'images/food.jpg', // 'หม่าล่า',
    'images/food.jpg', // 'อาหารจานด่วน',
    'images/food.jpg', // 'โจ๊ก',
    'images/food.jpg', // 'โยเกิร์ต/ไอศกรีม',
    'images/food.jpg', // 'ปิ้งย่าง/บาร์บีคิว',
    'images/food.jpg', // 'เครื่องดื่ม/น้ำผลไม้',
    'images/food.jpg', // 'อาหารเจ',
    'images/food.jpg', // 'โรตี',
    'images/food.jpg', // 'สเต็ก',
    'images/food.jpg', // 'ของทานเล่น/ขนมขบเขี้ยว',
    'images/food.jpg', // 'ติ่มซำ',
    'images/food.jpg', // 'ยำ',
    'images/food.jpg', // 'อื่นๆ',
  ];
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
    SortByDate();
    readData();
    readFollowUser();
    readBookMarkFood();
    _getUserDataFromDatabase();
    //_getUserToDataFromDatabase();
  }

  Future<void> _refreshData() async {
    await SortByDate();
    await readData();
    await readBookMarkFood();
    await readFollowUser();
    await _getUserDataFromDatabase();

    setState(() {
      showProgressBar = false;
    });
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
    Get.to((UserProfile()));
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> readBookMarkFood() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      showProgressBar = true; // เริ่มแสดง CircularProgressIndicator
    });

    CollectionReference collectionReference =
        firestore.collection('bookmark').doc(userid).collection('bookmarkID');
    final snapshots = await collectionReference.get();

    List<dynamic> dataBookMark = [];
    String image, iduser, name;
    for (QueryDocumentSnapshot idUser in snapshots.docs) {
      QuerySnapshot comment = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot datauser in comment.docs) {
        if (idUser.id == datauser.id) {
          // print('idUser =' + idUser.id);
          // print('datauser =' + datauser.id);
          // print('BallTrue');
          // QuerySnapshot food = await firestore.collection('users').get();

          iduser = datauser['Food_id'];
          image = datauser['Food_Image'];
          name = datauser['Food_Name'];
          dataBookMark.add({'Uid': iduser, 'ImageP': image, 'Name': name});
          // dataFollows.add(image);
        }
      }
    }

    try {
      setState(() {
        followFoods = dataBookMark; // อัปเดต foodModels ด้วยรายการใหม่
        //countFollows = dataFollows;
      });
    } catch (e) {
      '';
    }
  }

  Future<void> readFollowUser() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      setState(() {
        showProgressBar = true; // เริ่มแสดง CircularProgressIndicator
      });

      CollectionReference collectionReference = firestore
          .collection('followers')
          .doc(userid)
          .collection('followersID');
      final snapshots = await collectionReference.get();

      List<String> newuserData = []; // สร้างรายการของ FoodModel ใหม่
      List<dynamic> dataFollows = [];
      String id, image, iduser, name;
      for (QueryDocumentSnapshot idUser in snapshots.docs) {
        id = idUser.id;
        newuserData.add(id);
        QuerySnapshot comment = await firestore.collection('users').get();
        for (QueryDocumentSnapshot datauser in comment.docs) {
          if (idUser.id == datauser.id) {
            // print('idUser =' + idUser.id);
            // print('datauser =' + datauser.id);
            // print('BallTrue');
            iduser = datauser['Uid'];
            image = datauser['ImageP'];
            name = datauser['Name'];
            dataFollows.add({'Uid': iduser, 'ImageP': image, 'Name': name});
            // dataFollows.add(image);
          }
        }
      }

      try {
        setState(() {
          followUser = dataFollows; // อัปเดต foodModels ด้วยรายการใหม่
          countFollows = dataFollows;
        });
      } catch (e) {
        '';
      }
    } catch (e) {
      print('พบปัญหาโดย $e');
    }
  }

  Future<void> SortByDate() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      showProgressBar = true; // เริ่มแสดง CircularProgressIndicator
    });

    CollectionReference collectionReference = firestore.collection('Foods');
    final snapshots =
        await collectionReference.orderBy('Time', descending: true).get();

    List<FoodModel> newFoodModels = []; // สร้างรายการของ FoodModel ใหม่

    for (var snapshot in snapshots.docs) {
      FoodModel foodModel =
          FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
      foodModel.food_id = snapshot.id;

      newFoodModels.add(foodModel); // เพิ่ม FoodModel เข้าในรายการใหม่
    }

    try {
      setState(() {
        SortfoodModels = newFoodModels; // อัปเดต foodModels ด้วยรายการใหม่
      });
    } catch (e) {
      '';
    }
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
      showProgressBar = true; // เริ่มแสดง CircularProgressIndicator
    });

    CollectionReference collectionReference = firestore.collection('Foods');
    final snapshots =
        await collectionReference.orderBy('Food_Point', descending: true).get();

    List<FoodModel> newFoodModels = []; // สร้างรายการของ FoodModel ใหม่

    for (var snapshot in snapshots.docs) {
      FoodModel foodModel =
          FoodModel.fromMap(snapshot.data() as Map<String, dynamic>);
      foodModel.food_id = snapshot.id;

      newFoodModels.add(foodModel); // เพิ่ม FoodModel เข้าในรายการใหม่
    }
    try {
      setState(() {
        foodModels = newFoodModels; // อัปเดต foodModels ด้วยรายการใหม่
      });
    } catch (e) {
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
      onPressed: () {
        AuthenticationController().signOut();
      },
      child: const Text('ออกจากระบบ'),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Material(
        child: RefreshIndicator(
      onRefresh: () => _refreshData(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 145, 0),
                Color.fromARGB(255, 255, 253, 249),
                const Color.fromARGB(255, 255, 255, 255)
              ],
              stops: [0.1, 0.5, 0.9],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "ยินดีต้อนรับ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(134, 255, 255, 255),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 255, 182, 134),
                              ),
                              Text(
                                " คุณ $name",
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                textWidthBasis: TextWidthBasis.longestLine,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 0, 0, 0),
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
                          const PopupMenuItem(
                            child: Text('โปรไฟล์'),
                            value: 1,
                          ),
                          const PopupMenuItem(
                            child: Text('ออกจากระบบ'),
                            value: 2,
                          )
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            onMenuProffile();
                          } else if (value == 2) {
                            signOut();
                          }
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, bottom: 25),
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage("$image"),
                                  fit: BoxFit.cover,
                                )),
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
                    onTap: () {
                      Get.to(SearchFoodStream());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.black45,
                            ),
                            Text(
                              "ค้นหาอาหาร",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: typefood.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(detailTypefood(),
                                arguments: typefood[index]);
                          },
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.only(left: 15),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 0, 0),
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
                                  imageTypefood[index],
                                  height: 50,
                                  width: 50,
                                ),
                                //Icon(Icons.food_bank),
                                Text(
                                  typefood[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                ),

                                //Text(typefood[index]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              /////////////////////////////////////////////////////////////Follower
              SizedBox(
                height: 30,
              ),
              TitleCustomWithMore(icon: Icons.group, text: "คนที่กดติดตาม"),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: followUser.length,
                  itemBuilder: (BuildContext context, int index) {
                    String iduser = followUser[index]['Uid'];
                    String image = followUser[index]['ImageP'];
                    String name = followUser[index]['Name'];

                    return InkWell(
                      onTap: () {
                        // เมื่อคลิกที่รูปภาพ
                        Get.to(UserLinkProfile(), arguments: iduser);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ProfilePicture(
                                      imageXFile: imageXFile, image: image)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              ///////////////////////////////แนะนำ
              TitleCustomWithMore(icon: Icons.star, text: "เมนูแนะนำ!"),
              SizedBox(
                height: 20,
              ),
              CarouseSlide(
                foodModels: foodModels,
                ownername: '$uname',
                height: 200,
              ),
              SizedBox(
                height: 25,
              ),
              TitleCustomWithMore(
                  icon: Icons.star_border_purple500_rounded, text: "เมนูใหม่"),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: SortfoodModels.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(children: <Widget>[
                        ShowFoodCard(
                            image: SortfoodModels[index].food_image,
                            title: SortfoodModels[index].food_name,
                            owner: SortfoodModels[index].user_id,
                            rating:
                                double.parse(SortfoodModels[index].food_point),
                            press: () {
                              Get.to(DetailFood(),
                                  arguments: SortfoodModels[index].food_id,
                                  transition: Transition.rightToLeft);
                            }),
                      ]),
                    );
                  },
                ),
              ),
              TitleCustomWithMore(icon: Icons.flag, text: "สัญชาติ"),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: nationfood.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(detailNationfood(),
                            arguments: nationfood[index]);
                      },
                      child: Container(
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
                              imagenationfood[index],
                              height: 80,
                              width: 80,
                            ),

                            Text(nationfood[index]),

                            //Text(typefood[index]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TitleCustomWithMore(
                  icon: Icons.face_rounded, text: "ระดับความยากง่าย"),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: levelfood.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 15),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            //'assets/0star.jpg',
                            imagelevelfood[index],
                            height: 80,
                            width: 80,
                          ),

                          TextButton(
                            onPressed: () {
                              print('Yes I does');
                              print(levelfood[index]);
                              Get.to(detailLevelfood(),
                                  arguments: levelfood[index]);
                            },
                            child: Text(levelfood[index]),
                          ),
                          //Text(typefood[index]),
                        ],
                      ),
                    );
                  },
                ),
              ),

              TitleCustomWithMore(
                  icon: Icons.bookmark, text: "อาหารที่กดติดตาม"),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: followFoods.length,
                  itemBuilder: (BuildContext context, int index) {
                    String idfood = followFoods[index]['Uid'];
                    String image = followFoods[index]['ImageP'];
                    String name = followFoods[index]['Name'];
                    String ratingf = followFoods[index]['Name'];

                    return InkWell(
                      onTap: () {
                        // เมื่อคลิกที่รูปภาพ
                        Get.to(DetailFood(), arguments: idfood);
                      },
                      child: Container(
                        width: 150,
                        child: Column(
                          children: <Widget>[
                            // Image.network(
                            //   image,
                            //   width: 100,
                            //   height: 100,
                            //   fit: BoxFit.cover,
                            // ),
                            ShowFoodCard(
                                image: image,
                                title: SortfoodModels[index].food_name,
                                owner: SortfoodModels[index].user_id,
                                rating: double.parse('0.0'),
                                press: () {
                                  Get.to(DetailFood(),
                                      arguments: idfood,
                                      transition: Transition.rightToLeft);
                                }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

////////////////////////////////Widget Part////////////////////////
class CarouseSlide extends StatelessWidget {
  const CarouseSlide({
    Key? key,
    required this.foodModels,
    required this.ownername,
    required this.height,
  }) : super(key: key);

  final List<FoodModel> foodModels;
  final String ownername;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          enableInfiniteScroll: true,
          autoPlay: true,
        ),
        items: foodModels.map((foodModel) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset.infinite,
                        blurRadius: 10,
                        spreadRadius: 10,
                      )
                    ]),
                    padding: const EdgeInsets.only(right: 10),
                    child: SlideFoodCard(
                      image: foodModel.food_image,
                      title: foodModel.food_name,
                      owner: foodModel.user_id,
                      rating: foodModel.food_point,
                      press: () {
                        Get.to(DetailFood(),
                            arguments: foodModel.food_id,
                            transition: Transition.rightToLeft);
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
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodModel.food_name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 240, 179, 11),
                              ),
                              Text(
                                foodModel.food_point,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
