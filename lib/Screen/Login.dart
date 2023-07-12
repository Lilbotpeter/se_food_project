import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Register.dart';
import 'package:se_project_food/Widgets/Input_text.dart';
import 'package:se_project_food/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailcontroll = TextEditingController();
  TextEditingController passwordcontroll = TextEditingController();
  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                "images/logo.png",
                width: 300,
              ),
              Text("ยินดีต้อนรับ"),
              const SizedBox(
                height: 50,
              ),

              //email input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(textEditingController: emailcontroll,
                 labelString: "อีเมล",
                 iconData: Icons.email,
                  isObscure: false),
              ),

              const SizedBox(
                height: 25,
              ),
              
              //password
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(textEditingController: passwordcontroll,
                 labelString: "รหัสผ่าน",
                 iconData: Icons.password_outlined,
                  isObscure: false),
              ),
              const SizedBox(
                height: 25,
              ),
              showProgressBar==false?
              //login button
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-38,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ) 
                    ),
                    child: InkWell(
                      onTap: (){
                      //login user
                      if(emailcontroll.text.isNotEmpty && 
                      passwordcontroll.text.isNotEmpty){
                        setState(() {
                          showProgressBar = true;
                        });
                          authenticationController.loginUserNow(
                            emailcontroll.text,
                            passwordcontroll.text,
                          );
                          

                      }

                      },
                      child: const Center(
                        child: Text(
                          "ลงชื่อเข้าใช้",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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
                      Text("คุณยังไม่ได้สมัครเหรอ?",
                      style: TextStyle(fontSize: 16),),
                    InkWell(
                      onTap: (){
                        //jump to register sceen
                        Get.to(RegisterScreen());
                      },
                      child: const Text(
                        "สมัครเลย",
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
              ): Container(
                //Show animations
                //child: const LinearProgressIndicator(
                  
                //),
              ) 
            ],
          ),
        )
      )
    );
  }
}
