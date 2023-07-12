import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Screen/Login.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:se_project_food/global.dart';

import '../Widgets/Input_text.dart';


import '../Authen/authen_part.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  //prepare varible controller
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController =TextEditingController();
  TextEditingController nameTextEditingController =TextEditingController();
  TextEditingController phoneTextEditingController =TextEditingController();

  var authenticationController = AuthenticationController.instanceAuth; 

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              

              // Image.asset("images/logo.png",
              // width: 210,
              // ),
              const SizedBox(
                height: 15,
              ),

              Text("สมัครสมาชิก",
                // style: GoogleFonts.notoSerifThai(
                //   fontSize: 25,
                //   color: Colors.black,
                // ),
              ),

              const SizedBox(
                height: 25,
              ),

              //profile avatar
              GestureDetector(
                onTap: (){
                  authenticationController.captureImageWithCamera();
                },
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                    "images/logo.png"
                  ),
                  backgroundColor: Colors.black,
                ),
              ),


              
              const SizedBox(
                height: 25,
              ),

              //email input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(textEditingController: emailTextEditingController,
                 labelString: "อีเมล",
                 iconData: Icons.email_outlined,
                 isObscure: false),
              ),

              const SizedBox(
                height: 25,
              ),


              //password input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(textEditingController: passwordTextEditingController,
                 labelString: "รหัสผ่าน",
                 iconData: Icons.password_outlined,
                  isObscure: true),
              ),

              const SizedBox(
                height: 25,
              ),

              //name
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(textEditingController: nameTextEditingController,
                 labelString: "ชื่อผู้ใช้",
                 iconData: Icons.person_2_outlined,
                  isObscure: false),
              ),

              const SizedBox(
                height: 25,
              ),

              //phone
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(textEditingController: phoneTextEditingController,
                 labelString: "เบอร์โทร",
                 iconData: Icons.phone_android_outlined,
                  isObscure: false),
              ),

              const SizedBox(
                height: 25,
              ),


              
              showProgressBar == false ?
              //register button
              Column(
                children: [
                  //register button
                  Container(
                    width: MediaQuery.of(context).size.width - 38,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          showProgressBar = true;
                        });

                        if(authenticationController.profileImage!= null 
                        && nameTextEditingController.text.isNotEmpty 
                        && emailTextEditingController.text.isNotEmpty 
                        && passwordTextEditingController.text.isNotEmpty 
                        && phoneTextEditingController.text.isNotEmpty)
                        {
                          setState(() {
                            showProgressBar = true;
                          });
                          //create new account for user
                          authenticationController.createAccountForNewUser(
                          authenticationController.profileImage!,
                          nameTextEditingController.text,
                          emailTextEditingController.text,
                          passwordTextEditingController.text,
                          phoneTextEditingController.text
                          );
                        }
                      },

                      child: const Center(
                        child: Text(
                          "สมัครสมาชิก",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                height: 25,
              ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "คุณมีบัญชีอยู่แล้ว?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          //move user to login paage
                          Get.to(LoginScreen());
                        },
                        child: const Text(
                          "  เข้าสู่ระบบ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                    ),
                ],
              ) : Container(
                //show animations
                
              ),

              //signup now

            ],
          ),
        ),
      ),
    );
  }
}