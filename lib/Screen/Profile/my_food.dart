import 'package:flutter/material.dart';

class MyFoods extends StatefulWidget {
  const MyFoods({super.key});

  @override
  State<MyFoods> createState() => _MyFoodsState();
}

class _MyFoodsState extends State<MyFoods> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("สูตรของฉัน",
        style: TextStyle(
          color: Colors.amber
        ),),
      ),
    );
  }
}