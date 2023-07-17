import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:se_project_food/Screen/Detail/detail.dart';

import 'package:se_project_food/Screen/Feed/feed_page.dart';
import 'package:se_project_food/Screen/Profile/my_food.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
import 'package:se_project_food/Screen/Search/search_page.dart';
import 'package:se_project_food/Screen/Upload/upload_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<CurvedNavigationBarState> navigationKey =
      GlobalKey<CurvedNavigationBarState>();
  //Buttom bar page
  int screenIndex = 0 ;
  List screens = const [
    FeedPage(),
    DetailFood(),
    UploadFood(),
    MyFoods(),
    UserProfile(),
  ];

  final items = <Widget>[
    Icon(Icons.home,size: 30),
    Icon(Icons.search,size: 30),
    Icon(Icons.upload,size: 30),
    Icon(Icons.checklist_rtl,size: 30),
    Icon(Icons.person,size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      child: CurvedNavigationBar(
        key: navigationKey,
        color: Colors.orange,
        buttonBackgroundColor: Colors.orange,
        backgroundColor: Colors.white,
        height: 60,
        onTap: (index){
          setState(() {
            screenIndex = index;
          });
        },
        items:items,
          ),
        
      ),
      //Show Screen 
      body: screens[screenIndex],
    );
  }

  // AppBar buildAppBar(){
  //   return AppBar(
  //     elevation: 0,
  //     leading: IconButton(
  //       icon: SvgPicture.asset(""),
  //     ),
  //   );
  // }
}