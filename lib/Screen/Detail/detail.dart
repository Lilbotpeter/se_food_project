import 'dart:io';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Screen/Profile/user_link_profile.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
import 'package:se_project_food/Widgets/custom_icon.dart';
import 'package:se_project_food/Widgets/follow_button.dart';
import 'package:se_project_food/Widgets/profile_picture.dart';

import '../../Models/foodmodels.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({super.key});

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  //Food
  List<FoodModel> foodModels = [];
  String? name_food = '';
  String? description_food = '';
  String? level_food = '';
  String? ingradent_food = '';
  String? nation_food = '';
  String? point_food = '';
  String? time_food = '';
  String? type_food = '';
  String? solution_food,image_food= '';
  String? user_id;
  //User
  String? name = '';
  String? image = '';
  String? email = '';
  String? phone = '';
  File? imageXFile;

  final String getfoodID = Get.arguments as String; //รับ Food ID

   final userid = FirebaseAuth.instance.currentUser!.uid;





 Future<void> _getDataFromDatabase() async {
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
    .collection("Foods")
    .doc(getfoodID)
    .get();
        
  if (snapshot.exists) {
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

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
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
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
}

    @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
    _getUserDataFromDatabase(user_id);
  }
  @override
  Widget build(BuildContext context) {
    //Follower
    File? imageXFile;

     //ตัวรับ Parameter
    return Scaffold(
      backgroundColor: Color.fromARGB(239, 255, 255, 255),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0,2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                //   image: DecorationImage( //ทำให้ภาพออกแบบไม่ค้าง
                //   image: NetworkImage(image_food ?? ''),
                //   fit: BoxFit.cover,
                // ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width,
                      width: double.infinity,
                      child: AnotherCarousel(images: [
                        NetworkImage(image_food ?? ''),
                      ],
                      dotSize: 4,
                      indicatorBgPadding: 5.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 40),
                child: Row(
                  children: <Widget>[
                    CustomIconButton(icon: Icon(Icons.arrow_back), press: (){
                      Get.back();
                    }),
                    
                  ],
                ),
              ),
            ],
          ),
          
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: <Widget>[
                    cardDetail(title: name_food, subtitle: type_food,rating: point_food,),
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
                                child: ProfilePicture(imageXFile: imageXFile, image: image))
                            ],
                          ),
                        ),
                        Padding(////////////Card Profile
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                            Padding(
                              padding: const EdgeInsets.only(left:20.0,top: 10),
                              child: Text('$name',style: TextStyle(fontWeight: FontWeight.w600),),
                            ),
                            SizedBox(height: 9,),
                            SizedBox(
                              height: 30,
                              width: 100,
                              child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 156, 7)), // สีพื้นหลังเมื่อปุ่มไม่ได้ถูกกด
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // สีของข้อความ
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 25, vertical: 1), // การขยับของข้อความภายในปุ่ม
                            ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ), // สไตล์ข้อความ
                            ),
                            onPressed: () {
                              // ตรวจสอบโค้ดเมื่อปุ่มถูกกด
                              Get.to(UserLinkProfile(), arguments: user_id);
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
                          color: const Color.fromARGB(255, 252, 158, 19),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("$time_food",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.white),),
                            Text("นาที",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                            
                          ],
                        ),
                        ),
                    ),
                //Detail
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20.0, 215, 20, 5),
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      ),
                    child:  Padding(
                      padding:  EdgeInsets.all(10.0),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                    Text('รายละเอียด', 
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),),
                        SizedBox(width: 5,),
                        Text('$description_food',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                        ),
                        
                    ),
                                  ],
                                ),
                                Text(''),
                                const SizedBox(height: 10,),
                      ]),
                    ),
                    ),
                  ),
                ),
                ],//แปะได้
                
              ),
            ),
          ),
          
         
        ],
        
      )
    );
  }
}

class cardDetail extends StatelessWidget {
  const cardDetail({
    super.key,
    required this.title,
    required this.subtitle, required this.rating,
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
          color: Colors.white,
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
              Text('$title', 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600
              ),),
          Row(
                children: [
                  Icon(Icons.star,color: Color.fromARGB(255, 255, 136, 0)),
                  SizedBox(width: 5,),
                  Text('$rating   ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  ),
                  ),
                ],
              ),
            ],
          ),
          Text('$subtitle'),
          const SizedBox(height: 10,),
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