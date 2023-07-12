import 'package:flutter/material.dart';

class UploadFood extends StatefulWidget {
  const UploadFood({super.key});

  @override
  State<UploadFood> createState() => _UploadFoodState();
}

class _UploadFoodState extends State<UploadFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("อัพโหลด",
        style: TextStyle(
          color: Colors.amber
        ),),
      ),
    );
  }
}