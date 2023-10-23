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
  late Rx<File?> _pickedFile =
      Rx<File?>(null); // Initialize _pickedFile with null

  File? get profileImage => _pickedFile.value;

  // File? get profileImage => _pickedFile.value;

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

  void createAccountForNewUser(
    File? imageFile,
    String username,
    String userEmail,
    String userPassword,
    String userPhone,
  ) async {
    try {
     
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      String? imageDownloadUrl;

      if (imageFile != null) {
        imageDownloadUrl = await uploadImageToStorage(imageFile);
      }

      usermodel.User user = usermodel.User(
        email: userEmail,
        name: username,
        pathImage: imageDownloadUrl,
        phone: userPhone,
        uid: credential.user!.uid,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set(user.toJson());

      Get.snackbar("สมัครสมาชิกสำเร็จ", "บัญชีของคุณถูกสร้างสำเร็จแล้ว");
      // If registration is successful, reset the data and navigate to a different screen
      _pickedFile = Rx<File?>(null); // Reset _pickedFile
      username = ''; // Reset username
      userEmail = ''; // Reset userEmail
      userPassword = ''; // Reset userPassword
      userPhone = ''; // Reset userPhone
    } catch (error) {
      if (imageFile == null) {
        Get.snackbar("สมัครสมาชิกไม่สำเร็จ", "โปรดเลือกรูปภาพโปรไฟล์");
        showProgressBar = false;
        return; // Stop further execution
      } else {
        Get.snackbar("สมัครสมาชิกไม่สำเร็จ", "โปรดลองใหม่อีกครั้ง");
        showProgressBar = false;
        return; // Stop further execution
      }
      // showProgressBar = false;
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
  goToScreen(User? currentUser) async {
    //when user isn't already logged-in
    print('currentUser = ');
    print(currentUser);
    if (currentUser == null) {
      Get.offAll(LoginScreen());
    } else if (currentUser!.email == 'admin@admin.com') {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'admin@admin.com',
        password: '123456',
      );
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

  Future<void> changePassword(String newPassword) async {
    try {
      // รับผู้ใช้ปัจจุบัน
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // ผู้ใช้ไม่ได้เข้าสู่ระบบ ให้ทำการเข้าสู่ระบบก่อนเปลี่ยนรหัสผ่าน
        print('กรุณาเข้าสู่ระบบก่อนที่จะเปลี่ยนรหัสผ่าน');
        return;
      }

      // เปลี่ยนรหัสผ่าน
      await user.updatePassword(newPassword);

      print('รหัสผ่านถูกเปลี่ยนแล้ว');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน: $e');
    }
  }

  void UpdatepassWORD(
      String Email, String Password, String ConfirmPassword) async {
    try {
      String email = Email; // รับอีเมลของผู้ใช้
      String password = Password; // รับรหัสผ่านปัจจุบัน

      // เข้าสู่ระบบด้วยอีเมลและรหัสผ่านปัจจุบัน
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // หลังจากเข้าสู่ระบบแล้ว ค่อยทำการเปลี่ยนรหัสผ่าน
      await changePassword(ConfirmPassword);

      print('เปลี่ยนรหัสผ่านสำเร็จ');
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
  }

  Future<void> updateEmail(String newEmail, String password) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User is not signed in');
        return;
      }

      // Re-authenticate the user by signing in again
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the email
      await user.updateEmail(newEmail);

      print('Email updated successfully');
    } catch (e) {
      print('Error updating email: $e');
    }
  }

  // void deleteUser(String email, String password) async {
  // try {
  //   // อีกครั้ง, ให้คุณตรวจสอบว่าผู้ใช้เข้าสู่ระบบก่อนลบ
  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user == null) {
  //     print('User is not signed in');
  //     return;
  //   }

  //   // รีอะทูเนิคผู้ใช้โดยลงชื่อเข้าระบบอีกครั้ง
  //   AuthCredential credential = EmailAuthProvider.credential(
  //     email: email,
  //     password: password,
  //   );

  //   await user.reauthenticateWithCredential(credential);

  //   // ลบผู้ใช้
  //   await user.delete();

  //   print('User deleted successfully');
  // } catch (e) {
  //   print('Error deleting user: $e');
  // }
//}

// void main() {
//   // เรียกใช้ฟังก์ชันเพื่อลบผู้ใช้
//   String userUidToDelete = "UID_OF_USER_TO_DELETE";
//   deleteFirebaseUser(userUidToDelete);
// }
  void deleteUserFromFirebase(String password) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not signed in");
      return;
    }

    final AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.delete();
      print("User deleted successfully");
      Get.snackbar(
        "ลบบัญชีผู้ใช้สำเร็จ",
        "บัญชีผู้ใช้ได้ถูกลบเรียบร้อยแล้ว",
      );
    } catch (e) {
      print("Error deleting user: $e");
      Get.snackbar(
        "เกิดข้อผิดพลาดในการลบบัญชีผู้ใช้",
        "โปรดลองใหม่อีกครั้งหรือตรวจสอบรหัสผ่านของคุณ",
      );
    }
  }
}
