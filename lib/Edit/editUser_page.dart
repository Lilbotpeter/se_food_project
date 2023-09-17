import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';

import '../Authen/authen_part.dart';
import 'edit_email.dart';
import 'edit_password.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController emial = TextEditingController();
  final TextEditingController phone = TextEditingController();

  String? imageUrl;
  @override
  void initState() {
    super.initState();
    readData();
  }

  String? usersid;
  final String getfoodID = Get.arguments as String; //ตัวรับ

//ดึงข้อมูลมาแสดง
  Future<void> readData() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(getfoodID)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        usersid = data['Uid'];
        name.text = data['Name'];
        //password.text = data['Password'];
        emial.text = data['Email'];
        phone.text = data['Phone'];
        imageUrl = data['ImageP'];
        setState(() {});
      } else {
        // Handle the case where the document does not exist.
        print('Document not found for ID: $getfoodID');
      }
    } catch (e) {
      // Handle any potential errors during Firestore fetch.
      print("Error fetching data: $e");
    }
  }

//เลือกรูปภาพ ตอนที่กดเพิ่มรูปภาพ
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        //allowMultiple: true, // อนุญาตให้เลือกหลายรูปภาพ
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // เลือกชื่อที่คุณต้องการให้รูปภาพใน Firebase Storage
        String imageName =
            'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

        Reference storageReference =
            FirebaseStorage.instance.ref().child(imageName);

        // อัปโหลดรูปภาพไปยัง Firebase Storage
        UploadTask uploadTask =
            storageReference.putFile(File(file.path.toString()));

        // รอการอัปโหลดเสร็จสิ้น
        await uploadTask.whenComplete(() async {
          // รับ URL ของรูปภาพหลังการอัปโหลดเสร็จสิ้น
          imageUrl = await storageReference.getDownloadURL();

          print('Image URL: $imageUrl');
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking or uploading image: $e');
    }
  }
  // Future<void> pickImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     //allowMultiple: true, // Allow selecting multiple images
  //   );

  //   if (result != null && result.files.isNotEmpty) {
  //     PlatformFile file = result.files.first;

  //     imageUrl = file.path;
  //     // imageUrl!.getDownloadURL();
  //     print('Image URL: ${imageUrl}');
  //   } else {
  //     print('No image selected');
  //   }
  // }
  // try {
  //   final DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(getfoodID)
  //       .get();

  //   if (snapshot.exists) {
  //     final data = snapshot.data() as Map<String, dynamic>;
  //     imageUrl = data['ImageP'];
  //     setState(() {});
  //   } else {
  //     // Handle the case where the document does not exist.
  //     print('Document not found for ID: $getfoodID');
  //   }
  // } catch (e) {
  //   // Handle any potential errors during Firestore fetch.
  //   print("Error fetching data: $e");
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              pickImage();
            },
            child: Container(
              child:
                  imageUrl != null ? Image.network(imageUrl!) : Placeholder(),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('ชื่อผู้ใช้'),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: name,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'กรอกข้อมูล',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          // Text('รหัสผ่าน'),
          // SizedBox(
          //   height: 10.0,
          // ),
          // TextField(
          //   controller: password,
          //   decoration: InputDecoration(
          //     border:
          //         OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          //     labelText: 'กรอกข้อมูล',
          //   ),
          // ),
          // SizedBox(
          //   height: 10.0,
          // ),
          Text('อีเมล'),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: emial,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'กรอกข้อมูล',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('เบอร์โทร'),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: phone,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'กรอกข้อมูล',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextButton(
              onPressed: () async {
                String _editname = name.text;
                //String _editpassword = password.text;
                String _editemail = emial.text;
                String _editphone = phone.text;
                //String _editImage = imageUrl!;

                final docker = FirebaseFirestore.instance
                    .collection('users')
                    .doc(getfoodID);

                //AuthenticationController().changePassword('999999');
                // AuthenticationController()
                //     .updateEmail('Kuay@gmail.com', '123456');
                docker.update({
                  'Uid': usersid,
                  'Name': _editname,
                  'Email': _editemail,
                  'Phone': _editphone,
                  'ImageP': imageUrl!,
                });

                Navigator.of(context).pop();
                //
              },
              child: const Text('ยืนยันการแก้ไข')),
          SizedBox(
            height: 10.0,
          ),
          TextButton(
              onPressed: () {
                Get.to(const EditPassword(), arguments: user!.email);
              },
              child: const Text('เปลี่ยนรหัสผ่าน')),
          TextButton(
              onPressed: () {
                Get.to(const EditEmail(), arguments: user!.uid);
              },
              child: const Text('เปลี่ยนอีเมล'))
        ],
      ),
    );
  }
}
