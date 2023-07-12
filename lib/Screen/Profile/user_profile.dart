import 'package:flutter/material.dart';
import 'package:se_project_food/Authen/authen_part.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  //logout *


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
             const SizedBox(
                height: 70,
              ),
            ElevatedButton(
              onPressed: (){
                AuthenticationController().signOut();
              },
              
              
              child: const Text('Disabled'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}