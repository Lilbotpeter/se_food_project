import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Screen/Feed/feed_page.dart';
import 'package:se_project_food/Screen/Profile/user_link_profile.dart';

class SearchPageStream extends StatefulWidget {
  const SearchPageStream({Key? key}) : super(key: key);

  @override
  State<SearchPageStream> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPageStream> {
  bool _showListView = false;
  List _allResult = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  // Future<QuerySnapshot> getDataFoods() async {
  //   return await FirebaseFirestore.instance.collection('Foods').get();
  // }

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResult = [];
    if (_searchController.text != "") {
      for (var dataSnap in _allResult) {
        var name = dataSnap['Name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResult.add(dataSnap);
        }
      }
    } else {
      showResult = List.from(_allResult);
    }
    setState(() {
      _resultList = showResult;
      _showListView = _resultList
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
        .collection('users')
        .orderBy('Name')
        .get();

    setState(() {
      _allResult = data.docs;
      _resultList = data.docs;
    });
  }

  @override
  void didChangeDependencies() {
    getDataStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(
          controller: _searchController,
        ),
      ),
      body: Column(
        children: [
          Visibility(
            visible:
                _showListView, // กำหนดการแสดงผลของ ListView ตามค่า _showListView
            child: Expanded(
              child: ListView.builder(
                itemCount: _resultList.length,
                itemBuilder: (context, index) {
                  var user = _resultList[index];
                  return GestureDetector(
                    onTap: () {
                      try {
                        Get.to(UserLinkProfile(), arguments: user['Uid']);
                      } catch (e) {
                        Get.back();
                        Get.snackbar('พบข้อผิดพลาด', 'ลองใหม่อีกครั้ง');
                      }
                    },
                    child: ListTile(
                      title: Text(user['Name']),
                      subtitle: Text(user['Email']),
                    ),
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: !_showListView,
            child: Center(
              child: Text('ไม่พบข้อมูล'),
            ),
          ),
        ],
      ),
    );
  }
}
