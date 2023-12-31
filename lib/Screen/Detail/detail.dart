import 'dart:io';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Screen/Profile/user_link_profile.dart';
import 'package:se_project_food/Widgets/button_widget.dart';
import 'package:se_project_food/Widgets/custom_icon.dart';
import 'package:se_project_food/Widgets/profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:se_project_food/constants.dart';

import '../../Models/foodmodels.dart';
import '../../follow.dart';
import '../../global.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({super.key});

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  //Food
  List<FoodModel> foodModels = [];
  final followerService = FollowerService();
  List<String> imageUrls = [];
  List<String> videoUrls = [];

  late String getIDbook;

  String? name_food = '';
  String? description_food = '';
  String? level_food = '';
  String? ingradent_food = '';
  String? nation_food = '';
  String? point_food = '';
  String? time_food = '';
  String? type_food = '';
  String? solution_food, image_food = '';
  String? id_food = '';
  String? user_id;
  //User
  String? name = '';
  String? image = '';
  String? email = '';
  String? phone = '';
  File? imageXFile;
  final TextEditingController SenWork = TextEditingController();
  final TextEditingController Review = TextEditingController();
  int _rating = 0;

  final String getfoodID = Get.arguments as String; //รับ Food ID

  final userid = FirebaseAuth.instance.currentUser!.uid;

  void _setRating(int value) {
    //setState(() {
    _rating = value;
    //});
  }

  Future<void> _getDataFromDatabase() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();

    if (snapshot.exists) {
      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          name_food = data["Food_Name"];
          description_food = data["Food_Description"];
          level_food = data["Food_Level"];
          ingradent_food = data["Food_Ingredients"];
          solution_food = data["Food_Solution"];
          nation_food = data["Food_Nation"];
          point_food = data["Food_Point"];
          time_food = data["Food_Time"];
          type_food = data["Food_Type"];
          image_food = data["Food_Image"];
          id_food = data['Food_id'];
          user_id = data["User_id"]; // อัปเดตค่า user_id ด้วยข้อมูลใน Firestore
        });
        await _getUserDataFromDatabase(user_id);
      }
    }
  }

//เอาข้อมูลผู้ใช้ออกมา
  Future<void> _getUserDataFromDatabase(String? id) async {
    if (id != null) {
      try {
        final snapshot =
            await FirebaseFirestore.instance.collection("users").doc(id).get();

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
  }

  //get images storage
  Future<void> _getImagesFromStorage(String? id) async {
    try {
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      // ดึงรายการรูปภาพจากโฟลเดอร์ "Image" ในโฟลเดอร์ที่มีชื่อเป็น id
      final firebase_storage.ListResult result = await storage
          .ref()
          .child('files')
          .child('$id')
          .child('Image')
          .listAll();

      // ตรวจสอบว่ามีรูปภาพในโฟลเดอร์ "Image" หรือไม่
      if (result.items.isNotEmpty) {
        for (var imageRef in result.items) {
          // ดึง URL ของรูปภาพและเพิ่มในรายการ imageUrls
          final imageUrl = await imageRef.getDownloadURL();
          setState(() {
            imageUrls.add(imageUrl);
            print('$imageUrl');
          });
        }
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการดึงรูปภาพ: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    _getUserDataFromDatabase(user_id);
    _getImagesFromStorage(id_food);
    followerService.getBookmarkID(userid, getfoodID).then((bookmarkID) {
      setState(() {
        getIDbook = bookmarkID;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Follower
    File? imageXFile;

    //ตัวรับ Parameter
    return Scaffold(
        backgroundColor: Color.fromARGB(239, 255, 255, 255),
        //Floating Menu
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            //Menu Home Work
            SpeedDialChild(
                child: Icon(Icons.menu_book_outlined),
                label: 'ส่งการบ้าน',
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: Container(
                            child: ListView(
                              children: <Widget>[
                                ButtonWidget(
                                    //Button Select file
                                    icon: Icons.attach_file,
                                    text: 'เลือกไฟล์',
                                    onClick: () {
                                      print('Fuck you ');
                                    }),
                                Text('ความคิดเห็นเกี่ยวกับการปรับสูตร'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextField(
                                  controller: SenWork,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText:
                                        'กรอกความคิดเห็นเกี่ยวกับการปรับสูตร',
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      print('Success');
                                    },
                                    child: const Text('ส่ง')),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
            //Menu Comment
            SpeedDialChild(
                child: Icon(Icons.comment),
                label: 'คอมเม้นท์',
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: ListView(
                            children: <Widget>[
                              Text('ความคิดเห็นเกี่ยวกับการคอมเม้น'),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextField(
                                controller: Review,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText:
                                      'กรอกความคิดเห็นเกี่ยวกับการคอมเม้น',
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextButton(
                                  onPressed: () async {
                                    print('Success');
                                  },
                                  child: const Text('ส่ง')),
                            ],
                          ),
                          //   child: ElevatedButton(
                          //     child: Text('Close'),
                          //     onPressed: () {
                          //       Get.snackbar('title', 'message');
                          //     },
                          //   ),
                        ),
                      );
                    },
                  );
                }),
            //Menu Review
            SpeedDialChild(
                child: Icon(Icons.reviews),
                label: 'รีวิว',
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: Center(
                            child: ListView(
                              children: <Widget>[
                                Text(
                                  'ให้คะแนน',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 1; i <= 5; i++)
                                      GestureDetector(
                                        onTapDown: (_) =>
                                            setState(() => _rating = i),
                                        child: Icon(
                                          Icons.star,
                                          size: 40,
                                          color: i <= _rating
                                              ? Colors.orange
                                              : Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  _rating > 0
                                      ? 'You gave $_rating stars!'
                                      : 'Please rate us.',
                                  style: TextStyle(fontSize: 18),
                                ),
                                ButtonWidget(
                                    //Button Select file
                                    icon: Icons.attach_file,
                                    text: 'เลือกไฟล์',
                                    onClick: () {
                                      print('Fuck you ');
                                    }),
                                Text('ความคิดเห็นเกี่ยวกับการรีวิว'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextField(
                                  controller: Review,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText:
                                        'กรอกความคิดเห็นเกี่ยวกับการรีวิว',
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      print('Success');
                                    },
                                    child: const Text('ส่ง')),
                              ],
                            ),
                            //   child: ElevatedButton(
                            //     child: Text('Close'),
                            //     onPressed: () {
                            //       Get.snackbar('title', 'message');
                            //     },
                            //   ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ],
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        //Tab view เด้อจ้าาา
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
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
              bottom: const TabBar(
                indicatorColor: Color.fromARGB(255, 0, 0, 0),
                labelColor: Color.fromARGB(255, 255, 255, 255),
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(Icons.notes_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.menu_book_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.comment),
                  ),
                  Tab(
                    icon: Icon(Icons.reviews),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.white38,
            body: TabBarView(
//Detail Tab**
              children: [
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                              //   image: DecorationImage( //ทำให้ภาพออกแบบไม่ค้าง
                              //   image: NetworkImage(image_food ?? ''),
                              //   fit: BoxFit.cover,
                              // ),
                            ),

                            //Slide
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: AnotherCarousel(
                                    images: [
                                      NetworkImage(image_food ?? ''),
                                    ],
                                    dotSize: 4,
                                    indicatorBgPadding: 5.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 40),
                          child: Row(
                            children: [
//Bookmark Button
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(35)),
                                child: IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      isBookmarked = !isBookmarked;
                                    });
                                    isBookmarked
                                        ? await followerService.addBookmark(
                                            userid, getfoodID)
                                        : await followerService.unBookmark(
                                            userid, getfoodID);
                                  },
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_outline,
                                    color: isBookmarked
                                        ? Colors.amber
                                        : Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Stack(
                          children: <Widget>[
                            //Name Card
                            cardDetail(
                              title: name_food,
                              subtitle: type_food,
                              rating: point_food,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20.0, 110, 20, 5),
                                height: 90,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                //Profile User
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                              height: 70,
                                              width: 100,
                                              child: ProfilePicture(
                                                  imageXFile: imageXFile,
                                                  image: image))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      ////////////Card Profile
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, top: 10),
                                            child: Text(
                                              '$name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 9,
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: 100,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Color.fromARGB(
                                                            255,
                                                            255,
                                                            156,
                                                            7)), // สีพื้นหลังเมื่อปุ่มไม่ได้ถูกกด
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(Colors
                                                            .white), // สีของข้อความ
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsetsGeometry>(
                                                  EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical:
                                                          1), // การขยับของข้อความภายในปุ่ม
                                                ),
                                                textStyle: MaterialStateProperty
                                                    .all<TextStyle>(
                                                  TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ), // สไตล์ข้อความ
                                              ),
                                              onPressed: () {
                                                // ตรวจสอบโค้ดเมื่อปุ่มถูกกด
                                                Get.to(UserLinkProfile(),
                                                    arguments: user_id);
                                              },
                                              child: Text('ดูโปรไฟล์'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Time Card
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(250.0, 110, 20, 5),
                                height: 90,
                                width: 120,
                                decoration: BoxDecoration(
                                  gradient: kgradeint,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$time_food",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      "นาที",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Detail
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.fromLTRB(20.0, 215, 20, 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'รายละเอียด',
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                //Description
                                                ExpansionTile(
                                                  title: const Text(
                                                    'วิธีการทำ',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  trailing: Icon(
                                                    isExpanded
                                                        ? Icons.arrow_drop_up
                                                        : Icons.arrow_drop_down,
                                                    color: Colors.amber,
                                                  ),
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                          description_food ??
                                                              ''),
                                                    ),
                                                  ],
                                                  onExpansionChanged:
                                                      (bool expanded) {
                                                    setState(() =>
                                                        isExpanded = expanded);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Text(''),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ], //แปะได้
                        ),
                      ),
                    ),
                  ],
                ),
//Home Work Tab
                Container(
                  color: Colors.amber,
                ),
//Comment Tab
                Container(
                  color: Colors.red,
                ),
//Review Tab
                Container(
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ));
  }
}

class cardDetail extends StatelessWidget {
  const cardDetail({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rating,
  });

  final String? title;
  final String? subtitle;
  final String? rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 5, 20, 5),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$title',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color.fromARGB(255, 255, 136, 0)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$rating   ',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '$subtitle',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
        ),
      ),
    );
  }
}

// CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 125,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.network(image_food?? '',
//               fit: BoxFit.cover,
//               ),
//             ),
//             leading: CircleAvatar(
//               backgroundColor: Colors.white,
//               //child: SvgPicture.asset(""),
//             ),
//           ),
//         ]
//       ),

// Padding(
//             padding: const EdgeInsets.only(right: 300,top: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 25),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               name_food?? '',
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 24.0,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                             //Bookmark Button
//                             //IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border)),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//           ),