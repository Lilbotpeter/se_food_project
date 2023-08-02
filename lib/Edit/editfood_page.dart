import 'dart:io';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Models/foodmodels.dart';
import '../Api/firebase_api.dart';

class EditFoods extends StatefulWidget {
  const EditFoods({super.key});

  @override
  State<EditFoods> createState() => _EditFoodsState();
}

class _EditFoodsState extends State<EditFoods> {
  List<FoodModel> foodModels = [];
  PlatformFile? pickedFile;
  String? edit_nation = 'ไทย';
  String? edit_level = 'ง่าย';
  String? edit_type = 'ฟาสต์ฟู้ด';
  String? imageUrl;

  final TextEditingController edit_name = TextEditingController();
  final TextEditingController edit_description = TextEditingController();
  final TextEditingController edit_ingredients = TextEditingController();

//  / final TextEditingController edit_level = TextEditingController();
// final TextEditingController edit_nation = TextEditingController();
  final TextEditingController edit_point = TextEditingController();

  final TextEditingController edit_solution = TextEditingController();
  final TextEditingController edit_time = TextEditingController();
  //final TextEditingController edit_type = TextEditingController();

  @override
  void initState() {
    super.initState();
    readData();
  }

  Widget nation(context) {
    // กำหนดค่าเริ่มต้น

    return DropdownButtonFormField<String>(
      value: edit_nation,
      onChanged: (value1) {
        //setState(() {
        edit_nation = value1.toString();
        //});
      },
      decoration: InputDecoration(
        icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      items: <DropdownMenuItem<String>>[
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

  Widget level(context) {
    return DropdownButtonFormField<String>(
      value: edit_level,
      onChanged: (value2) {
        //setState(() {
        edit_level = value2.toString();
        //});
      },
      decoration: InputDecoration(
        labelText: 'ความยากในการทำ',
        hintText: 'กรุณาเลือกความยากในการทำ',
        icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      items: <DropdownMenuItem<String>>[
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

  Widget type(context) {
    return DropdownButtonFormField<String>(
      value: edit_type,
      onChanged: (value3) {
        //setState(() {
        edit_type = value3.toString();
        //});
      },
      decoration: InputDecoration(
        icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ฟาสต์ฟู้ด',
          child: Text('ฟาสต์ฟู้ด'),
        ),
        DropdownMenuItem<String>(
          value: 'ของหวาน',
          child: Text('ของหวาน'),
        ),
        DropdownMenuItem<String>(
          value: 'เครื่องดื่ม/น้ำผลไม้',
          child: Text('เครื่องดื่ม/น้ำผลไม้'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารเจ',
          child: Text('อาหารเจ'),
        ),
      ],
    );
  }

  final String getfoodID = Get.arguments as String; //ตัวรับ

  Future<void> readData() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // ทำการเรียกข้อมูลเอกสารจาก Firebase
    DocumentSnapshot sd =
        await firestore.collection('Foods').doc(getfoodID).get();

    // ตรวจสอบว่ามีข้อมูลหรือไม่
    Map<String, dynamic>? data = sd.data() as Map<String, dynamic>?;
    if (sd.exists) {
      // ถ้ามีข้อมูลในเอกสาร คุณสามารถนำข้อมูลมาใช้ได้ตามต้องการ

      // เช่น ถ้าคุณมีค่าของ key 'name' ในเอกสาร สามารถเข้าถึงได้ดังนี้
      setState(() {
        edit_name.text = data!["Food_Name"];
        edit_level = data!['Food_Level'];
        edit_ingredients.text = data!['Food_Ingredients'];
        edit_solution.text = data!['Food_Solution'];
        edit_type = data!['Food_Type'];
        edit_description.text = data!['Food_Description'];
        edit_time.text = data!['Food_Time'];
        edit_nation = data!['Food_Nation'];
        edit_point.text = data!['Food_Point'];

        imageUrl = data!['Food_Image'];
      });

      print('Image URL: $imageUrl');
    } else {
      // ถ้าไม่มีข้อมูลในเอกสาร
      print('Document not found!');
    }
  }

  Future<void> pickImage() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // ทำการเรียกข้อมูลเอกสารจาก Firebase
    DocumentSnapshot sd =
        await firestore.collection('Foods').doc(getfoodID).get();

    // ตรวจสอบว่ามีข้อมูลหรือไม่
    Map<String, dynamic>? data = sd.data() as Map<String, dynamic>?;
    if (sd.exists) {
      foodid = data!['Food_id'];
    }
    try{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.single;
        pickedFile?.path!;

        // Upload the image to Firebase Storage
        uploadImageToFirebase();

        // Set imageUrl to null temporarily (to avoid showing the old image while the new one is uploading)
        imageUrl = null;
      });
    }
        }catch(e){
      print("");
    };

  }
  

  String? foodid;
  Future<void> uploadImageToFirebase() async {
    if (pickedFile == null) return;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files')
          .child(foodid!)
          .child('Image')
          .child(fileName);

      firebase_storage.UploadTask uploadTask =
          ref.putFile(File(pickedFile!.path!));

      firebase_storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadURL;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //_readData();
    //readData();

    return Scaffold(
      body: ListView(children: <Widget>[
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                width: double.infinity,
                child: AnotherCarousel(
                  images: [
                    NetworkImage(imageUrl ?? ''),
                    //displayImage(),
                  ],
                  dotSize: 4,
                  indicatorBgPadding: 5.0,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  pickImage(); // Function to pick a new image
                },
                child: Text('เลือกรูปภาพใหม่'),
              ),
            ],
          ),
        ),
        Text('ชื่ออาหาร'),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_name,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'กรอกข้อมูล',
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("รายละเอียด : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_description,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("วัตถุดิบ : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_ingredients,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("ระดับความยาก : "),
        SizedBox(
          height: 10.0,
        ),
        level(context),
        SizedBox(
          height: 10.0,
        ),
        Text("สัญชาติ : "),
        SizedBox(
          height: 10.0,
        ),
        nation(context),
        SizedBox(
          height: 10.0,
        ),
        Text("คะแนน : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_point,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("วิธทำ : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_solution,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("เวลาในการทำ : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_time,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("ประเภท : "),
        SizedBox(
          height: 10.0,
        ),
        type(context),
        SizedBox(
          height: 10.0,
        ),
        TextButton(
            onPressed: () async {
              String _editname = edit_name.text;
              String _editdescription = edit_description.text;
              String _editingredients = edit_ingredients.text;
              String _editlevel = edit_level!;
              String _editnation = edit_nation!;
              String _editpoint = edit_point.text;
              String _editsolution = edit_solution.text;
              String _edittime = edit_time.text;
              String _edittype = edit_type!;

              final docker =
                  FirebaseFirestore.instance.collection('Foods').doc(getfoodID);
              docker.update({
                'Food_Name': _editname,
                'Food_Description': _editdescription,
                'Food_Ingredients': _editingredients,
                'Food_Level': _editlevel,
                'Food_Nation': _editnation,
                'Food_Point': _editpoint,
                'Food_Solution': _editsolution,
                'Food_Time': _edittime,
                'Food_Type': _edittype,
                'Food_Image': imageUrl,
              });
              Navigator.of(context).pop();
            },
            child: const Text('ยืนยันการแก้ไข'))
      ]),
    );

    //Stream<List<PersonModel>> readData
  }
}
