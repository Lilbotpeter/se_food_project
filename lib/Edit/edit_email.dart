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
          Text('อีเมลใหม่'),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: newEmail,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: 'กรอกข้อมูล',
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('กรอกรหัสผ่านในการยืนยัน'),
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
          TextButton(
              onPressed: () async {
                final docker =
                    FirebaseFirestore.instance.collection('users').doc(Uid);
                AuthenticationController()
                    .updateEmail(newEmail.text, confirmPassword.text);
                docker.update({
                  'Email': newEmail.text,
                });
                Navigator.of(context).pop();
              },
              child: const Text('ยืนยันการแก้ไขอีเมล')),
        ],
      ),
    );
  }
}
