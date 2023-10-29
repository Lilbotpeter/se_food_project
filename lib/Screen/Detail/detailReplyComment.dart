import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';
import '../../service.dart';
import '../Profile/user_link_profile.dart';

class ReplyCommentFood extends StatefulWidget {
  const ReplyCommentFood({super.key});

  @override
  State<ReplyCommentFood> createState() => _ReplyCommentFoodState();
}

class _ReplyCommentFoodState extends State<ReplyCommentFood> {
  List<dynamic> FoodReplyCommentList = [];
  DataService dataService = DataService();
  final String getfoodID = Get.arguments as String;

  @override
  void initState() {
    super.initState();
    fetchReplyCommentData();
  }

  Future<String> getname(userid) async {
    Map<String, dynamic> userData = await dataService.getUser(userid);
    String udata = userData['Name'];
    return udata;
  }

  Future<void> fetchReplyCommentData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore
          .collection('ReplyComment')
          .doc(getfoodID)
          .collection('ReplyCommentID')
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;
        String Snapidx = snapID;

        DocumentSnapshot docFirestoreDoc = await firestore
            .collection('ReplyComment')
            .doc(getfoodID)
            .collection('ReplyCommentID')
            .doc(Snapidx)
            .get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> modData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          FoodReplyCommentList.add({
            'ID_Comment': modData['ID_Comment'],
            'ID_ReplyComment': modData['ID_ReplyComment'],
            'Comment': modData['Comment'],
            'Time': modData['Time'],
            'Uid': modData['Uid'],
          });
          FoodReplyCommentList.sort((a, b) => b['Time'].compareTo(a['Time']));
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
        title: Text(
          'ตอบกลับ',
          style: TextStyle(color: Colors.white),
        ),
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
            child: ListView.builder(
              itemCount: FoodReplyCommentList.length,
              itemBuilder: (context, index) {
                final replyCommentData = FoodReplyCommentList[index];

                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(width: 5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FutureBuilder<String>(
                        future: getname(replyCommentData['Uid']),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            String userName = snapshot.data ?? 'ไม่พบชื่อ';
                            return InkWell(
                              onTap: () {
                                Get.to(UserLinkProfile(),
                                    arguments: replyCommentData['Uid']);
                              },
                              child: Text(
                                userName,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                maxLines: 5,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('เกิดข้อผิดพลาดในการดึงข้อมูล');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          '${replyCommentData['Comment']}',
                          style: TextStyle(fontSize: 18),
                          maxLines: 5,
                        ),
                      ),
                      // Text(
                      //   'ไอดีรีไพ : ${replyCommentData['ID_ReplyComment']}',
                      //   style: TextStyle(fontSize: 10),
                      //   maxLines: 5,
                      // ),
                      // Text(
                      //   'ไอดีผู้ใช้ : ${replyCommentData['Uid']}',
                      //   style: TextStyle(fontSize: 10),
                      //   maxLines: 5,
                      // ),
                    ],
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
