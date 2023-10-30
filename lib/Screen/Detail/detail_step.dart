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
  String? video_url,
        video_title ='',
        video_des= '',
        step = '';

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
        .doc();
    try {
      Map<String, dynamic> dataMap = {
            'food_id': getfoodID,
            'step' : step,
            'title': video_title,
            'time': Timestamp.now(),
            'video_url': video_url,
            'description': video_des,
      };
      await foodDocRef.set(dataMap);
      print("Upload complete");
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
      Get.snackbar('โปรดอัปทั้งรูปภาพและวิดิโอ',
          'อัปโหลดไม่สำเร็จ ต้องอัปทั้งรูปภาพและวิดิโอ');
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
        Get.snackbar('โปรดอัปทั้งรูปภาพและวิดิโอ',
            'อัปโหลดไม่สำเร็จ ต้องอัปทั้งรูปภาพและวิดิโอ');
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

  // Future<void> _getDataFromDatabase() async {
  //   final DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection("Foods")
  //       .doc(getfoodID)
  //       .get();

  //   if (snapshot.exists) {
  //     final Map<String, dynamic>? data =
  //         snapshot.data() as Map<String, dynamic>?;

  //     if (data != null) {
  //       setState(() {
  //         name_food = data["Food_Name"];
  //         description_food = data["Food_Description"];
  //         level_food = data["Food_Level"];
  //         ingradent_food = data["Food_Ingredients"];
  //         solution_food = data["Food_Solution"];
  //         nation_food = data["Food_Nation"];
  //         point_food = data["Food_Point"];
  //         time_food = data["Food_Time"];
  //         type_food = data["Food_Type"];
  //         image_food = data["Food_Image"];
  //         id_food = data['Food_id'];
  //         user_id = data["User_id"]; // อัปเดตค่า user_id ด้วยข้อมูลใน Firestore
  //       });
  //       await _getUserDataFromDatabase(user_id);
  //       CalculatorService calculatorService = CalculatorService();

  //       try {
  //         await calculatorService.calRating();
  //         // ทำสิ่งที่คุณต้องการกับผลลัพธ์หลังจากการคำนวณคะแนน
  //       } catch (e) {
  //         // จัดการข้อผิดพลาดที่เกิดขึ้นหากมี
  //         print('เกิดข้อผิดพลาด: $e');
  //       }
  //     }
  //   }
  // }

  


Future<void> selectVideoFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video, // กรองไฟล์ให้เลือกได้แค่วิดีโอ
    );

    if (result == null) return;

    setState(() {
      files = result.paths
          .map((path) => File(path!))
          .toList();
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
        onTap: () {},
        child: Icon(
          Icons.check,
          size: 26.0,

        ),
      )
    ),
  ],
      ),
      body: ListView.builder(
        itemCount: controllers.length,
        itemBuilder: (context, index) {
          List<bool> isDisabled = List.filled(controllers.length, false);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ขั้นตอนที่ ${index +1}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                  IconButton(onPressed: (){
                    selectVideoFile();
                  }, icon: Icon(Icons.add_box)),
                  TextFormField(
                    controller: controllers[index],
                    enabled: !isDisabled[index],
                    decoration:  InputDecoration(
                      labelText: 'หัวข้อ ',
                    ),
                  ),
                  TextFormField(
                    controller: descontrollers[index],
                    enabled: !isDisabled[index],
                    decoration:  InputDecoration(
                      labelText: 'รายละเอียด ',
                    ),
                  ),
                  SizedBox(height: 40,),
                  FloatingActionButton(onPressed: uploading == false && !isDisabled[index] ? () async {
                    video_title = controllers[index].text;
                    video_des = descontrollers[index].text;
                    
                    step = '${index+1}';
                    uploadFile();
                    uploadFileStep();
                    setState(() {
                  isDisabled[index] = true; 
                });
                  }:null,
                  child: Icon(Icons.check,color: Colors.white,),
                  backgroundColor: uploading == false && !isDisabled[index] ? Colors.black : Colors.grey,
                  ),

                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton:  OutlinedButton(
        onPressed: controllers.length <10? () {
          // เพิ่ม TextEditingController ใหม่และรีโรลด้านล่างของ ListView
          setState(() {
            controllers.add(TextEditingController());
            descontrollers.add(TextEditingController());
          });
        }:null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
