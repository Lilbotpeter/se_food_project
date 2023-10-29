import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
import 'package:se_project_food/Widgets/profile_picture.dart';

import '../Authen/authen_part.dart';
import 'edit_Service.dart';
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
  File? imageXFile;

  String? imageUrl;
  @override
  void initState() {
    super.initState();
    readData();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
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
      appBar: AppBar(
        title: Text('หน้าแก้ไขโปรไฟล์ผู้ใช้'),
        centerTitle: true,
        flexibleSpace: ClipPath(
          child: Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 127, 8),
                  Color.fromARGB(255, 255, 198, 55),
                ],
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Text('Food Homework Commu',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white,),),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
            'แก้ไขโปรไฟล์',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 35,
          ),
          GestureDetector(
            onTap: () {
              pickImage();
            },
            child: Container(
              child: imageUrl != null
                  ? SizedBox(
                      child: Stack(children: [
                      ProfilePicture(
                        image: imageUrl!,
                        imageXFile: imageXFile,
                      ),
                      Positioned(
                          left: 220,
                          top: 75,
                          child: Icon(
                            Icons.photo,
                            size: 40,
                          )),
                    ]))
                  : ProfilePicture(
                      image: "images/add-camera-icon-16.jpg",
                      imageXFile: imageXFile,
                    ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'ข้อมูลผู้ใช้',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: name,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: 'ชื่อผู้ใช้',
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text('อีเมล'),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emial,
              enabled: false,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: 'อีเมล',
              ),
            ),
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

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text('เบอร์โทร'),
          // ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: phone,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: 'เบอร์โทร',
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // background (button) color
                  foregroundColor: Colors.white, // foreground (text) color
                ),
                onPressed: () async {
                  String _editname = name.text;
                  //String _editpassword = password.text;
                  String _editemail = emial.text;
                  String _editphone = phone.text;
                  //String _editImage = imageUrl!;

                  final docker = FirebaseFirestore.instance
                      .collection('users')
                      .doc(getfoodID);

                  if (_editname.isEmpty || _editphone.isEmpty) {
                    // แสดง Snackbar ถ้า _editname หรือ _editphone มีค่าว่าง
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("กรุณากรอกข้อมูลให้ครบถ้วน"),
                      ),
                    );
                  } else {
                    // ทำการอัปเดตข้อมูลหาก _editname และ _editphone ไม่ว่าง
                    final docker = FirebaseFirestore.instance
                        .collection('users')
                        .doc(getfoodID);
                    docker.update({
                      'Uid': usersid,
                      'Name': _editname,
                      'Email': _editemail,
                      'Phone': _editphone,
                      'ImageP': imageUrl!,
                    });
                    Navigator.of(context).pop();
                  }

                  //
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_outlined),
                    const Text('ยืนยันการแก้ไข'),
                  ],
                )),
          ),
          SizedBox(
            height: 10.0,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  onPressed: () {
                    Get.to(const EditEmail(), arguments: user!.uid);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'เปลี่ยนอีเมล',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  onPressed: () {
                    Get.to(const EditPassword(), arguments: user!.email);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.key_rounded),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('เปลี่ยนรหัสผ่าน'),
                      ),
                    ],
                  )),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 255, 0, 0), // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('ยืนยันการลบข้อมูลผู้ใช้?'),
                          content:
                              Text('คุณแน่ใจหรือไม่ที่ต้องการลบข้อมูลผู้ใช้?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // ปิด Dialog
                              },
                              child: Text('ยกเลิก'),
                            ),
                            TextButton(
                              // onPressed: () async {
                              //   // final deleteUser = AuthenticationController();
                              //   // deleteUser.deleteUserFromFirebase();
                              //   //Navigator.of(context).pop(); // ปิด Dialog
                              // },
                              onPressed: () async {
                                TextEditingController passwordController =
                                    TextEditingController();

                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("ยืนยันการลบบัญชีผู้ใช้"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                              "โปรดกรอกรหัสผ่านของคุณเพื่อยืนยันการลบบัญชีผู้ใช้"),
                                          TextFormField(
                                            controller: passwordController,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                labelText: "รหัสผ่าน"),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("ยกเลิก"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("ยืนยัน"),
                                          onPressed: () async {
                                            final password =
                                                passwordController.text;

                                            if (password.isNotEmpty) {
                                              final deleteUserdata =
                                                  EditService();
                                              deleteUserdata.DeleteReplyMod(
                                                  usersid!);
                                              deleteUserdata.DeleteReplyReview(
                                                  usersid!);
                                              deleteUserdata
                                                  .DeleteReplyCommentData(
                                                      usersid!);
                                              deleteUserdata.DeleteCommentData(
                                                  usersid!);
                                              deleteUserdata.DeleteModData(
                                                  usersid!);
                                              deleteUserdata.DeleteReviewData(
                                                  usersid!);
                                              deleteUserdata.DeleteFood(
                                                  usersid!);
                                              deleteUserdata.DeleteUser(
                                                  usersid!);
                                              final deleteUserOnAuthen =
                                                  AuthenticationController();
                                              deleteUserOnAuthen
                                                  .deleteUserFromFirebase(
                                                      password);
                                              Navigator.of(context).pop();
                                              Get.snackbar('ลบข้อมูลผู้ใช้',
                                                  'ลบข้อมูลผู้ใช้สำเร็จ');
                                              signOut();
                                            } else {
                                              //final test = EditService();
                                              // test.DeleteReplyMod(usersid!);

                                              // test.DeleteReplyReview(usersid!);
                                              // test.DeleteReplyCommentData(usersid!);
                                              // test.DeleteCommentData(usersid!);
                                              // test.DeleteModData(usersid!);
                                              // test.DeleteReviewData(usersid!);

                                              Get.snackbar('เกิดข้อผิดพลาด',
                                                  'ลบข้อมูลผู้ใช้ไม่สำเร็จ');
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('ลบ'),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, color: Colors.white),
                      const Text(
                        'ลบบัญชี',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            ],
          ),
          TextButton(
              onPressed: () {
                //final test = EditService();

                // test.DeleteReplyMod(usersid!);
                // test.DeleteReplyReview(usersid!);
                // test.DeleteReplyCommentData(usersid!);
                // test.DeleteCommentData(usersid!);
                // test.DeleteModData(usersid!);
                // test.DeleteReviewData(usersid!);
                // test.DeleteFood(usersid!);
                // test.DeleteUser(usersid!);
              },
              child: const Text('ทดสอบลบข้อมูล')),
        ],
      ),
    );
  }
}
