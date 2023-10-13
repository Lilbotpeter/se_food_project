import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import '../../Api/firebase_api.dart';
import '../../Models/foodmodels.dart';
import '../../Models/user.dart' as usermodel;
import '../../Widgets/button_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Feed/feed_page.dart';

class UploadFood extends StatefulWidget {
  const UploadFood({Key? key}) : super(key: key);

  @override
  State<UploadFood> createState() => _UploadFoodState();
}

class _UploadFoodState extends State<UploadFood> {
  UploadTask? task;
//final User? user = AuthenticationController().currentUser;
  User? user = AuthenticationController().currentUser;
  //Rx<User?> _currentUser;

  File? file; //file can null
  PlatformFile? pickedFile;
  String? food_id;
  String? urlDownload,
      food_name = '',
      food_video,
      food_level = '',
      food_ingredients = '',
      food_solution = '',
      food_type = '',
      food_description = '',
      food_time = '',
      food_nation = '',
      food_point = '';

  //Current UID
  Widget _userUID() {
    return Text(user?.uid ?? 'User UID');
  }

  List<File> files = []; // List เก็บรูปภาพที่ถูกเลือก

  Future<void> selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // เปลี่ยนเป็น true เพื่อให้เลือกหลายไฟล์
      );

      if (result == null) return;

      setState(() {
        files = result.paths
            .map((path) => File(path!))
            .toList(); // แปลงรายการเป็นรายการของ File
      });
    } catch (e) {
      print('Error selecting files: $e');
      // ทำการจัดการกับข้อผิดพลาดที่เกิดขึ้น ตามที่คุณต้องการ
      // เช่น แสดงข้อความแจ้งเตือนหรือบันทึกล็อกข้อผิดพลาดไว้เพื่อตรวจสอบในภายหลัง
    }
  }

  bool _isImageFile(String filename) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    urlDownload = extension(filename).toLowerCase();
    return imageExtensions.contains(urlDownload);
  }

  bool _isVideoFile(String filename) {
    final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv'];
    food_video = extension(filename).toLowerCase();
    return videoExtensions.contains(food_video);
  }

  Future<void> uploadFile() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore.collection("Foods").doc();

    // Check if files are not selected
    if (files.isEmpty) {
      print("No files selected");
      return;
    }
    try {
      Map<String, dynamic> dataMap = {
        'Food_id': foodDocRef.id,
        'Food_Name': food_name!.isNotEmpty ? food_name : 'N/A',
        'Food_Level': food_level!.isNotEmpty ? food_level : 'ไม่มี',
        'Food_Ingredients':
            food_ingredients!.isNotEmpty ? food_ingredients : 'N/A',
        'Food_Solution': food_solution!.isNotEmpty ? food_solution : 'N/A',
        'Food_Type': food_type!.isNotEmpty ? food_type : 'ไม่มี',
        'Food_Description':
            food_description!.isNotEmpty ? food_description : 'N/A',
        'Food_Time': food_time!.isNotEmpty ? food_time : 'N/A',
        'Food_Nation': food_nation!.isNotEmpty ? food_nation : 'ไม่มี',
        'Food_Point': food_point!.isNotEmpty ? food_point : 'N/A',
        'User_id': user?.uid,
      };
      //String? profileImage;
      // Loop through the selected files and upload them
      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        final filename = basename(file.path);

        bool isImage = _isImageFile(filename);
        bool isVideo = _isVideoFile(filename);

        if (isImage || isVideo) {
          final String mediaType = isImage ? 'Image' : 'Video';
          final destination = 'files/${foodDocRef.id}/$mediaType/$filename';
          task = FirebaseApi.uploadFile(destination, file);

          if (task == null) continue;

          final snapshot2 = await task!.whenComplete(() {});
          final downloadURL = await snapshot2.ref.getDownloadURL();

          // if (i == 0) {
          //   profileImage = downloadURL;
          // }

          if (isImage) {
            dataMap['Food_Image'] = downloadURL;
            //profileImage = null;
          } else {
            dataMap['Food_Video'] = downloadURL;
          }
        } else {
          // Handle other types of files (if necessary)
        }
      }
      //try {
      await foodDocRef.set(dataMap);
      //setState(() {
      files.clear();
      //});
      print("Upload complete");
    } catch (e) {
      print("Error: $e");
    }
  }

  Widget name(context) {
    return TextField(
      onChanged: (value) {
        food_name = value.toString();
      },
      decoration: InputDecoration(
        labelText: 'ชื่ออาหาร',
        hintText: 'กรุณากรอกชื่ออาหาร',
        //icon: Icon(Icons.format_align_center),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        isDense: true,                      // Added this
        contentPadding: EdgeInsets.all(8),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget level(context) {
    String foodLevel = 'ไม่มี'; // กำหนดค่าเริ่มต้น

    return DropdownButtonFormField<String>(
      value: foodLevel,
      onChanged: (value) {
        //setState(() {
        foodLevel = value.toString();
        food_level = foodLevel;
        //});
      },
      decoration: InputDecoration(
        labelText: 'ความยากในการทำ',
        hintText: 'กรุณาเลือกความยากในการทำ',
        //icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        isDense: true,                      // Added this
        contentPadding: EdgeInsets.all(8),
      ),
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ไม่มี',
          child: Text('ไม่มี'),
        ),
        DropdownMenuItem<String>(
          value: 'ง่าย',
          child: Text('ง่าย'),
        ),
        DropdownMenuItem<String>(
          value: 'ปานกลาง',
          child: Text('ปานกลาง'),
        ),
        DropdownMenuItem<String>(
          value: 'ยาก',
          child: Text('ยาก'),
        ),
      ],
    );
  }

  Widget ingredients(context) {
    final maxLines = 5;

    return Container(
      height: maxLines * 24.0,

      child: TextField(
        onChanged: (value) {
          food_ingredients = value.trim();
        },
        decoration: InputDecoration(
          labelText: 'วัตถุดิบ',
          hintText: 'กรุณากรอกวัตถุดิบ',
          //icon: Icon(Icons.dinner_dining),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          isDense: true,                      // Added this
          contentPadding: EdgeInsets.all(8),
        ),
        
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

//
  Widget solution(context) {
    final maxLines = 5;
    return Container(

      height: maxLines * 24.0,
      
      child: TextField(
          onChanged: (value) {
            food_solution = value.trim();
          },
          decoration: InputDecoration(
            labelText: 'วิธีการทำ',
            hintText: 'กรุณากรอกวิธีการทำ',
            //icon: Icon(Icons.solar_power_outlined),
            border:
                OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
            focusedBorder:
                OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
            enabledBorder:
                OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
            filled: true,
            isDense: true,                      // Added this
          contentPadding: EdgeInsets.all(8),
          ),
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,),
    );
  }

  Widget type(context) {
    String foodtype = 'ไม่มี'; // กำหนดค่าเริ่มต้น

    return Container(
      width: 400,
      child: DropdownButtonFormField<String>(
        value: foodtype,
        onChanged: (value) {
          //setState(() {
          foodtype = value.toString();
          food_type = foodtype;
          //});
        },
        decoration: InputDecoration(
          labelText: 'ประเภทอาหาร',
          hintText: 'กรุณาเลือกประเภทอาหาร',
          //icon: Icon(Icons.point_of_sale),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          isDense: true,                      // Added this
          contentPadding: EdgeInsets.all(8),
        ),
        items: const <DropdownMenuItem<String>>[
          DropdownMenuItem<String>(
            value: 'ไม่มี',
            child: Text('ไม่มี'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารอีสาน',
            child: Text('อาหารอีสาน'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารใต้',
            child: Text('อาหารใต้'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารเหนือ',
            child: Text('อาหารเหนือ'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารเส้น',
            child: Text('อาหารเส้น'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารสุขภาพ',
            child: Text('อาหารสุขภาพ'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารตามสั่ง',
            child: Text('อาหารตามสั่ง'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารทะเล',
            child: Text('อาหารทะเล'),
          ),
          DropdownMenuItem<String>(
            value: 'แฮมเบอเกอร์',
            child: Text('แฮมเบอเกอร์'),
          ),
          DropdownMenuItem<String>(
            value: 'ของทอด',
            child: Text('ของทอด'),
          ),
          DropdownMenuItem<String>(
            value: 'ชา/กาแฟ',
            child: Text('ชา/กาแฟ'),
          ),
          DropdownMenuItem<String>(
            value: 'ชาบู/สุกี้',
            child: Text('ชาบู/สุกี้'),
          ),
          DropdownMenuItem<String>(
            value: 'ชานมไข่มุก',
            child: Text('ชานมไข่มุก'),
          ),
          DropdownMenuItem<String>(
            value: 'ซูชิ',
            child: Text('ซูชิ'),
          ),
          DropdownMenuItem<String>(
            value: 'ของหวาน',
            child: Text('ของหวาน'),
          ),
          DropdownMenuItem<String>(
            value: 'เบเกอรี่',
            child: Text('เบเกอรี่'),
          ),
          DropdownMenuItem<String>(
            value: 'เบรคฟาสต์',
            child: Text('เบรคฟาสต์'),
          ),
          DropdownMenuItem<String>(
            value: 'เค้ก',
            child: Text('เค้ก'),
          ),
          DropdownMenuItem<String>(
            value: 'เครื่องดื่ม',
            child: Text('เครื่องดื่ม'),
          ),
          DropdownMenuItem<String>(
            value: 'ฟาสต์ฟู้ด',
            child: Text('ฟาสต์ฟู้ด'),
          ),
          DropdownMenuItem<String>(
            value: 'หม่าล่า',
            child: Text('หม่าล่า'),
          ),
          DropdownMenuItem<String>(
            value: 'ของหวาน',
            child: Text('ของหวาน'),
          ),
          //--------------------------------
          DropdownMenuItem<String>(
            value: 'น้ำผลไม้',
            child: Text('น้ำผลไม้'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารจานด่วน',
            child: Text('อาหารจานด่วน'),
          ),
          DropdownMenuItem<String>(
            value: 'โจ๊ก',
            child: Text('โจ๊ก'),
          ),
          DropdownMenuItem<String>(
            value: 'โยเกิร์ต/ไอศกรีม',
            child: Text('โยเกิร์ต/ไอศกรีม'),
          ),
          DropdownMenuItem<String>(
            value: 'ปิ้งย่าง/บาร์บีคิว',
            child: Text('ปิ้งย่าง/บาร์บีคิว'),
            //--------------------------------
          ),
          DropdownMenuItem<String>(
            value: 'เครื่องดื่ม/น้ำผลไม้',
            child: Text('เครื่องดื่ม/น้ำผลไม้'),
          ),
          DropdownMenuItem<String>(
            value: 'อาหารเจ',
            child: Text('อาหารเจ'),
          ),
          DropdownMenuItem<String>(
            value: 'โรตี',
            child: Text('โรตี'),
          ),
          DropdownMenuItem<String>(
            value: 'สเต็ก',
            child: Text('สเต็ก'),
          ),
          DropdownMenuItem<String>(
            value: 'ส้มตำ',
            child: Text('ส้มตำ'),
          ),
          DropdownMenuItem<String>(
            value: 'ของทานเล่น/ขนมขบเขี้ยว',
            child: Text('ของทานเล่น/ขนมขบเขี้ยว'),
          ),
          DropdownMenuItem<String>(
            value: 'ติ่มซำ',
            child: Text('ติ่มซำ'),
          ),
          DropdownMenuItem<String>(
            value: 'ยำ',
            child: Text('ยำ'),
          ),
        ],
      ),
    );
  }

  Widget description(context) {
    final maxLines = 5;

    return Container(
      // margin: EdgeInsets.all(),
      height: maxLines * 24.0,
      child: TextField(
          onChanged: (value) {
            food_description = value.trim();
          },
          decoration: InputDecoration(
            labelText: 'รายละเอียดอาหาร',
            hintText: 'กรุณากรอกรายละเอียดอาหาร',
            // icon: Icon(Icons.description),
            border:
                OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
            focusedBorder:
                OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
            enabledBorder:
                OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
            filled: true,
            isDense: true,                      // Added this
          contentPadding: EdgeInsets.all(8),
          ),
          maxLines: maxLines,
      keyboardType: TextInputType.multiline,),
    );
  }

  Widget time(context) {
    return TextField(
        onChanged: (value) {
          food_time = value.trim();
        },
        decoration: InputDecoration(
          labelText: 'เวลาในการทำ',
          hintText: 'กรุณากรอกเวลาในการทำ',
          // icon: Icon(Icons.description),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          isDense: true, 
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: TextInputType.text);
  }

  Widget nation(context) {
    String foodnation = 'ไม่มี'; // กำหนดค่าเริ่มต้น

    return DropdownButtonFormField<String>(
      value: foodnation,
      onChanged: (value) {
        //setState(() {
        foodnation = value.toString();
        food_nation = foodnation;
        //});
      },
      decoration: InputDecoration(
        labelText: 'สัญชาติ',
        hintText: 'กรุณาเลือกสัญชาติ',
        // icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        isDense: true, 
        contentPadding: const EdgeInsets.all(8),
      ),
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ไม่มี',
          child: Text('ไม่มี'),
        ),
        DropdownMenuItem<String>(
          value: 'ไทย',
          child: Text('ไทย'),
        ),
        DropdownMenuItem<String>(
          value: 'ญี่ปุ่น',
          child: Text('ญี่ปุ่น'),
        ),
        DropdownMenuItem<String>(
          value: 'เกาหลี',
          child: Text('เกาหลี'),
        ),
        DropdownMenuItem<String>(
          value: 'อิตาลี',
          child: Text('อิตาลี'),
        ),
      ],
    );
  }
////////////////////////////////////////////////
  Widget point(context) {
    return TextField(
        onChanged: (value) {
          food_point = value.trim();
        },
        decoration: InputDecoration(
          labelText: 'คะแนนอาหาร',
          hintText: 'กรุณากรอกคะแนนอาหาร',
          icon: Icon(Icons.description),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: TextInputType.text);
  }

  Widget showForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Text('ชื่ออาหาร'),
            name(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('เลเวล'),
            level(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('วัตถุดิบ'),
            ingredients(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('วิธีทำ'),
            solution(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('ประเภทอาหาร'),
            type(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('รายละเอียด'),
            description(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('เวลาในการทำ'),
            time(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('สัญชาติอาหาร'),
            nation(context),
            SizedBox(
              height: 10.0,
            ),
            point(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filename = file != null
        ? basename(file!.path)
        : 'ยังไม่มีไฟล์ที่เลือก!'; //set basename
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upload Food'),
      //   centerTitle: true,
      //   ),

      body: Container(
        padding: EdgeInsets.all(32),
        child: Container(

            child: ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.amber,
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(
              height: 15.0,
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 50,bottom:5),
              child:  Text('อัพโหลดสูตรของคุณ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 30,bottom: 25),
              child:  Text('กรอกรายละเอียดได้เลย !',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.amber),),
            ),
            ButtonWidget(
                //Button Select file
                icon: Icons.attach_file,
                text: 'เลือกรูปภาพหรือวิดีโอ',
                onClick: selectFile),

            //Under filename for "Spacebar naja"
            const SizedBox(
              height: 15.0,
            ),
            showForm(context),
            const SizedBox(
              height: 15.0,
            ),
            ButtonWidget(
                //Button Upload file
                icon: Icons.upload_file_sharp,
                text: 'อัพโหลดสูตร',
                onClick: uploadFile),

            //task != null ? buildUploadStatus(task!) : Container() //Percent
          ],
        )),
      ),
    );
  }
}

Widget _buildTextField() {
  final maxLines = 5;

  return Container(
    margin: EdgeInsets.all(12),
    height: maxLines * 24.0,
    child: TextField(
      
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(filled: true, hintText: 'Enter a message'),
    ),
  );
}
