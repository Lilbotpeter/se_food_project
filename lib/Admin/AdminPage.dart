import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Authen/authen_part.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<void> signOut() async {
    await AuthenticationController().signOut;
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      onPressed: signOut,
      child: const Text('ออกจากระบบ'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _signOutButton();
    // Container(
    //   child: Row(children: [
    //   //   TextButton(
    //   //       onPressed: _signOutButton, child: const Text('ออกจากระบบนะจ๊ะ'))
    //   // ]),
    // );
  }
}
