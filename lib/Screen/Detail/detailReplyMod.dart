import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';

class ReplyModFood extends StatefulWidget {
  const ReplyModFood({super.key});

  @override
  State<ReplyModFood> createState() => _ReplyModFoodState();
}

class _ReplyModFoodState extends State<ReplyModFood> {
  List<dynamic> FoodReplyModList = [];
  final String getfoodID = Get.arguments as String;

  @override
  void initState() {
    super.initState();
    fetchReplyModifyData();
  }

  Future<void> fetchReplyModifyData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> modDataList = [];

      QuerySnapshot querySnapshot = await firestore
          .collection('ReplyMod')
          .doc(getfoodID)
          .collection('ReplyModID')
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;
        String Snapidx = snapID;

        DocumentSnapshot docFirestoreDoc = await firestore
            .collection('ReplyMod')
            .doc(getfoodID)
            .collection('ReplyModID')
            .doc(Snapidx)
            .get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> modData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          FoodReplyModList.add({
            'ID_ReplyMod': modData['ID_ReplyMod'],
            'ID_Mod': modData['ID_Mod'],
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
        title: Text('ตอบกลับ'),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            child: ListView.builder(
              itemCount: FoodReplyModList.length,
              itemBuilder: (context, index) {
                final replyModData = FoodReplyModList[index];

                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ไอดีคอมเม้นอาหาร : ${replyModData['ID_Mod']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                            Text('รายละเอียด : ${replyModData['Comment']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                            Text('ไอดีรีไพ : ${replyModData['ID_ReplyMod']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                            Text('ไอดีผู้ใช้ : ${replyModData['Uid']}',
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
