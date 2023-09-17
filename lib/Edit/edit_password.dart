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
          Text('ยืนยันรหัสผ่านปัจจุบัน'),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: confirmPassword,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'กรอกข้อมูล',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('รหัสผ่านใหม่'),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: newpassword,
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
                AuthenticationController().UpdatepassWORD(
                    email, confirmPassword.text, newpassword.text);
                Navigator.of(context).pop();
                //
              },
              child: const Text('ยืนยันการแก้ไขรหัสผ่าน')),
        ],
      ),
    );
  }
}
