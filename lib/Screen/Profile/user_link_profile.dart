import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Detail/detail.dart';
import 'package:se_project_food/Screen/Detail/detail_step.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:se_project_food/Authen/authen_part.dart';

import '../../Models/foodmodels.dart';
import '../../Widgets/appbar_custom.dart';
import '../../Widgets/profile_picture.dart';
import '../../constants.dart';
import '../../follow.dart';
import '../../global.dart';

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
  List<dynamic> followUser = [];
  List<dynamic> countFollows = [];
  int countfollow = 0;
  int countbookmark = 0;

  List<FoodModel> foodModels = []; //List Model Food
  final userid = FirebaseAuth.instance.currentUser!.uid;
  final String getUserID = Get.arguments as String;
  final followerService = FollowerService();

  String? UsertypeReport = 'ใช้คำพูดที่ไม่เหมาะสม';
  TextEditingController Userdetail = TextEditingController();

  Future<void> _refreshData() async {
  // ทำอะไรก็ตามที่คุณต้องการในการรีเฟรชข้อมูล
  await _getUserFromDatabase(); // รีเฟรชข้อมูลผู้ใช้
  await readData(); // รีเฟรชข้อมูลอาหาร
  await bookmark(); // รีเฟรชข้อมูลบุ๊คมาร์ค
  await follow(); // รีเฟรชข้อมูลผู้ติดตาม

  // รายงานการสิ้นสุดของการรีเฟรช
  setState(() {
    showProgressBar = false; // หยุดแสดง CircularProgressIndiciator
  });
}


  Future<void> _getUserFromDatabase() async {
    try{
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(getUserID)
        .get();

    if (snapshot.exists) {
      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          name = data["Name"];
          image = data["ImageP"];
          email = data["Email"];
          phone = data["Phone"];
        });
      }
    }
    }catch(e){'$e';}
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
  Future follow() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('followers')
        .doc(getUserID)
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
        .doc(getUserID)
        .collection('bookmarkID')
        .get();
    countbookmark = querySnapshot.size;
    // for (QueryDocumentSnapshot countFollow in querySnapshot.docs) {
    //   countfollow = countFollow.id
    // }
  }

  Future<void> readFollowUser() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      showProgressBar = true; // เริ่มแสดง CircularProgressIndicator
    });

    CollectionReference collectionReference =
        firestore.collection('followers').doc(userid).collection('followersID');
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
          print('idUser =' + idUser.id);
          print('datauser =' + datauser.id);
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

    // await clearData();
    // await readData();
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    //_getDataFromDatabase();
    _getUserFromDatabase();
    readData();
    bookmark();
    follow();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    Widget buildFoodItem(int index) {
      return GestureDetector(
        onTap: () {
          //Get.snackbar(foodModels[index].food_name, foodModels[index].user_id);
          Get.to(DetailFood(),
              arguments: foodModels[index].food_id); // ตัวส่ง Parameter
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
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshData(),
          child: SingleChildScrollView(
            child: Stack(
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
                        height: 20,
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
                        height: 3,
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
                      
                      Icon(Icons.phone,size: 20,color: Colors.black38,),
                      SizedBox(width: 5,),
                       Text(
                        phone ?? '',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45),
                      ),
                    ],
                  ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // await followerService.addFollower(userid, getUserID);
                              // Get.snackbar('แจ้งเตือน', 'ติดตามผู้ใช้แล้ว');
                              Get.to(DetailStep());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                              child: Text(
                                "ติดตาม",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kTextColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
          
                          //Report User Button
                          IconButton(
                            onPressed: () {
                              print('Hello Report ');
                              //ใส่ ฟังชันรีพอร์ตตรงนี้นะจ้ะ
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.red,
                                    title: Center(
                                        child: Column(
                                      children: [
                                        Icon(Icons.warning_amber_outlined,
                                            color:
                                                Color.fromARGB(255, 255, 255, 255),
                                            size: 75),
                                        Text(
                                          'รายงานผู้ใช้',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'หัวข้อการรายงาน',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 14),
                                          ),
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: UsertypeReport,
                                          onChanged: (value) {
                                            //setState(() {
                                            UsertypeReport = value.toString();
                                            //});
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide:
                                                    Divider.createBorderSide(
                                                        context)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                    Divider.createBorderSide(
                                                        context)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide:
                                                    Divider.createBorderSide(
                                                        context)),
                                            filled: true,
                                            contentPadding: const EdgeInsets.all(8),
                                          ),
                                          items: const <DropdownMenuItem<String>>[
                                            DropdownMenuItem<String>(
                                              value: 'ใช้คำพูดที่ไม่เหมาะสม',
                                              child: Text('ใช้คำพูดที่ไม่เหมาะสม'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value:
                                                  'โพสต์สิ่งที่ไม่เกี่ยวกับอาหาร',
                                              child: Text(
                                                  'โพสต์สิ่งที่ไม่เกี่ยวกับอาหาร'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: 'ใช้รูปที่ไม่เหมาะสม',
                                              child: Text('ใช้รูปที่ไม่เหมาะสม'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: 'ให้ข้อมูลเท็จ',
                                              child: Text('ให้ข้อมูลเท็จ'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: 'อื่นๆ',
                                              child: Text('อื่นๆ'),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'หมายเหตุ',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  255, 253, 253, 253),
                                            ),
                                            cursorColor: Colors.white,
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0)),
                                            maxLines: 4,
                                            controller: Userdetail,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Center(
                                        child: Column(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .black, // background (button) color
                                                foregroundColor: Colors
                                                    .white, // foreground (text) color
                                              ),
                                              child: Text('ส่งรายงาน'),
                                              onPressed: () async {
                                                // ทำอะไรก็ตามที่คุณต้องการเมื่อผู้ใช้ส่งรายงาน
                                                FirebaseFirestore firestore =
                                                    FirebaseFirestore.instance;
                                                final DocumentReference foodReport =
                                                    firestore
                                                        .collection("UserReport")
                                                        .doc();
          
                                                try {
                                                  Map<String, dynamic> dataMap = {
                                                    'Report': UsertypeReport,
                                                    'Detail': Userdetail.text,
                                                    'Time': Timestamp.now(),
                                                    'ID_User': getUserID,
                                                    'ID_Report': foodReport.id
                                                  };
          
                                                  await foodReport.set(dataMap);
                                                  Userdetail.clear();
                                                  Get.snackbar('รายงานผู้ใช้',
                                                      'รายงานผู้ใช้สำเร็จ');
                                                } catch (e) {
                                                  print("Error: $e");
                                                  Get.snackbar('รายงานผู้ใช้',
                                                      'รายงานผู้ใช้ไม่สำเร็จ');
                                                }
          
                                                print('getUserID = ');
                                                print(getUserID);
          
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .black, // background (button) color
                                                foregroundColor: Colors
                                                    .white, // foreground (text) color
                                              ),
                                              child: Text('ยกเลิก'),
                                              onPressed: () {
                                                // ปิด Dialog
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.report_problem,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                String? encodeQueryParameters(
                                    Map<String, String> params) {
                                  return params.entries
                                      .map((MapEntry<String, String> e) =>
                                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                      .join('&');
                                }
          
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path: email,
                                  query: encodeQueryParameters(<String, String>{
                                    'subject': 'ผู้ใช้ต้องการติดต่อ',
                                    'body':
                                        'มีการติดต่อจากผู้ใช้มาหาคุณ โปรดติดต่อกลับ',
                                  }),
                                );
          
                                if (await canLaunchUrl(emailUri)) {
                                  launchUrl(emailUri);
                                } else {
                                  throw Exception('ไม่สามารถติดต่อ $emailUri');
                                }
                              },
                              icon: Icon(Icons.mail))
                        ],
                      ),
                      const SizedBox(height: 5),
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
                const Divider(
                  height: 660,
                  thickness: 2,
                  color: Colors.black12,
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
            ),
          ),
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
