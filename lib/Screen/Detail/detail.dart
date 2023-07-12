import 'package:flutter/material.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({super.key});

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("ดีเทล",
        style: TextStyle(
          color: Colors.amber
        ),),
      ),
    );
  }
}