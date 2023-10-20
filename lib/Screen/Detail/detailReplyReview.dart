import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';
import '../../Widgets/profile_picture.dart';
import '../../service.dart';
import '../Profile/user_link_profile.dart';

class ReplyReviewFood extends StatefulWidget {
  const ReplyReviewFood({super.key});

  @override
  State<ReplyReviewFood> createState() => _ReplyReviewFoodState();
}

class _ReplyReviewFoodState extends State<ReplyReviewFood> {
  List<dynamic> FoodReplyReviewList = [];
  final String getfoodID = Get.arguments as String;
  DataService dataService = DataService();
  File? imageXFile;

  @override
  void initState() {
    super.initState();
    fetchReplyReviewData();
  }

  
  Future<String> getname(userid)async{
    Map<String, dynamic> userData = await dataService.getUser(userid);
    String udata = userData['Name'];
    return udata;
  }

    Future<String> getprofile(userid)async{
    Map<String, dynamic> userData = await dataService.getUser(userid);
    String udata = userData['ImageP'];
    return udata;
  }

  Future<void> fetchReplyReviewData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore
          .collection('ReplyReview')
          .doc(getfoodID)
          .collection('ReplyReviewID')
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;
        String Snapidx = snapID;

        DocumentSnapshot docFirestoreDoc = await firestore
            .collection('ReplyReview')
            .doc(getfoodID)
            .collection('ReplyReviewID')
            .doc(Snapidx)
            .get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> modData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          FoodReplyReviewList.add({
            'ID_Review': modData['ID_Review'],
            'ID_ReplyReview': modData['ID_ReplyReview'],
            'Comment': modData['Comment'],
            'Time': modData['Time'],
            'Uid': modData['Uid'],
          });
        }
      }

      setState(() {}); // อัปเดตหน้าเมื่อข้อมูลถูกดึงมา
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text('ตอบกลับ',style: TextStyle(color: Colors.white),),
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
        
      ),
      body: SafeArea(
        child: Center(

          child: Card(
            color: Color.fromARGB(255, 0, 0, 0),
            child: ListView.builder(
              itemCount: FoodReplyReviewList.length,
              itemBuilder: (context, index) {
                final replyReviewData = FoodReplyReviewList[index];

                return Expanded(
                  child: Container(
                    
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        border: Border.all(width: 5)),
                    child: Column(
                      
                      children: <Widget>[
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<String>(
                                          future: getprofile(replyReviewData['Uid']), // เรียกใช้ getname โดยส่ง modifyData['Uid']
                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              // การดำเนินการเมื่อ Future สมบูรณ์
                                              String userName = snapshot.data ?? 'ไม่พบชื่อ'; // ดึงค่าจาก snapshot.data
                                              return Padding(
                                                padding: const EdgeInsets.only(left:2.0),
                                                child: InkWell(
                                                  onTap: (){
                                                    Get.to(UserLinkProfile(),
                                                      arguments: replyReviewData['Uid']);
                                                  },
                                                  child: SizedBox(
                                                height: 50,
                                                width: 80,
                                                child: ProfilePicture(
                                                    imageXFile: imageXFile,
                                                    image: userName))
                                                ),
                                              ); // แสดงชื่อผู้ใช้
                                            } else if (snapshot.hasError) {
                                              return Text('เกิดข้อผิดพลาดในการดึงข้อมูล');
                                            } else {
                                              // การดำเนินการในระหว่างรอ Future
                                              return CircularProgressIndicator(); // หรือ Widget แสดงการโหลด
                                            }
                                          },
                                        ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //     'ไอดีคอมเม้นอาหาร : ${replyReviewData['ID_Review']}',
                                //     style: TextStyle(fontSize: 10),
                                //     maxLines: 5),
                                FutureBuilder<String>(
                                          future: getname(replyReviewData['Uid']), // เรียกใช้ getname โดยส่ง modifyData['Uid']
                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              // การดำเนินการเมื่อ Future สมบูรณ์
                                              String userName = snapshot.data ?? 'ไม่พบชื่อ'; // ดึงค่าจาก snapshot.data
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: (){
                                                    Get.to(UserLinkProfile(),
                                                      arguments: replyReviewData['Uid']);
                                                  },
                                                  child: Text(userName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                                                                          maxLines: 5),
                                                ),
                                              ); // แสดงชื่อผู้ใช้
                                            } else if (snapshot.hasError) {
                                              return Text('เกิดข้อผิดพลาดในการดึงข้อมูล');
                                            } else {
                                              // การดำเนินการในระหว่างรอ Future
                                              return CircularProgressIndicator(); // หรือ Widget แสดงการโหลด
                                            }
                                          },
                                        ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                                    child: Text(
                                      ' ${replyReviewData['Comment']}',
                                      style: TextStyle(fontSize: 20),
                                      maxLines: 5,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify, // จัดวางข้อความให้อยู่ในครอบขอบและใช้เว้นระยะแบบ spacebar
                                    ),
                                  )


                                // Text(
                                //     'ไอดีรีไพ : ${replyReviewData['ID_ReplyReview']}',
                                //     style: TextStyle(fontSize: 10),
                                //     maxLines: 5),
                                // Text('ไอดีผู้ใช้ : ${replyReviewData['Uid']}',
                                //     style: TextStyle(fontSize: 10), maxLines: 5),
                                
                              ],
                              
                            ),
                            
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
