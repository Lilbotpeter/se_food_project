import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Authen/authen_part.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController newEmail = TextEditingController();
  final String Uid = Get.arguments as String; //ตัวรับ

  @override
  void initState() {
    super.initState();
    // newEmail.text = email;
    // print('email = ');
    // print(email);
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
                child: Icon(Icons.email),
              ),
              Text('เปลี่ยนอีเมล',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text('อีเมลใหม่'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: newEmail,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'กรอกอีเมลใหม่',
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('กรอกรหัสผ่านในการยืนยัน'),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: confirmPassword,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'กรอกอีเมลใหม่อีกครั้ง',
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
                                            backgroundColor: Colors
                                                .black, // background (button) color
                                            foregroundColor: Colors
                                                .white, // foreground (text) color
                                          ),
                onPressed: () async {
                  String Password = confirmPassword.text;
                  String email = newEmail.text;
                  if (Password.isEmpty || email.isEmpty) {
                    // แสดง Snackbar ถ้ารหัสผ่านเดิมหรือรหัสผ่านใหม่เป็นค่าว่าง
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("กรุณากรอกรหัสผ่านเดิมหรืออีเมล"),
                      ),
                    );
                  } else {
                    final docker =
                        FirebaseFirestore.instance.collection('users').doc(Uid);
                    AuthenticationController()
                        .updateEmail(newEmail.text, confirmPassword.text);
                    docker.update({
                      'Email': newEmail.text,
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('ยืนยันการเปลี่ยนอีเมล'),
                      ),
                    ],
                  )),
          ),
        ],
      ),
    );
  }
}
