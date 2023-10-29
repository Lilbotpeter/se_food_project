import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Screen/Detail/detail.dart';
import 'package:se_project_food/Screen/Feed/feed_page.dart';
import 'package:se_project_food/Screen/Profile/user_link_profile.dart';

class SearchFoodStream extends StatefulWidget {
  const SearchFoodStream({Key? key}) : super(key: key);

  @override
  State<SearchFoodStream> createState() => _SearchFoodStreamState();
}

class _SearchFoodStreamState extends State<SearchFoodStream> {
  bool _showListView = false;
  List _allResultFood = [];
  List _resultListFood = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
    print('_allResult = ');
    print(_allResultFood);
    print('_resultList = ');
    print(_resultListFood);
  }

  _onSearchChanged() {
    searchResultList();
    // print('_allResult = ');
    // print(_allResult);
    // print('_resultList = ');
    // print(_resultList);
  }

  searchResultList() {
    var showResult = [];

    if (_searchController.text != "") {
      for (var dataSnap in _allResultFood) {
        var name = dataSnap['Food_Name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResult.add(dataSnap);
        }
      }
    } else {
      showResult = List.from(_allResultFood);
    }
    setState(() {
      _resultListFood = showResult;
      _showListView = _resultListFood
          .isNotEmpty; // กำหนดค่าตัวแปร _showListView ให้เป็น true เมื่อมีผลลัพธ์
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void getDataStream() async {
    var data = await FirebaseFirestore.instance
        .collection('Foods')
        .orderBy('Food_Name')
        .get();

    setState(() {
      _allResultFood = data.docs;
      _resultListFood = data.docs;
    });
  }

  @override
  void didChangeDependencies() {
    getDataStream();
    super.didChangeDependencies();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าค้นหาอาหาร'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          Icon(
            Icons.search,
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'ค้นหาสูตรอาหาร',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              controller: _searchController,
            ),
          ),
          Visibility(
            visible:
                _showListView, // กำหนดการแสดงผลของ ListView ตามค่า _showListView
            child: Expanded(
              child: ListView.builder(
                itemCount: _resultListFood.length,
                itemBuilder: (context, index) {
                  var user = _resultListFood[index];
                  return GestureDetector(
                    onTap: () {
                      try {
                        Get.to(DetailFood(), arguments: user['Food_id']);
                      } catch (e) {
                        Get.back();
                        Get.snackbar('พบข้อผิดพลาด', 'ลองใหม่อีกครั้ง');
                      }
                    },
                    child: ListTile(
                      title: Text(user['Food_Name']),
                      //subtitle: Text(user['']),
                    ),
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible:
                !_showListView, // กำหนดการแสดงผลของข้อความ "No Data" ตามค่า _showListView
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Text('ไม่พบข้อมูลสูตรอาหาร'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
