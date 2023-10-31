import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import '../../Api/firebase_api.dart';
import '../Upload/upload_page.dart';

class DetailStep extends StatefulWidget {
  const DetailStep({super.key});

  @override
  State<DetailStep> createState() => _DetailStepState();
}

class _DetailStepState extends State<DetailStep> {
  UploadTask? task;
  List<TextEditingController> controllers = [TextEditingController()];
  List<TextEditingController> descontrollers = [TextEditingController()];

  final userid = FirebaseAuth.instance.currentUser!.uid;
  File? file; //file can null
  PlatformFile? pickedFile;
  String? name_food = '';
  String? description_food = '';
  String? level_food = '';
  String? ingradent_food = '';
  String? nation_food = '';
  String? point_food = '';
  String? time_food = '';
  String? type_food = '';
  String? solution_food, image_food = '';
  String? food_id;

  //String? id_food = 'BGMhIue66VsFLJvP8LOd';
  final String getfoodID = Get.arguments as String; //รับ Food ID
  String? video_url, video_title = '', video_des = '', step = '';

  String uploadStatus = '';
  bool uploading = false;
  List<File> files = []; // List เก็บรูปภาพที่ถูกเลือก
  //final String getfoodID = Get.arguments as String; //รับ Food ID

  void updateUploadStatus(String status) {
    setState(() {
      uploadStatus = status;
    });
  }

  bool _isVideoFile(String filename) {
    final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv'];
    video_url = extension(filename).toLowerCase();
    return videoExtensions.contains(video_url);
  }

  Future<void> uploadFileStep() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore
        .collection("StepFoodDetail")
        .doc(getfoodID)
        .collection("StepID")
        .doc(step); // ใช้ค่า step ในการตรวจสอบ

    final docSnapshot = await foodDocRef.get();
    if (docSnapshot.exists) {
      // ถ้าข้อมูลใน Firebase Firestore มีอยู่แล้ว ให้ปฏิเสธการอัปโหลด
      Get.snackbar('แจ้งเตือน', 'ไม่สามารถอัพโหลดได้ มีขั้นตอนนี้อยู่แล้ว');
      print('ขั้นตอนนี้มีอยู่แล้ว');
      return;
    }

    // ถ้าข้อมูลยังไม่มีอยู่ใน Firebase Firestore ให้ดำเนินการอัปโหลด
    try {
      Map<String, dynamic> dataMap = {
        'food_id': getfoodID,
        'step': step,
        'title': video_title,
        'time': Timestamp.now(),
        'video_url': video_url,
        'description': video_des,
      };
      await foodDocRef.set(dataMap);
      print("อัปโหลดสำเร็จ");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> uploadFile() async {
    setState(() {
      uploading = true; // เริ่มแสดงหลอดการอัปโหลด
    });
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // final DocumentReference foodDocRef = firestore.collection("Foods").doc();

    if (files.isEmpty) {
      setState(() {
        uploading = false; // หยุดแสดงหลอดการอัปโหลด
      });
      print("No files selected");
      Get.snackbar('อัปโหลดไม่สำเร็จ', 'ตรวจสอบข้อมูลให้ถูกต้อง');
      return;
    }
    bool hasVideo = false;

    try {
      // Map<String, dynamic> dataMap = {
      //   'Food_id': foodDocRef.id,
      // };

      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        final filename = basename(file.path);

        bool isVideo = _isVideoFile(filename);

        if (isVideo) {
          hasVideo = true;
        }

        final String mediaType = 'Video';
        // final destination = 'StepDetail/$getfoodID/$mediaType/$step';
        final destination = 'StepDetail/$getfoodID/$mediaType/$step';
        Reference storageReference = FirebaseStorage.instance.ref(destination);
        await storageReference.putFile(file);
        //task = FirebaseApi.uploadFile(destination, file);

        if (task == null) continue;

        final snapshot2 = await task!.whenComplete(() {});
        final downloadURL = await snapshot2.ref.getDownloadURL();

        // if (isVideo) {
        //   dataMap['Food_Image'] = downloadURL;
        // } else {
        //   dataMap['Food_Video'] = downloadURL;
        // }
      }

      if (hasVideo) {
        // await foodDocRef.set(dataMap);
        files.clear();
        // dataMap.clear();
        setState(() {
          uploading = false; // หยุดแสดงหลอดการอัปโหลด
        });
        Get.snackbar('ข้อมูลการอัปโหลด', 'อัปโหลดสำเร็จ');
        print("Upload complete");
        Navigator.of(context as BuildContext).pushReplacement(
          MaterialPageRoute(builder: (context) => UploadFood()),
        );
      } else {
        setState(() {
          uploading = false; // หยุดแสดงหลอดการอัปโหลด
        });
        updateUploadStatus('เกิดข้อผิดพลาดในการอัปโหลด');
        Get.snackbar('โปรดอัปโหลดวิดิโอ', 'อัปโหลดไม่สำเร็จ ');
        files.clear();
        //dataMap.clear();
      }
    } catch (e) {
      setState(() {
        uploading = false; // หยุดแสดงหลอดการอัปโหลด
      });
      updateUploadStatus('เกิดข้อผิดพลาดในการอัปโหลด');
      print("Error: $e");
    }
  }

  Future<void> selectVideoFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.video, // กรองไฟล์ให้เลือกได้แค่วิดีโอ
      );

      if (result == null) return;

      setState(() {
        files = result.paths.map((path) => File(path!)).toList();
      });
    } catch (e) {
      print('Error selecting video files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มวิดีโอขั้นตอน'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.check,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: ListView.builder(
        itemCount: controllers.length,
        itemBuilder: (context, index) {
          List<bool> isDisabled = List.filled(controllers.length, false);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 230, 230, 230)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ขั้นตอนที่ ${index + 1}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      selectVideoFile();
                    },
                    icon: Icon(Icons.add_box),
                  ),
                  Text('เพิ่มวิดีโอ'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllers[index],
                      enabled: !isDisabled[index],
                      decoration: InputDecoration(
                          labelText: 'หัวข้อ ',
                          border: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descontrollers[index],
                      enabled: !isDisabled[index],
                      decoration: InputDecoration(
                          hintText: 'รายละเอียด ',
                          border: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(8),
                          filled: true,
                          fillColor: Colors.white),
                      maxLines: 5,
                      // decoration:
                      //                                             InputDecoration(
                      //                                           filled: true,
                      //                                           fillColor: const Color
                      //                                                   .fromARGB(
                      //                                               255,
                      //                                               253,
                      //                                               253,
                      //                                               253),
                      //                                           border: OutlineInputBorder(
                      //                                               borderRadius:
                      //                                                   BorderRadius
                      //                                                       .circular(
                      //                                                           20)),
                      //                                           hintText:
                      //                                               'ตอบกลับคอมเม้น', // ใช้ hintText เป็นคำแนะนำ
                      //                                           floatingLabelBehavior:
                      //                                               FloatingLabelBehavior
                      //                                                   .never,
                      //                                         ),
                      //                                         maxLines: 5,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: uploading == false && !isDisabled[index]
                          ? () async {
                              video_title = controllers[index].text;
                              video_des = descontrollers[index].text;
                  
                              step = '${index + 1}';
                              uploadFile();
                              uploadFileStep();
                              setState(() {
                                isDisabled[index] = true;
                              });
                            }
                          : null,

                          
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      backgroundColor: uploading == false && !isDisabled[index]
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 50,
        child: FloatingActionButton.small(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: controllers.length < 10
              ? () {
                  // เพิ่ม TextEditingController ใหม่และรีโรลด้านล่างของ ListView
                  setState(() {
                    controllers.add(TextEditingController());
                    descontrollers.add(TextEditingController());
                  });
                }
              : null,
          child: Column(
            children: [
              const Icon(Icons.add),
              Text('เพิ่มขั้นตอน')
            ],
          ),
        ),
      ),
    );
  }
}
