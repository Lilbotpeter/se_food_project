import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';

import '../../Models/foodmodels.dart';

class EditFoods extends StatefulWidget {
  const EditFoods({super.key});

  @override
  State<EditFoods> createState() => _EditFoodsState();
}

class _EditFoodsState extends State<EditFoods> {
  List<FoodModel> foodModels = [];
  final TextEditingController edit_name = TextEditingController();
  final TextEditingController edit_description = TextEditingController();
  final TextEditingController edit_ingredients = TextEditingController();

  final TextEditingController edit_level = TextEditingController();
  final TextEditingController edit_nation = TextEditingController();
  final TextEditingController edit_point = TextEditingController();

  final TextEditingController edit_solution = TextEditingController();
  final TextEditingController edit_time = TextEditingController();
  final TextEditingController edit_type = TextEditingController();
  //Method ที่ทำงาน อ่านค่าที่อยู่ใน fire store

  @override
  void initState() {
    super.initState();
  }

  final String getfoodID = Get.arguments as String; //ตัวรับ
  Future<void> _getDataFromDatabase() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Text("ชื่อสูตรอาหาร : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_name,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("รายละเอียด : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_description,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("วัตถุดิบ : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_ingredients,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("ระดับความยาก : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_level,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("สัญชาติ : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_nation,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("คะแนน : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_point,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("วิธทำ : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_solution,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("เวลาในการทำ : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_time,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("ประเภท : "),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: edit_type,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextButton(
            onPressed: () {
              //อัปเดต ลงfirebase
              late String _editname = edit_name.text;

              late String _editdescription = edit_description.text;
              late String _editingredients = edit_ingredients.text;
              late String _editlevel = edit_level.text;
              late String _editnation = edit_nation.text;
              late String _editpoint = edit_point.text;
              late String _editsolution = edit_solution.text;
              late String _edittime = edit_time.text;
              late String _edittype = edit_type.text;

              final docker =
                  FirebaseFirestore.instance.collection('Foods').doc(getfoodID);
              docker.update({
                'Food_Name': _editname,
                'Food_Description': _editdescription,
                'Food_Ingredients': _editingredients,
                'Food_Level': _editlevel,
                'Food_Nation': _editnation,
                'Food_Point': _editpoint,
                'Food_Solution': _editsolution,
                'Food_Time': _edittime,
                'Food_Type': _edittype,
              });
              Navigator.of(context).pop();
            },
            child: const Text('ยืนยันการแก้ไข'))
      ]),
    );

    //Stream<List<PersonModel>> readData
  }
}
