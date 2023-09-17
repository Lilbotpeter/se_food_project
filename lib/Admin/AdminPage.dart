// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Authen/authen_part.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  AuthenticationController auth = AuthenticationController.instanceAuth;
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      onPressed: (){
        signOut();
      },
      child: const Text('ออกจากระบบ'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),

        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 145, 0), Color.fromARGB(255, 255, 253, 249), const Color.fromARGB(255, 255, 255, 255)],
            stops: [0.1, 0.5, 0.9],
              ),

          ),
        child: Column(
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("ยินดีต้อนรับ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(133, 104, 96, 96),
                          fontWeight: FontWeight.w800,
                        ),),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          children: [
                            Icon(Icons.person,color: Color.fromARGB(255, 255, 255, 255),),
                            Text("Admin",
                                overflow: TextOverflow.fade, 
                                maxLines: 1,
                                textWidthBasis: TextWidthBasis.longestLine,
                                style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 7, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: (){
                    signOut();
                  }, icon: Icon(Icons.logout)),
                
                ],
              ),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  inkWellAd(title: 'User Report',icon:Icon(Icons.person),onFun: (){

                  },),
                  inkWellAd(title: 'Foods Report',icon:Icon(Icons.food_bank),onFun: (){
                    
                  },)
                ],
              ),
              
              
              
          ],
        ),
        ),
      ),
    );
    // Container(
    //   child: Row(children: [
    //   //   TextButton(
    //   //       onPressed: _signOutButton, child: const Text('ออกจากระบบนะจ๊ะ'))
    //   // ]),
    // );
  }

  
}

class inkWellAd extends StatelessWidget {
  const inkWellAd({
    Key? key,
    required this.title,
    required this.icon,
    required this.onFun,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final Function onFun;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print('Tapped');
      },
      child: Container(
        width: 150,
        height: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              icon,
              Text(title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
