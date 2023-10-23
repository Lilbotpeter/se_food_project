import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Authen/authen_part.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController confirmEmial = TextEditingController();

  //String? email;
  final String email = Get.arguments as String; //ตัวรับ
  @override
  void initState() {
    super.initState();
    print('email = ');
    print(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.only(left:7),
                child: Icon(Icons.key),
              ),
              Text('เปลี่ยนรหัสผ่าน',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text('รหัสผ่านปัจจุบัน'),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: confirmPassword,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'กรอกรหัสผ่านปัจจุบัน'
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text('รหัสผ่านใหม่'),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: newpassword,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'กรอกรหัสผ่านใหม่'
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .black, // background (button) color
                                              foregroundColor: Colors
                                                  .white, // foreground (text) color
                                            ),
                onPressed: () async {
                  String oldPassword = confirmPassword.text;
                  String newPassword = newpassword.text;
                  if (oldPassword.isEmpty || newPassword.isEmpty) {
                    // แสดง Snackbar ถ้ารหัสผ่านเดิมหรือรหัสผ่านใหม่เป็นค่าว่าง
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("กรุณากรอกรหัสผ่านเดิมหรือรหัสผ่านใหม่"),
                      ),
                    );
                  } else {
                    // ทำการเรียกฟังก์ชันเปลี่ยนรหัสผ่านและตรวจสอบผลลัพธ์
                    AuthenticationController()
                        .UpdatepassWORD(email, oldPassword, newPassword);
                    Navigator.of(context).pop();
                  }
          
                  // AuthenticationController().UpdatepassWORD(
                  //     email, confirmPassword.text, newpassword.text);
                  // Navigator.of(context).pop();
                  // //}
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('ยืนยันการเปลี่ยนรหัสผ่าน'),
                      ),
                    ],
                  )),
          ),
        ],
      ),
    );
  }
}
