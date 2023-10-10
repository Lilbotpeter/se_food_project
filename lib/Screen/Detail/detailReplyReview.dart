import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';

class ReplyReviewFood extends StatefulWidget {
  const ReplyReviewFood({super.key});

  @override
  State<ReplyReviewFood> createState() => _ReplyReviewFoodState();
}

class _ReplyReviewFoodState extends State<ReplyReviewFood> {
  List<dynamic> FoodReplyReviewList = [];
  final String getfoodID = Get.arguments as String;

  @override
  void initState() {
    super.initState();
    fetchReplyReviewData();
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
      appBar: AppBar(
        title: Text('ตอบกลับ3'),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            child: ListView.builder(
              itemCount: FoodReplyReviewList.length,
              itemBuilder: (context, index) {
                final replyReviewData = FoodReplyReviewList[index];

                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'ไอดีคอมเม้นอาหาร : ${replyReviewData['ID_Review']}',
                                style: TextStyle(fontSize: 10),
                                maxLines: 5),
                            Text('รายละเอียด : ${replyReviewData['Comment']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                            Text(
                                'ไอดีรีไพ : ${replyReviewData['ID_ReplyReview']}',
                                style: TextStyle(fontSize: 10),
                                maxLines: 5),
                            Text('ไอดีผู้ใช้ : ${replyReviewData['Uid']}',
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
