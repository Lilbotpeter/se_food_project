import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:se_project_food/Screen/Login.dart';
import 'package:se_project_food/Screen/Register.dart';
import '../Admin/AdminPage.dart';
import '../Models/user.dart' as usermodel;
import '../Screen/home.dart';
import '../global.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController instanceAuth =
      Get.put(AuthenticationController());
  late Rx<User?> _currentUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final User? user = AuthenticationController().currentUser;

  late Rx<File?> _pickedFile;

  File? get profileImage => _pickedFile.value;

  //Choose image from gallery เด้อ
  void chooseImageFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      Get.snackbar(
        "เลือกภาพสำเร็จ",
        "เพิ่มภาพโปรไฟล์เรียบร้อยแล้ว",
      );
    }

    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

//Choose image from ก้อง เด้อ
  void captureImageWithCamera() async {
    try {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImageFile != null) {
        Get.snackbar(
          "ถ่ายภาพสำเร็จ",
          "เพิ่มภาพโปรไฟล์เรียบร้อยแล้ว",
        );
      }

      _pickedFile = Rx<File?>(File(pickedImageFile!.path));
    } catch (error) {
      Get.snackbar("อัพโหลดรูปไม่สำเร็จ", 'กรุณาเพิ่มรูปภาพใหม่อีกครั้ง');
    }
  }

  //createAccountForNewUser
  void createAccountForNewUser(File imageFile, String username,
      String userEmail, String userPassword, String userPhone) async {
    try {
      //1. create user in the firebase authentication
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      //2.save the user profile image to firebase storage
      String imageDowloadUrl = await uploadImageToStorage(imageFile);

      //3.save user data to the firestore database
      usermodel.User user = usermodel.User(
          // email: userEmail,
          // pathImage: imageDowloadUrl,
          // name = username,
          // phone = userPhone,
          // uid = credential.user!.uid,
          email: userEmail,
          name: username,
          pathImage: imageDowloadUrl,
          phone: userPhone,
          uid: credential.user!.uid);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set(user.toJson());
      Get.snackbar("สมัครสมาชิกสำเร็จ", "บัญชีของคุณถูกสร้างสำเร็จแล้ว");
    } catch (error) {
      Get.snackbar("สมัครสมาชิกไม่สำเร็จ", "โปรดลองใหม่อีกครั้ง");
      showProgressBar = false;
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("Profile Picture")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrlOfUploadImage = await taskSnapshot.ref.getDownloadURL();

    return downloadUrlOfUploadImage;
  }

  //Login function

  void loginUserNow(String userEmail, String userPassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      Get.snackbar("เข้าสู่ระบบสำเร็จ", "ยินดีต้อนรับ");

      showProgressBar = false;
    } catch (error) {
      Get.snackbar("เข้าสู่ระบบไม่สำเร็จ", "โปรดลองใหม่อีกครั้ง");

      showProgressBar = false;
      Get.to(RegisterScreen());
    }
  }

  //Each Screen
  goToScreen(User? currentUser) {
    //when user isn't already logged-in
    print('currentUser = ');
    print(currentUser);
    if (currentUser!.email == null) {
      Get.offAll(LoginScreen());
    } else if (currentUser!.email == 'admin@admin.com') {
      Get.offAll(AdminPage());
    }
    //when user is already logged-in
    else {
      Get.offAll(HomeScreen());
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_currentUser, goToScreen);
  }

  void signOut() async {
    await _firebaseAuth.signOut();
  }
}
