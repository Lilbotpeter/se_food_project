import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({super.key});

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {

  String? name_food = '';
  String? description_food = '';
  String? level_food = '';
  String? ingradent_food = '';
  String? nation_food = '';
  String? point_food = '';
  String? time_food = '';
  String? type_food = '';
  String? solution_food = '';

  final String getfoodID = Get.arguments as String;
  Future<void> _getDataFromDatabase() async {
     final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();
        
      if (snapshot.exists) {
        final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
        setState(() {
          name_food = data["Food_Name"];
          description_food = data["Food_Description"];
          level_food = data["Food_Level"];
          ingradent_food = data["Food_Ingredients"];
          solution_food = data["Food_Solution"];
          nation_food = data["Food_Nation"];
          point_food = data["Food_Point"];
          time_food = data["Food_Time"];
          type_food = data["Food_Type"];
        });
  }
      }
  }

    @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }
  @override
  Widget build(BuildContext context) {
     //ตัวรับ Parameter
    return Scaffold(
      appBar: AppBar(
        title: Text(name_food ??''),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 125,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('images/food.jpg',
              fit: BoxFit.cover,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              //child: SvgPicture.asset(""),
            ),
          ),
        ]
      ),
    );
  }
}