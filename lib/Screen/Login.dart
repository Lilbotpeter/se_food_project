import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoggingIn = false;

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
              // Email input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: emailcontroll,
                  labelString: "อีเมล",
                  iconData: Icons.email,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Password
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: passwordcontroll,
                  labelString: "รหัสผ่าน",
                  iconData: Icons.password_outlined,
                  isObscure: true,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              isLoggingIn
                  ? CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    )
                  : Column(
                      children: [
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
                            onTap: () {
                              // Login user
                              if (emailcontroll.text.isNotEmpty &&
                                  passwordcontroll.text.isNotEmpty) {
                                setState(() {
                                  isLoggingIn = true;
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
                            Text(
                              "คุณยังไม่ได้สมัครเหรอ?",
                              style: TextStyle(fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {
                                // Jump to register screen
                                Get.to(RegisterScreen());
                              },
                              child: const Text(
                                "สมัครเลย",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void signOut() async {
    if (isLoggingIn) {
      return; // ออกเมื่อกำลังเข้าสู่ระบบ
    }
    isLoggingIn = true;
    await FirebaseAuth.instance.signOut();
    isLoggingIn = false; // กำหนดค่า isLoggingIn กลับเป็น false เมื่อออกจากระบบ
  }
}
