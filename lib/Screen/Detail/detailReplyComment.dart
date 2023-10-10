import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';

class ReplyCommentFood extends StatefulWidget {
  const ReplyCommentFood({super.key});

  @override
  State<ReplyCommentFood> createState() => _ReplyCommentFoodState();
}

class _ReplyCommentFoodState extends State<ReplyCommentFood> {
  List<dynamic> FoodReplyCommentList = [];
  final String getfoodID = Get.arguments as String;

  @override
  void initState() {
    super.initState();
    fetchReplyCommentData();
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
      appBar: AppBar(
        title: Text('ตอบกลับ2'),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            child: ListView.builder(
              itemCount: FoodReplyCommentList.length,
              itemBuilder: (context, index) {
                final replyCommentData = FoodReplyCommentList[index];

                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'ไอดีคอมเม้นอาหาร : ${replyCommentData['ID_Comment']}',
                                style: TextStyle(fontSize: 10),
                                maxLines: 5),
                            Text('รายละเอียด : ${replyCommentData['Comment']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                            Text(
                                'ไอดีรีไพ : ${replyCommentData['ID_ReplyComment']}',
                                style: TextStyle(fontSize: 10),
                                maxLines: 5),
                            Text('ไอดีผู้ใช้ : ${replyCommentData['Uid']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
