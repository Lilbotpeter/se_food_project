// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';
import '../Edit/edit_Service.dart';
import '../Screen/Profile/user_link_profile.dart';
import '../Screen/Profile/user_profile.dart';
import 'AdminService.dart';

class UserReport extends StatefulWidget {
  const UserReport({super.key});

  @override
  State<UserReport> createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  bool isLoading = true;
  List<dynamic> UserReportList = [];
  List<dynamic> FoodReportList = [];
  List<String> imageUrls = [];

  @override
  void initState() {
    isLoading = false;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();

    fetchUserReportData();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      onPressed: () {
        signOut();
      },
      child: const Text('ออกจากระบบ'),
    );
  }

  Future<void> fetchUserReportData() async {
    try {
      List<dynamic> reportUserList =
          await AdminService().fetchReportUserData('UserReport');
      UserReportList = reportUserList;

      List<dynamic> reportFoodList =
          await AdminService().fetchReportFoodData('FoodReport');
      FoodReportList = reportFoodList;

      setState(() {
        // dataUser = reviewList;
        // isLoading = false;
      });
      //print(reportList);
    } catch (e) {
      print('Error in fetchReportData: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการรายงานผู้ใช้'),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            child: ListView.builder(
              itemCount: UserReportList.length,
              // FoodReportList.length, // Replace with the actual data length
              itemBuilder: (context, index) {
                final reportUserData = UserReportList[index];
                //final reportfoodData = FoodReportList[index];

                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'ไอดีผู้ใช้ที่ถูกรายงาน : ${reportUserData['ID_User']}',
                                style: TextStyle(fontSize: 10),
                                maxLines: 5),
                            Text('หัวข้อรายงาน : ${reportUserData['Report']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                            Text('รายละเอียด : ${reportUserData['Detail']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            textStyle: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('ยืนยันการลบข้อมูล'),
                                  content: Text(
                                      'คุณแน่ใจหรือไม่ที่ต้องการลบข้อมูลนี้?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // ปิดไดอล็อก
                                      },
                                      child: Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        print(reportUserData['ID_Report']);
                                        final docker = FirebaseFirestore
                                            .instance
                                            .collection('UserReport')
                                            .doc(reportUserData['ID_Report']);

                                        try {
                                          await docker.delete();
                                          Navigator.of(context)
                                              .pop(); // ปิดไดอล็อกหลังจากลบเสร็จ
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('ลบข้อมูลเรียบร้อยแล้ว'),
                                            ),
                                          );
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserReport(),
                                            ),
                                          );
                                          setState(() {
                                            reportUserData.removeAt(index);
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'เกิดข้อผิดพลาดในการลบข้อมูล'),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text('ยืนยันการลบ'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('ลบข้อมูลรายงาน'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            print('ID_User = ');
                            print(reportUserData['ID_User']);
                            Get.to(UserLinkProfile(),
                                arguments: reportUserData['ID_User']);
                          },
                          child: Text('ดูข้อมูลผู้ใช้'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            // แสดงไดอล็อกยืนยันการลบผู้ใช้
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('ยืนยันการลบผู้ใช้'),
                                  content: Text(
                                      'คุณแน่ใจหรือไม่ที่ต้องการลบผู้ใช้นี้?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Get.snackbar('ลบข้อมูลผู้ใช้',
                                            'ลบข้อมูลผู้ใช้ไม่สำเร็จ');
                                      },
                                      child: Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        print(reportUserData['ID_Report']);
                                        final docker = FirebaseFirestore
                                            .instance
                                            .collection('UserReport')
                                            .doc(reportUserData['ID_Report']);

                                        try {
                                          await docker.delete();
                                          Navigator.of(context)
                                              .pop(); // ปิดไดอล็อกหลังจากลบเสร็จ
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('ลบข้อมูลเรียบร้อยแล้ว'),
                                            ),
                                          );
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserReport(),
                                            ),
                                          );
                                          setState(() {
                                            reportUserData.removeAt(index);
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'เกิดข้อผิดพลาดในการลบข้อมูล'),
                                            ),
                                          );
                                        }
                                        final deleteUserdata = EditService();
                                        deleteUserdata.DeleteReplyMod(
                                            reportUserData['ID_User']);
                                        deleteUserdata.DeleteReplyReview(
                                            reportUserData['ID_User']);
                                        deleteUserdata.DeleteReplyCommentData(
                                            reportUserData['ID_User']);
                                        deleteUserdata.DeleteCommentData(
                                            reportUserData['ID_User']);
                                        deleteUserdata.DeleteModData(
                                            reportUserData['ID_User']);
                                        deleteUserdata.DeleteReviewData(
                                            reportUserData['ID_User']);
                                        deleteUserdata.DeleteFood(
                                            reportUserData['ID_User']);
                                        deleteUserdata.DeleteUser(
                                            reportUserData['ID_User']);

                                        Navigator.of(context).pop();
                                        Get.snackbar('ลบข้อมูลผู้ใช้',
                                            'ลบข้อมูลผู้ใช้สำเร็จ');
                                        signOut();
                                      },
                                      child: Text('ยืนยันการลบ'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('ลบข้อมูลผู้ใช้'),
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

class CardSkale extends StatelessWidget {
  const CardSkale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Skale(
          height: 20,
          width: 100,
        ),
        Skale(
          height: 20,
          width: 30,
        ),
      ],
    );
  }
}

class Skale extends StatelessWidget {
  const Skale({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

class listTile extends StatelessWidget {
  const listTile({
    Key? key,
    required this.data,
    required this.fun,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final Function fun;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data['Comment']),
      subtitle: Text('Test'),
      trailing: IconButton(
        icon: Icon(Icons.arrow_right_rounded),
        onPressed: () {
          fun();
        },
      ),
    );
  }
}
