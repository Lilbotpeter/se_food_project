// import 'dart:typed_data';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:se_project_food/Authen/authen_part.dart';
// import '../../Api/firebase_api.dart';
// //import 'package:se_project_food/Models/user.dart' hide User;
// import '../../Models/foodmodels.dart';
// import '../../Models/user.dart' as usermodel;
// import '../../Widgets/button_widget.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import '../../main.dart';

// class UploadFood extends StatefulWidget {
//   const UploadFood({Key? key}) : super(key: key);

//   @override
//   State<UploadFood> createState() => _UploadFoodState();
// }

// class _UploadFoodState extends State<UploadFood> {
//   UploadTask? task;
// //final User? user = AuthenticationController().currentUser;
//   User? user = AuthenticationController().currentUser;
//   //Rx<User?> _currentUser;

//   File? file; //file can null
//   PlatformFile? pickedFile;
//   String? food_id;
//   String? urlDownload,
//       food_name = '',
//       food_video,
//       food_level = '',
//       food_ingredients = '',
//       food_solution = '',
//       food_type = '',
//       food_description = '',
//       food_time = '',
//       food_nation = '',
//       food_point = '';

//   //Current UID
//   Widget _userUID() {
//     return Text(user?.uid ?? 'User UID');
//   }

//   List<File> files = []; // List เก็บรูปภาพที่ถูกเลือก

//   Future<void> selectFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: true, // เปลี่ยนเป็น true เพื่อให้เลือกหลายไฟล์
//     );

//     if (result == null) return;

//     setState(() {
//       files = result.paths
//           .map((path) => File(path!))
//           .toList(); // แปลงรายการเป็นรายการของ File
//     });
//   }

//   bool _isImageFile(String filename) {
//     final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
//     urlDownload = extension(filename).toLowerCase();
//     return imageExtensions.contains(urlDownload);
//   }

//   bool _isVideoFile(String filename) {
//     final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv'];
//     food_video = extension(filename).toLowerCase();
//     return videoExtensions.contains(food_video);
//   }

//   Future<void> uploadFile() async {
//     String? assignImage = '';
//     String? assignVideo = '';
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final DocumentSnapshot snapshot =
//         await FirebaseFirestore.instance.collection("Foods").doc().get();
//     food_id = snapshot.id;

//     // Check if files are not selected
//     if (files.isEmpty) return;

//     // Loop through the selected files and upload them
//     for (int i = 0; i < files.length; i++) {
//       File file = files[i];
//       final filename = basename(file.path);
//       // Check the file extension to determine if it's an image or a video
//       bool isImage = _isImageFile(filename);
//       bool isVideo = _isVideoFile(filename);

//       filename;
//       if (isImage) {
//         final destination = 'files/$food_id/Image/$filename';
//         // Process the file as an image
//         task = FirebaseApi.uploadFile(
//             destination, file); // Assuming you have an 'uploadImage' method
//         setState(() {});

//         if (task == null) continue;

//         await task!.then((snapshot2) async {
//           urlDownload = await snapshot2.ref.getDownloadURL();
//           assignImage = urlDownload.toString();
//         }).catchError((error) {
//           print('เกิดข้อผิดพลาดในการอัปโหลด: $error');
//         });
//       } else if (isVideo) {
//         final destination = 'files/$food_id/Video/$filename';
//         // Process the file as a video
//         task = FirebaseApi.uploadFile(
//             destination, file); // Assuming you have an 'uploadVideo' method
//         setState(() {});

//         if (task == null) continue;

//         await task!.then((snapshot2) async {
//           food_video = await snapshot2.ref.getDownloadURL();
//           assignVideo = food_video.toString();
//         }).catchError((error) {
//           print('เกิดข้อผิดพลาดในการอัปโหลด: $error');
//         });
//       } else {
//         // Handle other types of files (if necessary)
//       }
//       print('filename = ');
//       print(filename);
//     }

//     Map<String, dynamic> dataMap = Map();
//     dataMap['Food_id'] = food_id;
//     dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
//     dataMap['Food_Image'] = assignImage!.isNotEmpty
//         ? assignImage
//         : 'https://firebasestorage.googleapis.com/v0/b/project-food-c14c5.appspot.com/o/no_images.jpg?alt=media&token=3e5f6512-8b47-4efb-ab68-89b6d049eff6';
//     dataMap['Food_Video'] = assignVideo!.isNotEmpty ? assignVideo : 'N/A';
//     dataMap['Food_Level'] = food_level!.isNotEmpty ? food_level : 'N/A';
//     dataMap['Food_Ingredients'] =
//         food_ingredients!.isNotEmpty ? food_ingredients : 'N/A';
//     dataMap['Food_Solution'] =
//         food_solution!.isNotEmpty ? food_solution : 'N/A';
//     dataMap['Food_Type'] = food_type!.isNotEmpty ? food_type : 'N/A';
//     dataMap['Food_Description'] =
//         food_description!.isNotEmpty ? food_description : 'N/A';
//     dataMap['Food_Time'] = food_time!.isNotEmpty ? food_time : 'N/A';
//     dataMap['Food_Nation'] = food_nation!.isNotEmpty ? food_nation : 'N/A';
//     dataMap['Food_Point'] = food_point!.isNotEmpty ? food_point : 'N/A';
//     dataMap['User_id'] = user?.uid;

//     await firestore.collection('Foods').doc().set(dataMap).then((value) {});
//   }

//   //Upload Status %
//   Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//         stream: task.snapshotEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!; //snapshot data
//             final progress = snap.bytesTransferred /
//                 snap.totalBytes; //% progress raw percent
//             final percen =
//                 (progress * 100).toStringAsFixed(2); //Percent 100% 0.00

//             return Text(
//               '$percen %',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             );
//           } else {
//             return Container();
//           }
//         },
//       );

//   void onNameChanged(String value) {
//     setState(() {
//       food_name = value.trim();
//     });
//   }

//   Widget name(context) {
//     return TextField(
//       onChanged: onNameChanged,
//       decoration: InputDecoration(
//         labelText: 'ชื่ออาหาร',
//         hintText: 'กรุณากรอกชื่ออาหาร',
//         icon: Icon(Icons.format_align_center),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       keyboardType: TextInputType.text,
//     );
//   }

//   Widget level(context) {
//     String foodLevel = 'ง่าย'; // กำหนดค่าเริ่มต้น

//     return DropdownButtonFormField<String>(
//       value: foodLevel,
//       onChanged: (value) {
//         setState(() {
//           foodLevel = value.toString();
//           food_level = foodLevel;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'ความยากในการทำ',
//         hintText: 'กรุณาเลือกความยากในการทำ',
//         icon: Icon(Icons.point_of_sale),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       items: <DropdownMenuItem<String>>[
//         DropdownMenuItem<String>(
//           value: 'ง่าย',
//           child: Text('ง่าย'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ปานกลาง',
//           child: Text('ปานกลาง'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ยาก',
//           child: Text('ยาก'),
//         ),
//       ],
//     );
//   }

//   Widget ingredients(context) {
//     return TextField(
//       onChanged: (value) {
//         food_ingredients = value.trim();
//       },
//       decoration: InputDecoration(
//         labelText: 'วัตถุดิบ',
//         hintText: 'กรุณากรอกวัตถุดิบ',
//         icon: Icon(Icons.dinner_dining),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       keyboardType: TextInputType.text,
//     );
//   }

//   Widget solution(context) {
//     return TextField(
//         onChanged: (value) {
//           food_solution = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'วิธีการทำ',
//           hintText: 'กรุณากรอกวิธีการทำ',
//           icon: Icon(Icons.solar_power_outlined),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget type(context) {
//     String foodtype = 'ฟาสต์ฟู้ด'; // กำหนดค่าเริ่มต้น

//     return DropdownButtonFormField<String>(
//       value: foodtype,
//       onChanged: (value) {
//         setState(() {
//           foodtype = value.toString();
//           food_type = foodtype;
//         });
//       },
//       decoration: InputDecoration(
//         icon: Icon(Icons.point_of_sale),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       items: <DropdownMenuItem<String>>[
//         DropdownMenuItem<String>(
//           value: 'ฟาสต์ฟู้ด',
//           child: Text('ฟาสต์ฟู้ด'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ของหวาน',
//           child: Text('ของหวาน'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'เครื่องดื่ม/น้ำผลไม้',
//           child: Text('เครื่องดื่ม/น้ำผลไม้'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'อาหารเจ',
//           child: Text('อาหารเจ'),
//         ),
//       ],
//     );
//   }

//   Widget description(context) {
//     return TextField(
//         onChanged: (value) {
//           food_description = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'รายละเอียดอาหาร',
//           hintText: 'กรุณากรอกรายละเอียดอาหาร',
//           icon: Icon(Icons.description),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget time(context) {
//     return TextField(
//         onChanged: (value) {
//           food_time = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'เวลาในการทำ',
//           hintText: 'กรุณากรอกเวลาในการทำ',
//           icon: Icon(Icons.description),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget nation(context) {
//     String foodnation = 'ไทย'; // กำหนดค่าเริ่มต้น

//     return DropdownButtonFormField<String>(
//       value: foodnation,
//       onChanged: (value) {
//         setState(() {
//           foodnation = value.toString();
//           food_nation = foodnation;
//         });
//       },
//       decoration: InputDecoration(
//         icon: Icon(Icons.point_of_sale),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       items: <DropdownMenuItem<String>>[
//         DropdownMenuItem<String>(
//           value: 'ไทย',
//           child: Text('ไทย'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ญี่ปุ่น',
//           child: Text('ญี่ปุ่น'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'เกาหลี',
//           child: Text('เกาหลี'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'อิตาลี',
//           child: Text('อิตาลี'),
//         ),
//         // DropdownMenuItem<String>(
//         //   value: 'สเปน',
//         //   child: Text('สเปน'),
//         // ),
//       ],
//     );
//   }

//   Widget point(context) {
//     return TextField(
//         onChanged: (value) {
//           food_point = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'คะแนนอาหาร',
//           hintText: 'กรุณากรอกคะแนนอาหาร',
//           icon: Icon(Icons.description),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget showForm(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             //Text('ชื่ออาหาร'),
//             name(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('เลเวล'),
//             level(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('วัตถุดิบ'),
//             ingredients(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('วิธีทำ'),
//             solution(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('ประเภทอาหาร'),
//             type(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('รายละเอียด'),
//             description(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('เวลาในการทำ'),
//             time(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('สัญชาติอาหาร'),
//             nation(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             point(context),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filename = file != null
//         ? basename(file!.path)
//         : 'ยังไม่มีไฟล์ที่เลือก!'; //set basename

//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Upload Food'),
//       //   centerTitle: true,
//       //   ),

//       body: Container(
//         padding: EdgeInsets.all(32),
//         child: Container(
//             child: ListView(
//           //mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             if (pickedFile != null)
//               Expanded(
//                 child: Container(
//                   color: Colors.amber,
//                   child: Image.file(
//                     File(pickedFile!.path!),
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             SizedBox(
//               height: 15.0,
//             ),
//             ButtonWidget(
//                 //Button Select file
//                 icon: Icons.attach_file,
//                 text: 'เลือกไฟล์',
//                 onClick: selectFile),

//             //Under filename for "Spacebar naja"
//             SizedBox(
//               height: 15.0,
//             ),
//             showForm(context),
//             SizedBox(
//               height: 15.0,
//             ),
//             ButtonWidget(
//                 //Button Upload file
//                 icon: Icons.upload_file_sharp,
//                 text: 'อัพโหลด',
//                 onClick: uploadFile),

//             task != null ? buildUploadStatus(task!) : Container() //Percent
//           ],
//         )),
//       ),
//     );
//   }
// }
// //ถ้าอัปรูปซ้ำแอปจะค้าง

// import 'dart:typed_data';

// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:se_project_food/Authen/authen_part.dart';
// import '../../Api/firebase_api.dart';
// //import 'package:se_project_food/Models/user.dart' hide User;
// import '../../Models/foodmodels.dart';
// import '../../Models/user.dart' as usermodel;
// import '../../Widgets/button_widget.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// class UploadFood extends StatefulWidget {
//   const UploadFood({Key? key}) : super(key: key);

//   @override
//   State<UploadFood> createState() => _UploadFoodState();
// }

// class _UploadFoodState extends State<UploadFood> {
//   UploadTask? task;
// //final User? user = AuthenticationController().currentUser;
//   User? user = AuthenticationController().currentUser;
//   //Rx<User?> _currentUser;

//   File? file; //file can null
//   PlatformFile? pickedFile;
//   String? food_id;
//   String? urlDownload,
//       food_name = '',
//       food_video,
//       food_level = '',
//       food_ingredients = '',
//       food_solution = '',
//       food_type = '',
//       food_description = '',
//       food_time = '',
//       food_nation = '',
//       food_point = '';

//   //Current UID
//   Widget _userUID() {
//     return Text(user?.uid ?? 'User UID');
//   }

//   List<File> files = []; // List เก็บรูปภาพที่ถูกเลือก

//   Future<void> selectFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: true, // เปลี่ยนเป็น true เพื่อให้เลือกหลายไฟล์
//     );

//     if (result == null) return;

//     setState(() {
//       files = result.paths
//           .map((path) => File(path!))
//           .toList(); // แปลงรายการเป็นรายการของ File
//     });
//   }

//   bool _isImageFile(String filename) {
//     final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
//     urlDownload = extension(filename).toLowerCase();
//     return imageExtensions.contains(urlDownload);
//   }

//   bool _isVideoFile(String filename) {
//     final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv'];
//     food_video = extension(filename).toLowerCase();
//     return videoExtensions.contains(food_video);
//   }

//   Future<void> uploadFile() async {
//     String? assignImage = '';
//     String? assignVideo = '';
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final DocumentSnapshot snapshot =
//         await FirebaseFirestore.instance.collection("Foods").doc().get();
//     food_id = snapshot.id;

//     // Check if files are not selected
//     if (files.isEmpty) return;

//     // Loop through the selected files and upload them
//     for (int i = 0; i < files.length; i++) {
//       File file = files[i];
//       final filename = basename(file.path);
//       // Check the file extension to determine if it's an image or a video
//       bool isImage = _isImageFile(filename);
//       bool isVideo = _isVideoFile(filename);

//       if (isImage) {
//         final destination = 'files/$food_id/Image/$filename';
//         // Process the file as an image
//         task = FirebaseApi.uploadFile(
//             destination, file); // Assuming you have an 'uploadImage' method
//         setState(() {});

//         if (task == null) continue;

//         final snapshot2 = await task!.whenComplete(() {});
//         urlDownload = await snapshot2.ref.getDownloadURL();
//         assignImage = urlDownload.toString();
//       } else if (isVideo) {
//         final destination = 'files/$food_id/Video/$filename';
//         // Process the file as a video
//         task = FirebaseApi.uploadFile(
//             destination, file); // Assuming you have an 'uploadVideo' method
//         setState(() {});

//         if (task == null) continue;

//         final snapshot2 = await task!.whenComplete(() {});
//         food_video = await snapshot2.ref.getDownloadURL();
//         assignVideo = food_video.toString();
//       } else {
//         // Handle other types of files (if necessary)
//       }
//     }

//     Map<String, dynamic> dataMap = Map();
//     dataMap['Food_id'] = food_id;
//     dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
//     dataMap['Food_Image'] = assignImage!.isNotEmpty
//         ? assignImage
//         : 'https://firebasestorage.googleapis.com/v0/b/project-food-c14c5.appspot.com/o/files%2FsEumU49bYOWAdBkmHa8Y%2FImage%2Fpexels-jan-n-g-u-y-e-n-%F0%9F%8D%81-699953.jpg?alt=media&token=76353871-b2c3-4d9b-b484-71814e30328a';
//     dataMap['Food_Video'] = assignVideo!.isNotEmpty ? assignVideo : 'N/A';
//     dataMap['Food_Level'] = food_level!.isNotEmpty ? food_level : 'N/A';
//     dataMap['Food_Ingredients'] =
//         food_ingredients!.isNotEmpty ? food_ingredients : 'N/A';
//     dataMap['Food_Solution'] =
//         food_solution!.isNotEmpty ? food_solution : 'N/A';
//     dataMap['Food_Type'] = food_type!.isNotEmpty ? food_type : 'N/A';
//     dataMap['Food_Description'] =
//         food_description!.isNotEmpty ? food_description : 'N/A';
//     dataMap['Food_Time'] = food_time!.isNotEmpty ? food_time : 'N/A';
//     dataMap['Food_Nation'] = food_nation!.isNotEmpty ? food_nation : 'N/A';
//     dataMap['Food_Point'] = food_point!.isNotEmpty ? food_point : 'N/A';
//     dataMap['User_id'] = user?.uid;

//     await firestore.collection('Foods').doc().set(dataMap).then((value) {});
//   }
//   // Future<void> uploadFile() async {
//   //   String? assign;
//   //   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   //   final DocumentSnapshot snapshot =
//   //       await FirebaseFirestore.instance.collection("Foods").doc().get();
//   //   food_id = snapshot.id;

//   //   // Check if files are not selected
//   //   if (files.isEmpty) return;

//   //   // Loop through the selected files and upload them
//   //   for (int i = 0; i < files.length; i++) {
//   //     File file = files[i];
//   //     final filename = basename(file.path);
//   //     final destination = 'files/$food_id/$filename';

//   //     task = FirebaseApi.uploadFile(destination, file);
//   //     setState(() {});

//   //     if (task == null) continue;

//   //     final snapshot2 = await task!.whenComplete(() {});
//   //     final urlDownload = await snapshot2.ref.getDownloadURL();
//   //     assign = urlDownload.toString();
//   //   }

//   //   Map<String, dynamic> dataMap = Map();
//   //   dataMap['Food_id'] = food_id;
//   //   dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
//   //   dataMap['Food_Image'] = assign!;
//   //   dataMap['Food_Video'] = food_video!.isNotEmpty ? food_video : 'N/A';
//   //   dataMap['Food_Level'] = food_level!.isNotEmpty ? food_level : 'N/A';
//   //   dataMap['Food_Ingredients'] =
//   //       food_ingredients!.isNotEmpty ? food_ingredients : 'N/A';
//   //   dataMap['Food_Solution'] =
//   //       food_solution!.isNotEmpty ? food_solution : 'N/A';
//   //   dataMap['Food_Type'] = food_type!.isNotEmpty ? food_type : 'N/A';
//   //   dataMap['Food_Description'] =
//   //       food_description!.isNotEmpty ? food_description : 'N/A';
//   //   dataMap['Food_Time'] = food_time!.isNotEmpty ? food_time : 'N/A';
//   //   dataMap['Food_Nation'] = food_nation!.isNotEmpty ? food_nation : 'N/A';
//   //   dataMap['Food_Point'] = food_point!.isNotEmpty ? food_point : 'N/A';
//   //   dataMap['User_id'] = user?.uid;

//   //   await firestore.collection('Foods').doc().set(dataMap).then((value) {});
//   // }

//   //Upload Status %
//   Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//         stream: task.snapshotEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!; //snapshot data
//             final progress = snap.bytesTransferred /
//                 snap.totalBytes; //% progress raw percent
//             final percen =
//                 (progress * 100).toStringAsFixed(2); //Percent 100% 0.00
//             return Text(
//               '$percen %',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             );
//           } else {
//             return Container();
//           }
//         },
//       );

//   // Future<void> getFoodIdFromCollection() async {
//   //   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   //   // Get the collection reference
//   //   CollectionReference foodCollection = firestore.collection('Foods');

//   //   // Retrieve all documents in the collection
//   //   QuerySnapshot querySnapshot = await foodCollection.get();

//   //   // Loop through each document to get the ID
//   //   for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
//   //     // Access the document ID using docSnapshot.id
//   //     String foodId = docSnapshot.id;
//   //     // or store it in the food_id variable
//   //   }
//   // }

//   //Insert Data To firebase
//   // Future<void> insertDataToFireStore() async {
//   //   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   //   final docUser = FirebaseFirestore.instance.collection('Foods').doc();

//   //   Map<String, dynamic> dataMap = Map();
//   //   //dynamic = data type everything
//   //   dataMap['Food_id'] = food_id;
//   //   dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
//   //   dataMap['Food_Image'] = urlDownload;
//   //   dataMap['Food_Video'] = food_video!.isNotEmpty ? food_video : 'N/A';
//   //   dataMap['Food_Level'] = food_level!.isNotEmpty ? food_level : 'N/A';
//   //   dataMap['Food_Ingredients'] =
//   //       food_ingredients!.isNotEmpty ? food_ingredients : 'N/A';
//   //   dataMap['Food_Solution'] =
//   //       food_solution!.isNotEmpty ? food_solution : 'N/A';
//   //   dataMap['Food_Type'] = food_type!.isNotEmpty ? food_type : 'N/A';
//   //   dataMap['Food_Description'] =
//   //       food_description!.isNotEmpty ? food_description : 'N/A';
//   //   dataMap['Food_Time'] = food_time!.isNotEmpty ? food_time : 'N/A';
//   //   dataMap['Food_Nation'] = food_nation!.isNotEmpty ? food_nation : 'N/A';
//   //   dataMap['Food_Point'] = food_point!.isNotEmpty ? food_point : 'N/A';
//   //   //dataMap['User_id'] = "Worapong";
//   //   dataMap['User_id'] = user?.uid;

//   //   await firestore.collection('Foods').doc().set(dataMap).then((value) {});
//   // }

//   void onNameChanged(String value) {
//     setState(() {
//       food_name = value.trim();
//     });
//   }

//   Widget name(context) {
//     return TextField(
//       onChanged: onNameChanged,
//       decoration: InputDecoration(
//         labelText: 'ชื่ออาหาร',
//         hintText: 'กรุณากรอกชื่ออาหาร',
//         icon: Icon(Icons.format_align_center),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       keyboardType: TextInputType.text,
//     );
//   }

//   Widget level(context) {
//     String foodLevel = 'ง่าย'; // กำหนดค่าเริ่มต้น

//     return DropdownButtonFormField<String>(
//       value: foodLevel,
//       onChanged: (value) {
//         setState(() {
//           foodLevel = value.toString();
//           food_level = foodLevel;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'ความยากในการทำ',
//         hintText: 'กรุณาเลือกความยากในการทำ',
//         icon: Icon(Icons.point_of_sale),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       items: <DropdownMenuItem<String>>[
//         DropdownMenuItem<String>(
//           value: 'ง่าย',
//           child: Text('ง่าย'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ปานกลาง',
//           child: Text('ปานกลาง'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ยาก',
//           child: Text('ยาก'),
//         ),
//       ],
//     );
//   }

//   Widget ingredients(context) {
//     return TextField(
//       onChanged: (value) {
//         food_ingredients = value.trim();
//       },
//       decoration: InputDecoration(
//         labelText: 'วัตถุดิบ',
//         hintText: 'กรุณากรอกวัตถุดิบ',
//         icon: Icon(Icons.dinner_dining),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       keyboardType: TextInputType.text,
//     );
//   }

//   Widget solution(context) {
//     return TextField(
//         onChanged: (value) {
//           food_solution = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'วิธีการทำ',
//           hintText: 'กรุณากรอกวิธีการทำ',
//           icon: Icon(Icons.solar_power_outlined),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget type(context) {
//     String foodtype = 'ฟาสต์ฟู้ด'; // กำหนดค่าเริ่มต้น

//     return DropdownButtonFormField<String>(
//       value: foodtype,
//       onChanged: (value) {
//         setState(() {
//           foodtype = value.toString();
//           food_type = foodtype;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'ความยากในการทำ',
//         hintText: 'กรุณาเลือกความยากในการทำ',
//         icon: Icon(Icons.point_of_sale),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       items: <DropdownMenuItem<String>>[
//         DropdownMenuItem<String>(
//           value: 'ฟาสต์ฟู้ด',
//           child: Text('ฟาสต์ฟู้ด'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ของหวาน',
//           child: Text('ของหวาน'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'เครื่องดื่ม/น้ำผลไม้',
//           child: Text('เครื่องดื่ม/น้ำผลไม้'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'อาหารเจ',
//           child: Text('อาหารเจ'),
//         ),
//       ],
//     );
//   }

//   Widget description(context) {
//     return TextField(
//         onChanged: (value) {
//           food_description = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'รายละเอียดอาหาร',
//           hintText: 'กรุณากรอกรายละเอียดอาหาร',
//           icon: Icon(Icons.description),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget time(context) {
//     return TextField(
//         onChanged: (value) {
//           food_time = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'เวลาในการทำ',
//           hintText: 'กรุณากรอกเวลาในการทำ',
//           icon: Icon(Icons.description),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget nation(context) {
//     String foodnation = 'ไทย'; // กำหนดค่าเริ่มต้น

//     return DropdownButtonFormField<String>(
//       value: foodnation,
//       onChanged: (value) {
//         setState(() {
//           foodnation = value.toString();
//           food_nation = foodnation;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'ความยากในการทำ',
//         hintText: 'กรุณาเลือกความยากในการทำ',
//         icon: Icon(Icons.point_of_sale),
//         border:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         enabledBorder:
//             OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//         filled: true,
//         contentPadding: const EdgeInsets.all(8),
//       ),
//       items: <DropdownMenuItem<String>>[
//         DropdownMenuItem<String>(
//           value: 'ไทย',
//           child: Text('ไทย'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'ญี่ปุ่น',
//           child: Text('ญี่ปุ่น'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'เกาหลี',
//           child: Text('เกาหลี'),
//         ),
//         DropdownMenuItem<String>(
//           value: 'อิตาลี',
//           child: Text('อิตาลี'),
//         ),
//       ],
//     );
//   }

//   Widget point(context) {
//     return TextField(
//         onChanged: (value) {
//           food_point = value.trim();
//         },
//         decoration: InputDecoration(
//           labelText: 'คะแนนอาหาร',
//           hintText: 'กรุณากรอกคะแนนอาหาร',
//           icon: Icon(Icons.description),
//           border:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           focusedBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           enabledBorder:
//               OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//           filled: true,
//           contentPadding: const EdgeInsets.all(8),
//         ),
//         keyboardType: TextInputType.text);
//   }

//   Widget showForm(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             //Text('ชื่ออาหาร'),
//             name(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('เลเวล'),
//             level(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('วัตถุดิบ'),
//             ingredients(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('วิธีทำ'),
//             solution(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('ประเภทอาหาร'),
//             type(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('รายละเอียด'),
//             description(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('เวลาในการทำ'),
//             time(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             //Text('สัญชาติอาหาร'),
//             nation(context),
//             SizedBox(
//               height: 10.0,
//             ),
//             point(context),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filename = file != null
//         ? basename(file!.path)
//         : 'ยังไม่มีไฟล์ที่เลือก!'; //set basename
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Upload Food'),
//       //   centerTitle: true,
//       //   ),

//       body: Container(
//         padding: EdgeInsets.all(32),
//         child: Container(
//             child: ListView(
//           //mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             if (pickedFile != null)
//               Expanded(
//                 child: Container(
//                   color: Colors.amber,
//                   child: Image.file(
//                     File(pickedFile!.path!),
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             SizedBox(
//               height: 15.0,
//             ),
//             ButtonWidget(
//                 //Button Select file
//                 icon: Icons.attach_file,
//                 text: 'เลือกไฟล์',
//                 onClick: selectFile),

//             //Under filename for "Spacebar naja"
//             SizedBox(
//               height: 15.0,
//             ),
//             showForm(context),
//             SizedBox(
//               height: 15.0,
//             ),
//             ButtonWidget(
//                 //Button Upload file
//                 icon: Icons.upload_file_sharp,
//                 text: 'อัพโหลด',
//                 onClick: uploadFile),

//             task != null ? buildUploadStatus(task!) : Container() //Percent
//           ],
//         )),
//       ),
//     );
//   }
// }
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import '../../Api/firebase_api.dart';
//import 'package:se_project_food/Models/user.dart' hide User;
import '../../Models/foodmodels.dart';
import '../../Models/user.dart' as usermodel;
import '../../Widgets/button_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadFood extends StatefulWidget {
  const UploadFood({Key? key}) : super(key: key);

  @override
  State<UploadFood> createState() => _UploadFoodState();
}

class _UploadFoodState extends State<UploadFood> {
  UploadTask? task;
//final User? user = AuthenticationController().currentUser;
  User? user = AuthenticationController().currentUser;
  //Rx<User?> _currentUser;

  File? file; //file can null
  PlatformFile? pickedFile;
  String? food_id;
  String? urlDownload,
      food_name = '',
      food_video,
      food_level = '',
      food_ingredients = '',
      food_solution = '',
      food_type = '',
      food_description = '',
      food_time = '',
      food_nation = '',
      food_point = '';

  //Current UID
  Widget _userUID() {
    return Text(user?.uid ?? 'User UID');
  }

  List<File> files = []; // List เก็บรูปภาพที่ถูกเลือก

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // เปลี่ยนเป็น true เพื่อให้เลือกหลายไฟล์
    );

    if (result == null) return;

    setState(() {
      files = result.paths
          .map((path) => File(path!))
          .toList(); // แปลงรายการเป็นรายการของ File
    });
  }

  bool _isImageFile(String filename) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    urlDownload = extension(filename).toLowerCase();
    return imageExtensions.contains(urlDownload);
  }

  bool _isVideoFile(String filename) {
    final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv'];
    food_video = extension(filename).toLowerCase();
    return videoExtensions.contains(food_video);
  }

  Future<void> uploadFile() async {
    String? assignImage = '';
    String? ProfileImage = '';
    String? assignVideo = '';
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("Foods").doc().get();
    food_id = snapshot.id;

    // Check if files are not selected
    if (files.isEmpty) return;

    // Loop through the selected files and upload them
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      final filename = basename(file.path);
      // Check the file extension to determine if it's an image or a video
      bool isImage = _isImageFile(filename);
      bool isVideo = _isVideoFile(filename);

      if (isImage) {
        final destination = 'files/$food_id/Image/$filename';
        // Process the file as an image
        task = FirebaseApi.uploadFile(
            destination, file); // Assuming you have an 'uploadImage' method
        setState(() {});

        if (task == null) continue;

        final snapshot2 = await task!.whenComplete(() {});
        urlDownload = await snapshot2.ref.getDownloadURL();
        assignImage = urlDownload.toString();
        if (i == 0) {
          assignImage = urlDownload.toString();
          ProfileImage = assignImage;
          //break;
        }
      } else if (isVideo) {
        final destination = 'files/$food_id/Video/$filename';
        // Process the file as a video
        task = FirebaseApi.uploadFile(
            destination, file); // Assuming you have an 'uploadVideo' method
        setState(() {});

        if (task == null) continue;

        final snapshot2 = await task!.whenComplete(() {});
        food_video = await snapshot2.ref.getDownloadURL();
        assignVideo = food_video.toString();
      } else {
        // Handle other types of files (if necessary)
      }
    }

    Map<String, dynamic> dataMap = Map();
    dataMap['Food_id'] = food_id;
    dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
    dataMap['Food_Image'] = ProfileImage!.isNotEmpty
        ? ProfileImage
        : 'https://firebasestorage.googleapis.com/v0/b/project-food-c14c5.appspot.com/o/files%2FsEumU49bYOWAdBkmHa8Y%2FImage%2Fpexels-jan-n-g-u-y-e-n-%F0%9F%8D%81-699953.jpg?alt=media&token=76353871-b2c3-4d9b-b484-71814e30328a';
    dataMap['Food_Video'] = assignVideo!.isNotEmpty ? assignVideo : 'N/A';
    dataMap['Food_Level'] = food_level!.isNotEmpty ? food_level : 'N/A';
    dataMap['Food_Ingredients'] =
        food_ingredients!.isNotEmpty ? food_ingredients : 'N/A';
    dataMap['Food_Solution'] =
        food_solution!.isNotEmpty ? food_solution : 'N/A';
    dataMap['Food_Type'] = food_type!.isNotEmpty ? food_type : 'N/A';
    dataMap['Food_Description'] =
        food_description!.isNotEmpty ? food_description : 'N/A';
    dataMap['Food_Time'] = food_time!.isNotEmpty ? food_time : 'N/A';
    dataMap['Food_Nation'] = food_nation!.isNotEmpty ? food_nation : 'N/A';
    dataMap['Food_Point'] = food_point!.isNotEmpty ? food_point : 'N/A';
    dataMap['User_id'] = user?.uid;

    await firestore.collection('Foods').doc().set(dataMap).then((value) {});
  }
  // Future<void> uploadFile() async {
  //   String? assign;
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   final DocumentSnapshot snapshot =
  //       await FirebaseFirestore.instance.collection("Foods").doc().get();
  //   food_id = snapshot.id;

  //   // Check if files are not selected
  //   if (files.isEmpty) return;

  //   // Loop through the selected files and upload them
  //   for (int i = 0; i < files.length; i++) {
  //     File file = files[i];
  //     final filename = basename(file.path);
  //     final destination = 'files/$food_id/$filename';

  //     task = FirebaseApi.uploadFile(destination, file);
  //     setState(() {});

  //     if (task == null) continue;

  //     final snapshot2 = await task!.whenComplete(() {});
  //     final urlDownload = await snapshot2.ref.getDownloadURL();
  //     assign = urlDownload.toString();
  //   }

  //   Map<String, dynamic> dataMap = Map();
  //   dataMap['Food_id'] = food_id;
  //   dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
  //   dataMap['Food_Image'] = assign!;
  //   dataMap['Food_Video'] = food_video!.isNotEmpty ? food_video : 'N/A';
  //   dataMap['Food_Level'] = food_level!.isNotEmpty ? food_level : 'N/A';
  //   dataMap['Food_Ingredients'] =
  //       food_ingredients!.isNotEmpty ? food_ingredients : 'N/A';
  //   dataMap['Food_Solution'] =
  //       food_solution!.isNotEmpty ? food_solution : 'N/A';
  //   dataMap['Food_Type'] = food_type!.isNotEmpty ? food_type : 'N/A';
  //   dataMap['Food_Description'] =
  //       food_description!.isNotEmpty ? food_description : 'N/A';
  //   dataMap['Food_Time'] = food_time!.isNotEmpty ? food_time : 'N/A';
  //   dataMap['Food_Nation'] = food_nation!.isNotEmpty ? food_nation : 'N/A';
  //   dataMap['Food_Point'] = food_point!.isNotEmpty ? food_point : 'N/A';
  //   dataMap['User_id'] = user?.uid;

  //   await firestore.collection('Foods').doc().set(dataMap).then((value) {});
  // }

  //Upload Status %
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!; //snapshot data
            final progress = snap.bytesTransferred /
                snap.totalBytes; //% progress raw percent
            final percen =
                (progress * 100).toStringAsFixed(2); //Percent 100% 0.00
            return Text(
              '$percen %',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
          } else {
            return Container();
          }
        },
      );

  // Future<void> getFoodIdFromCollection() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   // Get the collection reference
  //   CollectionReference foodCollection = firestore.collection('Foods');

  //   // Retrieve all documents in the collection
  //   QuerySnapshot querySnapshot = await foodCollection.get();

  //   // Loop through each document to get the ID
  //   for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //     // Access the document ID using docSnapshot.id
  //     String foodId = docSnapshot.id;
  //     // or store it in the food_id variable
  //   }
  // }

  //Insert Data To firebase
  // Future<void> insertDataToFireStore() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   final docUser = FirebaseFirestore.instance.collection('Foods').doc();

  //   Map<String, dynamic> dataMap = Map();
  //   //dynamic = data type everything
  //   dataMap['Food_id'] = food_id;
  //   dataMap['Food_Name'] = food_name!.isNotEmpty ? food_name : 'N/A';
  //   dataMap['Food_Image'] = urlDownload;
  //   dataMap['Food_Video'] = food_video!.isNotEmpty ? food_video : 'N/A';
  //   dataMap['Food_Level'] = food_level!.isNotEmpty ? food_level : 'N/A';
  //   dataMap['Food_Ingredients'] =
  //       food_ingredients!.isNotEmpty ? food_ingredients : 'N/A';
  //   dataMap['Food_Solution'] =
  //       food_solution!.isNotEmpty ? food_solution : 'N/A';
  //   dataMap['Food_Type'] = food_type!.isNotEmpty ? food_type : 'N/A';
  //   dataMap['Food_Description'] =
  //       food_description!.isNotEmpty ? food_description : 'N/A';
  //   dataMap['Food_Time'] = food_time!.isNotEmpty ? food_time : 'N/A';
  //   dataMap['Food_Nation'] = food_nation!.isNotEmpty ? food_nation : 'N/A';
  //   dataMap['Food_Point'] = food_point!.isNotEmpty ? food_point : 'N/A';
  //   //dataMap['User_id'] = "Worapong";
  //   dataMap['User_id'] = user?.uid;

  //   await firestore.collection('Foods').doc().set(dataMap).then((value) {});
  // }

  void onNameChanged(String value) {
    setState(() {
      food_name = value.trim();
    });
  }

  Widget name(context) {
    return TextField(
      onChanged: onNameChanged,
      decoration: InputDecoration(
        labelText: 'ชื่ออาหาร',
        hintText: 'กรุณากรอกชื่ออาหาร',
        icon: Icon(Icons.format_align_center),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget level(context) {
    String foodLevel = 'ง่าย'; // กำหนดค่าเริ่มต้น

    return DropdownButtonFormField<String>(
      value: foodLevel,
      onChanged: (value) {
        setState(() {
          foodLevel = value.toString();
          food_level = foodLevel;
        });
      },
      decoration: InputDecoration(
        labelText: 'ความยากในการทำ',
        hintText: 'กรุณาเลือกความยากในการทำ',
        icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ง่าย',
          child: Text('ง่าย'),
        ),
        DropdownMenuItem<String>(
          value: 'ปานกลาง',
          child: Text('ปานกลาง'),
        ),
        DropdownMenuItem<String>(
          value: 'ยาก',
          child: Text('ยาก'),
        ),
      ],
    );
  }

  Widget ingredients(context) {
    return TextField(
      onChanged: (value) {
        food_ingredients = value.trim();
      },
      decoration: InputDecoration(
        labelText: 'วัตถุดิบ',
        hintText: 'กรุณากรอกวัตถุดิบ',
        icon: Icon(Icons.dinner_dining),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: TextInputType.text,
    );
  }

  Widget solution(context) {
    return TextField(
        onChanged: (value) {
          food_solution = value.trim();
        },
        decoration: InputDecoration(
          labelText: 'วิธีการทำ',
          hintText: 'กรุณากรอกวิธีการทำ',
          icon: Icon(Icons.solar_power_outlined),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: TextInputType.text);
  }

  Widget type(context) {
    String foodtype = 'ฟาสต์ฟู้ด'; // กำหนดค่าเริ่มต้น

    return DropdownButtonFormField<String>(
      value: foodtype,
      onChanged: (value) {
        setState(() {
          foodtype = value.toString();
          food_type = foodtype;
        });
      },
      decoration: InputDecoration(
        labelText: 'ความยากในการทำ',
        hintText: 'กรุณาเลือกความยากในการทำ',
        icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ฟาสต์ฟู้ด',
          child: Text('ฟาสต์ฟู้ด'),
        ),
        DropdownMenuItem<String>(
          value: 'ของหวาน',
          child: Text('ของหวาน'),
        ),
        DropdownMenuItem<String>(
          value: 'เครื่องดื่ม/น้ำผลไม้',
          child: Text('เครื่องดื่ม/น้ำผลไม้'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารเจ',
          child: Text('อาหารเจ'),
        ),
      ],
    );
  }

  Widget description(context) {
    return TextField(
        onChanged: (value) {
          food_description = value.trim();
        },
        decoration: InputDecoration(
          labelText: 'รายละเอียดอาหาร',
          hintText: 'กรุณากรอกรายละเอียดอาหาร',
          icon: Icon(Icons.description),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: TextInputType.text);
  }

  Widget time(context) {
    return TextField(
        onChanged: (value) {
          food_time = value.trim();
        },
        decoration: InputDecoration(
          labelText: 'เวลาในการทำ',
          hintText: 'กรุณากรอกเวลาในการทำ',
          icon: Icon(Icons.description),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: TextInputType.text);
  }

  Widget nation(context) {
    String foodnation = 'ไทย'; // กำหนดค่าเริ่มต้น

    return DropdownButtonFormField<String>(
      value: foodnation,
      onChanged: (value) {
        setState(() {
          foodnation = value.toString();
          food_nation = foodnation;
        });
      },
      decoration: InputDecoration(
        labelText: 'ความยากในการทำ',
        hintText: 'กรุณาเลือกความยากในการทำ',
        icon: Icon(Icons.point_of_sale),
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      items: <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ไทย',
          child: Text('ไทย'),
        ),
        DropdownMenuItem<String>(
          value: 'ญี่ปุ่น',
          child: Text('ญี่ปุ่น'),
        ),
        DropdownMenuItem<String>(
          value: 'เกาหลี',
          child: Text('เกาหลี'),
        ),
        DropdownMenuItem<String>(
          value: 'อิตาลี',
          child: Text('อิตาลี'),
        ),
      ],
    );
  }

  Widget point(context) {
    return TextField(
        onChanged: (value) {
          food_point = value.trim();
        },
        decoration: InputDecoration(
          labelText: 'คะแนนอาหาร',
          hintText: 'กรุณากรอกคะแนนอาหาร',
          icon: Icon(Icons.description),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          focusedBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        keyboardType: TextInputType.text);
  }

  Widget showForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Text('ชื่ออาหาร'),
            name(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('เลเวล'),
            level(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('วัตถุดิบ'),
            ingredients(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('วิธีทำ'),
            solution(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('ประเภทอาหาร'),
            type(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('รายละเอียด'),
            description(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('เวลาในการทำ'),
            time(context),
            SizedBox(
              height: 10.0,
            ),
            //Text('สัญชาติอาหาร'),
            nation(context),
            SizedBox(
              height: 10.0,
            ),
            point(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filename = file != null
        ? basename(file!.path)
        : 'ยังไม่มีไฟล์ที่เลือก!'; //set basename
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upload Food'),
      //   centerTitle: true,
      //   ),

      body: Container(
        padding: EdgeInsets.all(32),
        child: Container(
            child: ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (pickedFile != null)
              Expanded(
                child: Container(
                  color: Colors.amber,
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(
              height: 15.0,
            ),
            ButtonWidget(
                //Button Select file
                icon: Icons.attach_file,
                text: 'เลือกไฟล์',
                onClick: selectFile),

            //Under filename for "Spacebar naja"
            SizedBox(
              height: 15.0,
            ),
            showForm(context),
            SizedBox(
              height: 15.0,
            ),
            ButtonWidget(
                //Button Upload file
                icon: Icons.upload_file_sharp,
                text: 'อัพโหลด',
                onClick: uploadFile),

            task != null ? buildUploadStatus(task!) : Container() //Percent
          ],
        )),
      ),
    );
  }
}
