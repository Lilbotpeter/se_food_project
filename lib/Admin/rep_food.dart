// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Screen/Detail/detail_service.dart';
import '../Screen/Detail/detail.dart';
import 'AdminService.dart';

class FoodReport extends StatefulWidget {
  const FoodReport({super.key});

  @override
  State<FoodReport> createState() => _FoodReportReportState();
}

class _FoodReportReportState extends State<FoodReport> {
  bool isLoading = true;
  List<dynamic> FoodReportList = [];

  @override
  void initState() {
    isLoading = false;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();

    fetchFoodReportData();
  }

  Future<void> fetchFoodReportData() async {
    try {
      if (mounted) {
        List<dynamic> reportList =
            await AdminService().fetchReportFoodData('FoodReport');
        FoodReportList = reportList;
        setState(() {
          // dataUser = reviewList;
          // isLoading = false;
        });
      }
      //print(reportList);
    } catch (e) {
      print('Error in fetchReportData: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการรายงานอาหาร'),
      ),
      body: SafeArea(
        child: Center(
          child: Card(
            child: ListView.builder(
              itemCount:
                  FoodReportList.length, // Replace with the actual data length
              itemBuilder: (context, index) {
                // Replace yourFirestoreData[index] with the actual data structure
                final reportData = FoodReportList[index];

                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'ไอดีอาหารที่ถูกรายงาน : ${reportData['ID_Food']}',
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
                                .collection('FoodReport')
                                .doc(reportData['ID_Report']);

                            try {
                              await docker.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('ลบข้อมูลเรียบร้อยแล้ว')),
                              );
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => FoodReport()));
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
                            Get.to(DetailFood(),
                                arguments: reportData['ID_Food'],
                                transition: Transition.rightToLeft);
                          },
                          child: Text('ดูข้อมูลอาหาร'),
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
                          child: Text('ลบข้อมูลอาหาร'),
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
