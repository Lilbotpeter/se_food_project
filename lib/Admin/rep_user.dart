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
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            print(reportUserData['ID_Report']);
                            final docker = FirebaseFirestore.instance
                                .collection('UserReport')
                                .doc(reportUserData['ID_Report']);

                            try {
                              await docker.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('ลบข้อมูลเรียบร้อยแล้ว')),
                              );
                              setState(() {
                                reportUserData.removeAt(index);
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('เกิดข้อผิดพลาดในการลบข้อมูล')),
                              );
                            }
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
                            print(reportUserData['ID_User']);
                            final user = FirebaseAuth.instance.currentUser;
                            try {
                              // print('user = ');
                              // print(reportUserData['ID_User']);
                              // await reportUserData['ID_User'].delete();
                              print("User deleted successfully");
                            } catch (e) {
                              print("Error deleting user: $e");
                            }

                            // //ลบข้อมูลผู้ใช้
                            // final deleteDataUser = FirebaseFirestore.instance
                            //     .collection('users')
                            //     .doc(reportUserData['ID_User']);

                            // //ลบข้อมูลผู้ใช้
                            // final deleteReportUser = FirebaseFirestore.instance
                            //     .collection('UserReport')
                            //     .doc(reportUserData['ID_User']);

                            FirebaseStorage storage = FirebaseStorage.instance;
                            final deleteStorageUser = await storage
                                .ref()
                                .child('Profile Picture')
                                .child(reportUserData['ID_User']);
                            String fullPath = deleteStorageUser.fullPath;
                            List<String> pathSegments = fullPath.split('/');
                            String fileName = pathSegments.last;
                            print('Downloaded File Name: $fileName');

                            // for (Reference ref in result.items) {
                            //   String imageURL = await ref.getDownloadURL();
                            //   print('Downloaded URL: $imageURL');
                            // }
                            try {
                              //   for (final deleteStorageUser in result.items) {
                              // print('deleteStorageUser = ');
                              // print(result);
                              //     // ลบแต่ละไฟล์

                              //   }

                              //await deleteStorageUser.delete();
                              // await deleteDataUser.delete();
                              // await deleteReportUser.delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('ลบข้อมูลเรียบร้อยแล้ว')),
                              );
                              setState(() {
                                // reportUserData.removeAt(index);
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('เกิดข้อผิดพลาดในการลบข้อมูล')),
                              );
                            }
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
