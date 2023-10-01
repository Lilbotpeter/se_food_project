// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';
import 'AdminService.dart';

class UserReport extends StatefulWidget {
  const UserReport({super.key});

  @override
  State<UserReport> createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  bool isLoading = true;
  List<dynamic> UserReportList = [];

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
      List<dynamic> reportList =
          await AdminService().fetchReportUserData('UserReport');
      UserReportList = reportList;
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
              itemCount:
                  UserReportList.length, // Replace with the actual data length
              itemBuilder: (context, index) {
                // Replace yourFirestoreData[index] with the actual data structure
                final reportData = UserReportList[index];

                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'ไอดีผู้ใช้ที่ถูกรายงาน : ${reportData['ID_User']}',
                                style: TextStyle(fontSize: 10),
                                maxLines: 5),
                            Text('หัวข้อรายงาน : ${reportData['Report']}',
                                style: TextStyle(fontSize: 10), maxLines: 5),
                            Text('รายละเอียด : ${reportData['Detail']}',
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
                            print(reportData['ID_Report']);
                            final docker = FirebaseFirestore.instance
                                .collection('UserReport')
                                .doc(reportData['ID_Report']);

                            try {
                              await docker.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('ลบข้อมูลเรียบร้อยแล้ว')),
                              );
                              setState(() {
                                reportData.removeAt(index);
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
                            // Implement view user data functionality
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
                            // Implement delete user functionality
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('User Report'),
  //     ),
  //     body: SafeArea(
  //       child: Center(
  //         child: Card(
  //           child: Column(
  //             children: <Widget>[
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text('หัวข้อรายงาน: '),
  //                               Text('รายละเอียด: '),
  //                               Text('ไอดีที่ถูกรายงาน: '),
  //                             ],
  //                           ),
  //                           ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               primary: Colors.redAccent,
  //                               textStyle: TextStyle(
  //                                 fontSize: 15,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             onPressed: () async {
  //                               fetchReportData();
  //                             },
  //                             child: Text('ลบข้อมูลรายงาน'),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               primary: Colors.blueAccent,
  //                               textStyle: TextStyle(
  //                                 fontSize: 15,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             onPressed: () async {},
  //                             child: Text('ดูข้อมูลผู้ใช้'),
  //                           ),
  //                           ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               primary: Colors.redAccent,
  //                               textStyle: TextStyle(
  //                                 fontSize: 15,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             onPressed: () async {},
  //                             child: Text('ลบข้อมูลผู้ใช้'),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   )
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   // return Scaffold(
  //   //   appBar: AppBar(
  //   //     title: Text('User Report'),
  //   //   ),
  //   //   //     body: ListView.builder(
  //   //   //   itemCount: dataUser.length,
  //   //   //   itemBuilder: (BuildContext context, int index) {

  //   //   //   Map<String, dynamic> data = dataUser[index];
  //   //   //   return Container(
  //   //   //     padding: EdgeInsets.all(8),
  //   //   //     decoration: BoxDecoration(
  //   //   //       border: Border.all(
  //   //   //         color: Colors.grey,
  //   //   //         width: 0.0,
  //   //   //       ),
  //   //   //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
  //   //   //     ),
  //   //   //     child: Column(
  //   //   //       crossAxisAlignment: CrossAxisAlignment.start,
  //   //   //       children: [

  //   //   //         listTile(data: data, fun: () {
  //   //   //           AwesomeDialog(
  //   //   //             context: context,
  //   //   //             dialogType: DialogType.info,
  //   //   //             animType: AnimType.topSlide,
  //   //   //             showCloseIcon: true,
  //   //   //             title: 'Report',
  //   //   //             body: Column(
  //   //   //               children: [

  //   //   //                 Text('Comment : ' + data['Comment']),
  //   //   //                 Text(data['ID_Mod']),
  //   //   //               ],
  //   //   //             ),
  //   //   //             btnOkOnPress: () {
  //   //   //               Get.snackbar('title', 'message');
  //   //   //             },
  //   //   //             btnCancelOnPress: () {},
  //   //   //           ).show();
  //   //   //         }),
  //   //   //       ],
  //   //   //     ),
  //   //   //   );
  //   //   // }
  //   //   //   )
  //   // );
  // }
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
