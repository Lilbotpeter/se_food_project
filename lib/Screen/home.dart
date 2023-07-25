import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:se_project_food/Screen/Detail/detail.dart';

import 'package:se_project_food/Screen/Feed/feed_page.dart';
import 'package:se_project_food/Screen/Profile/my_food.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
//import 'package:se_project_food/Screen/Search/search_page.dart';
import 'package:se_project_food/Screen/Upload/upload_page.dart';
import 'package:se_project_food/Widgets/custom_icon.dart';

import '../Widgets/appbar_custom.dart';
import 'Search/search_page.dart';

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
    SearchPageStream(),
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
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: AppbarCustom(), //Appbar custom
          child: Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 127, 8),
                  Color.fromARGB(255, 255, 198, 55),
                ],
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Text('Food Homework Commu',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white,),),

                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      child: AnimatedContainer(
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
          duration: const Duration(
            milliseconds: 800,
          ),
      ),
        
      ),
      //Show Screen 
      body: screens[screenIndex],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child:const Icon(Icons.add),
      // ),
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