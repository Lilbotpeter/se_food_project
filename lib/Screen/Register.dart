import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:se_project_food/Screen/Login.dart';
import 'package:se_project_food/global.dart';
import '../Widgets/Input_text.dart';
import '../Authen/authen_part.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Prepare variable controllers
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                "สมัครสมาชิก",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Profile avatar
              GestureDetector(
                onTap: () {
                  authenticationController.chooseImageFromGallery();
                },
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("images/add-camera-icon-16.jpg"),
                  backgroundColor: Color.fromARGB(255, 199, 199, 199),
                  
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Email input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: emailTextEditingController,
                  labelString: "อีเมล",
                  iconData: Icons.email_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Password input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: passwordTextEditingController,
                  labelString: "รหัสผ่าน",
                  iconData: Icons.password_outlined,
                  isObscure: true,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Name
              Container(
                width: MediaQuery.of(context).size.width - 38,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: nameTextEditingController,
                  labelString: "ชื่อผู้ใช้",
                  iconData: Icons.person_2_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Phone
              Container(
                width: MediaQuery.of(context).size.width - 38,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: phoneTextEditingController,
                  labelString: "เบอร์โทร",
                  iconData: Icons.phone_android_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              showProgressBar == false
                  ? Column(
                      children: [
                        // Register button
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
                              if (authenticationController.profileImage ==
                                  null) {
                                // Display an error message if no profile image is selected
                                Get.snackbar(
                                  "สมัครสมาชิกไม่สำเร็จ",
                                  "โปรดเลือกรูปภาพโปรไฟล์",
                                );
                              } else if (!EmailValidator.validate(
                                  emailTextEditingController.text)) {
                                // Display an error message if the email is not valid
                                Get.snackbar(
                                  "อีเมลไม่ถูกต้อง",
                                  "โปรดกรอกอีเมลที่ถูกต้อง",
                                );
                              } else {
                                // Proceed with registration if all fields are filled and an image is selected
                                setState(() {
                                  showProgressBar = true;
                                });
                                // Create a new account for the user
                                authenticationController
                                    .createAccountForNewUser(
                                  authenticationController.profileImage!,
                                  nameTextEditingController.text,
                                  emailTextEditingController.text,
                                  passwordTextEditingController.text,
                                  phoneTextEditingController.text,
                                );
                              }
                            },
                            child: const Center(
                              child: Text(
                                "สมัครสมาชิก",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
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
                              onTap: () {
                                // Move the user to the login page
                                Get.to(LoginScreen());
                              },
                              child: const Text(
                                "  เข้าสู่ระบบ",
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
                    )
                  : Container(
                      // Show loading animation
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
