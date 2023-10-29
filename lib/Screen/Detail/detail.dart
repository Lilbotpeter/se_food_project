import 'dart:io';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:se_project_food/Api/firebase_api.dart';
import 'package:se_project_food/Screen/Detail/stepview.dart';
import 'package:se_project_food/Screen/Profile/user_link_profile.dart';
import 'package:se_project_food/Widgets/button_widget.dart';
import 'package:se_project_food/Widgets/custom_icon.dart';
import 'package:se_project_food/Widgets/profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:se_project_food/constants.dart';
import 'package:intl/intl.dart';
import 'package:se_project_food/service.dart';
import 'package:video_player/video_player.dart';

import '../../Authen/authen_part.dart';
import '../../Models/foodmodels.dart';
import '../../Widgets/video_player.dart';
import '../../calculator.dart';
import '../../follow.dart';
import '../../global.dart';
import '../video_food.dart';
import 'detailReplyComment.dart';
import 'detailReplyMod.dart';
import 'detailReplyReview.dart';
import 'detail_service.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({super.key});

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  //Food
  List<FoodModel> foodModels = [];
  final followerService = FollowerService();
  List<String> imageUrls = [];
  List<String> videoUrls = [];

  late String getIDbook;
  int rating = 0;
  String? name_food = '';
  String? description_food = '';
  String? level_food = '';
  String? ingradent_food = '';
  String? nation_food = '';
  String? point_food = '';
  String? time_food = '';
  String? type_food = '';
  String? solution_food, image_food = '';
  String? id_food = '';
  String? user_id;
  //User
  String? name = '';
  String? image = '';
  String? email = '';
  String? phone = '';
  File? imageXFile;
  final TextEditingController SenWork = TextEditingController();
  final TextEditingController Review = TextEditingController();
  final TextEditingController Comment = TextEditingController();
  final TextEditingController ReplyMod = TextEditingController();
  final TextEditingController ReplyComment = TextEditingController();
  final TextEditingController ReplyReview = TextEditingController();
  int _rating = 0;
  String? id;
  List<String> urls = [];
  List<dynamic> modifyList = [];
  List<dynamic> reviewList = [];
  List<dynamic> reviewCountList = [];
  List<dynamic> modCountList = [];
  List<dynamic> commentCountList = [];
  List<dynamic> commentList = [];
  List<List<String>> AllImageAllImageModify = [];
  List<List<String>> AllImageAllImageReview = [];
  // List<List<String>> AllImage = [];
  //AuthenticationController auth = AuthenticationController.instanceAuth;

  String? FoodtypeReport = 'ใช้คำพูดที่ไม่เหมาะสม';
  TextEditingController Fooddetail = TextEditingController();

  final String getfoodID = Get.arguments as String; //รับ Food ID

  final userid = FirebaseAuth.instance.currentUser!.uid;
  //late VideoPlayerController _controller;

  DataService dataService = DataService();

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  List<File> files = []; // List เก็บรูปภาพที่ถูกเลือก
  UploadTask? task;
  String? urlDownload,
      food_video,
      commentModifyfood = '',
      commentReview = '',
      commentComment = '',
      replyMod = '',
      replyComment = '',
      replyReview = '';

  String? idComment;
  String? idReview;
  String? idMod;
  List<List<String>> imageUrlsList = [];
  List<List<String>> imageUrlsListMofify = [];
  List<dynamic>? dataUser;

  //get index => null; // รายการของรายการรูปภาพในแต่ละรีวิว

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

  Future<void> uploadFileModify() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore
        .collection("ModifyFood")
        .doc(id_food!)
        .collection("ModID")
        .doc();

    if (files.isEmpty) {
      print("No files selected");
      Get.snackbar('หัวข้อ', 'อัปโหลดไม่สำเร็จ');
      return;
    }
    try {
      Map<String, dynamic> dataMap = {
        'ID_Food': id_food,
        'ID_Mod': foodDocRef.id,
        'Image': urlDownload,
        'Video': food_video,
        'Comment': commentModifyfood,
        'Time': Timestamp.now(),
        'Uid': userid,

        //'Time' : Timestamp.now(),
      };
      //s String? profileImage;
      // Loop through the selected files and upload them
      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        final filename = basename(file.path);

        bool isImage = _isImageFile(filename);
        bool isVideo = _isVideoFile(filename);

        if (isImage || isVideo) {
          final String mediaType = isImage ? 'Image' : 'Video';
          final destination =
              'ModifyFood/${foodDocRef.id}/$mediaType/$filename';
          task = FirebaseApi.uploadFile(destination, file);

          if (task == null) continue;

          final snapshot2 = await task!.whenComplete(() {});
          final downloadURL = await snapshot2.ref.getDownloadURL();

          // if (i == 0) {
          //   profileImage = downloadURL;
          // }

          if (isImage) {
            dataMap['Image'] = downloadURL;
            //profileImage = null;
          } else {
            dataMap['Video'] = downloadURL;
          }
        } else {
          // Handle other types of files (if necessary)
        }
      }
      //try {
      await foodDocRef.set(dataMap);
      //setState(() {
      files.clear();
      //});
      Get.snackbar('หัวข้อ', 'อัปโหลดสำเร็จ');
      print("Upload complete");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<String> getname(userid) async {
    Map<String, dynamic> userData = await dataService.getUser(userid);
    String udata = userData['Name'];
    return udata;
  }

  Future<void> uploadFileComment() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore
        .collection("CommentFood")
        .doc(id_food!)
        .collection("CommentID")
        .doc();
    try {
      Map<String, dynamic> dataMap = {
        'ID_Food': id_food,
        'ID_Comment': foodDocRef.id,
        'Comment': commentComment,
        'Time': Timestamp.now(),
        'Uid': userid,
      };
      await foodDocRef.set(dataMap);
      print("Upload complete");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> uploadFileReview() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore
        .collection("ReviewFood")
        .doc(id_food!)
        .collection("ReviewID")
        .doc();
    if (files.isEmpty) {
      print("No files selected");
      Get.snackbar('หัวข้อ', 'อัปโหลดไม่สำเร็จ');
      return;
    }
    try {
      Map<String, dynamic> dataMap = {
        'ID_Food': id_food,
        'ID_Review': foodDocRef.id,
        'Uid': userid,
        'Image': urlDownload,
        'Video': food_video,
        'Comment': commentReview,
        'Rating': rating,
        'Time': Timestamp.now(),
      };
      //s String? profileImage;
      // Loop through the selected files and upload them
      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        final filename = basename(file.path);

        bool isImage = _isImageFile(filename);
        bool isVideo = _isVideoFile(filename);

        if (isImage || isVideo) {
          final String mediaType = isImage ? 'Image' : 'Video';
          final destination =
              'ReviewFood/${foodDocRef.id}/$mediaType/$filename';
          task = FirebaseApi.uploadFile(destination, file);

          if (task == null) continue;

          final snapshot2 = await task!.whenComplete(() {});
          final downloadURL = await snapshot2.ref.getDownloadURL();

          // if (i == 0) {
          //   profileImage = downloadURL;
          // }

          if (isImage) {
            dataMap['Image'] = downloadURL;
            //profileImage = null;
          } else {
            dataMap['Video'] = downloadURL;
          }
        } else {
          // Handle other types of files (if necessary)
        }
      }
      //try {
      await foodDocRef.set(dataMap);
      //setState(() {
      files.clear();
      //});
      Get.snackbar('หัวข้อ', 'อัปโหลดสำเร็จ');
      print("Upload complete");
    } catch (e) {
      print("Error: $e");
    }
  }

  void _setRating(int value) {
    //setState(() {
    _rating = value;
    //});
  }

  Future<void> uploadFileReplyComment() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore
        .collection("ReplyComment")
        .doc(idComment)
        .collection("ReplyCommentID")
        .doc();
    try {
      Map<String, dynamic> dataMap = {
        'ID_Comment': idComment,
        'ID_ReplyComment': foodDocRef.id,
        'Comment': replyComment,
        'Time': Timestamp.now(),
        'Uid': userid,
      };
      await foodDocRef.set(dataMap);
      print("Upload complete");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> uploadFileReplyMod() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore
        .collection("ReplyMod")
        .doc(idMod)
        .collection("ReplyModID")
        .doc();
    try {
      Map<String, dynamic> dataMap = {
        'ID_Mod': idMod,
        'ID_ReplyMod': foodDocRef.id,
        'Comment': replyMod,
        'Time': Timestamp.now(),
        'Uid': userid,
      };
      await foodDocRef.set(dataMap);
      print("Upload complete");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> uploadFileReplyReview() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference foodDocRef = firestore
        .collection("ReplyReview")
        .doc(idReview)
        .collection("ReplyReviewID")
        .doc();
    try {
      Map<String, dynamic> dataMap = {
        'ID_Review': idReview,
        'ID_ReplyReview': foodDocRef.id,
        'Comment': replyReview,
        'Time': Timestamp.now(),
        'Uid': userid,
      };
      await foodDocRef.set(dataMap);
      print("Upload complete");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getDataFromDatabase() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();

    if (snapshot.exists) {
      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          name_food = data["Food_Name"];
          description_food = data["Food_Description"];
          level_food = data["Food_Level"];
          ingradent_food = data["Food_Ingredients"];
          solution_food = data["Food_Solution"];
          nation_food = data["Food_Nation"];
          point_food = data["Food_Point"];
          time_food = data["Food_Time"];
          type_food = data["Food_Type"];
          image_food = data["Food_Image"];
          id_food = data['Food_id'];
          user_id = data["User_id"]; // อัปเดตค่า user_id ด้วยข้อมูลใน Firestore
        });
        await _getUserDataFromDatabase(user_id);
        CalculatorService calculatorService = CalculatorService();

        try {
          await calculatorService.calRating();
          // ทำสิ่งที่คุณต้องการกับผลลัพธ์หลังจากการคำนวณคะแนน
        } catch (e) {
          // จัดการข้อผิดพลาดที่เกิดขึ้นหากมี
          print('เกิดข้อผิดพลาด: $e');
        }
      }
    }
  }

//เอาข้อมูลผู้ใช้ออกมา
  Future<void> _getUserDataFromDatabase(String? id) async {
    if (id != null) {
      try {
        // List<dynamic> reviewList = await DetailService()
        //     .fetchReviewData('Review', '6kWGTLvH3DCd0lT4Rj6c', 'ReviewID');

        setState(() {
          dataUser =
              reviewList; // กำหนดค่า dataUser เป็น List<dynamic> ที่ได้จากการเรียกใช้ fetchReviewData
        });
        final snapshot =
            await FirebaseFirestore.instance.collection("users").doc(id).get();

        if (snapshot.exists) {
          setState(() {
            name = snapshot.data()!["Name"];
            email = snapshot.data()!["Email"];
            phone = snapshot.data()!["Phone"];
            image = snapshot.data()!["ImageP"];
          });
        } else {
          print("ไม่พบข้อมูลผู้ใช้ใน Firestore");
        }
      } catch (e) {
        print("เกิดข้อผิดพลาดในการค้นหาข้อมูลผู้ใช้: $e");
      }
    }
  }

  ///////////////////////////////////ImagesFromStorage
  Future<void> _getImagesFromStorage(String? id) async {
    try {
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      // ดึงรายการรูปภาพและวิดีโอจากโฟลเดอร์ "files" ในโฟลเดอร์ที่มีชื่อเป็น id
      final firebase_storage.ListResult result =
          await storage.ref().child('files').child('$id').listAll();

      // ตรวจสอบว่ามีรูปภาพและวิดีโอในโฟลเดอร์หรือไม่
      if (result.items.isNotEmpty) {
        for (var ref in result.items) {
          // ดึง URL และเพิ่มในรายการ imageUrls
          final url = await ref.getDownloadURL();
          setState(() {
            imageUrls.add(url);
            print('URL: $url');
          });
        }
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการดึงรูปภาพและวิดีโอ: $e");
    }
  }

  Future<void> _fetch() async {
    try {
      List<List<String>> imageUrlsReview = await DetailService()
          .fetchImagesReview('ReviewFood', id_food!, 'ReviewID');
      AllImageAllImageReview = imageUrlsReview;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchImagesReview ที่นี่
      print('Error in fetchImagesReview: $e');
    }

    try {
      List<List<String>> imageUrlsModify = await DetailService()
          .fetchImagesModify('ModifyFood', id_food!, 'ModID');
      AllImageAllImageModify = imageUrlsModify;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchImagesModify ที่นี่
      print('Error in fetchImagesModify: $e');
    }

    try {
      List<dynamic> MofifyList = await DetailService()
          .fetchModifyData('ModifyFood', id_food!, 'ModID');
      MofifyList.sort((a, b) => b['Time'].compareTo(a['Time']));
      modifyList = MofifyList;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchReviewData ที่นี่
      print('Error in fetchReviewData (Modify): $e');
    }

    try {
      List<dynamic> ReviewList = await DetailService()
          .fetchReviewData('ReviewFood', id_food!, 'ReviewID');
      ReviewList.sort((a, b) => b['Time'].compareTo(a['Time']));
      reviewList = ReviewList;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchReviewData (Review) ที่นี่
      print('Error in fetchReviewData (Review): $e');
    }
    try {
      List<dynamic> CommentList = await DetailService()
          .fetchCommentData('CommentFood', id_food!, 'CommentID');
      CommentList.sort((a, b) => b['Time'].compareTo(a['Time']));
      commentList = CommentList;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchReviewData (Review) ที่นี่
      print('Error in fetchCommentData (Comment): $e');
    }

    try {
      List<dynamic> ReviewList = await DetailService()
          .CountReviewData('ReviewFood', id_food!, 'ReviewID');
      reviewCountList = ReviewList;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchReviewData (Review) ที่นี่
      print('Error in fetchReviewData (Review): $e');
    }

    try {
      List<dynamic> ReviewList =
          await DetailService().CountModData('ModifyFood', id_food!, 'ModID');
      modCountList = ReviewList;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchReviewData (Review) ที่นี่
      print('Error in fetchReviewData (Review): $e');
    }

    try {
      List<dynamic> ReviewList = await DetailService()
          .CountCommentData('CommentFood', id_food!, 'CommentID');
      commentCountList = ReviewList;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchReviewData (Review) ที่นี่
      print('Error in fetchReviewData (Review): $e');
    }
  }

// void _playVideo({int index = 0, bool init = false}) {
//   if (_controller == null) {
//     _controller = VideoPlayerController.networkUrl(Uri.parse(urlString))
//       ..addListener(() => setState(() {}))
//       ..setLooping(true)
//       ..initialize().then((value) => _controller.play());
//   }
// }

  //ดึงข้อมูลรูปภาพจาก Storage
  Future<void> _fetchImages() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage
          .ref()
          .child('files')
          .child(id_food!)
          .child('Image')
          .listAll();

      try {
        ListResult result = await storage
            .ref()
            .child('files')
            .child(id_food!)
            .child('Image')
            .listAll();

        List<String> urls = [];
        for (Reference ref in result.items) {
          String imageURL = await ref.getDownloadURL();
          urls.add(imageURL);
        }

        setState(() {
          imageUrls = urls;
        });
      } catch (e) {
        print("Error fetching images: $e");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  Future<void> _fetchVideos() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage
          .ref()
          .child('files')
          .child(id_food!)
          .child('Video')
          .listAll();

      try {
        ListResult result = await storage
            .ref()
            .child('files')
            .child(id_food!)
            .child('Video')
            .listAll();

        List<String> urls = [];
        for (Reference ref in result.items) {
          String videoURL = await ref.getDownloadURL();
          urls.add(videoURL);
        }

        setState(() {
          videoUrls = urls;
        });
      } catch (e) {
        print("Error fetching Video: $e");
      }
    } catch (e) {
      print("Error fetching Video: $e");
    }
  }

  void _showImagePopup(BuildContext context, String imageUrl, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            // กำหนดความกว้างและความสูงเพื่อให้เต็มจอ
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover, // ให้รูปภาพเต็มหน้าจอแนวนอน
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
            ),
          ),
        );
      },
    );
  }

///////////////////////////////////////////////initState
  @override
  void initState() {
    super.initState();
    //_playVideo(init: true);
    _getDataFromDatabase();
    _getUserDataFromDatabase(user_id);
    _getImagesFromStorage(id_food);
    followerService.getBookmarkID(userid, getfoodID).then((bookmarkID) {
      setState(() {
        getIDbook = bookmarkID;
        _fetch();
        _fetchImages();
        _fetchVideos();
      });
    });
    _videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );

    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      // อย่าลืมรอให้วิดีโอเริ่มต้นเสร็จ
      setState(() {}); // รีเรนเดอร์ UI หลังจากวิดีโอเริ่มต้นเสร็จ
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Follower
    File? imageXFile;
    // _fetchImages();
    //ตัวรับ Parameter
    return Scaffold(
        backgroundColor: Color.fromARGB(239, 255, 255, 255),
        // appBar: AppBar(
        //   title: Text('หน้าข้อมูลอาหาร'),
        //   centerTitle: true,
        //   backgroundColor: Colors.orangeAccent,
        // ),
        //Floating Menu
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            //Menu Home Work ReportFood
            SpeedDialChild(
                child: Icon(Icons.report_problem),
                label: 'รายงานอาหาร',
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.red,
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 900,
                        child: Center(
                          child: Container(
                            child: ListView(
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Column(
                                      children: [
                                        Icon(Icons.warning_amber_outlined,
                                            color: Colors.white, size: 75),
                                        Text(
                                          'รายงานปัญหาอาหาร',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 3.0, left: 5.0),
                                  child: Text(
                                    'หัวข้อการรายงาน',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 3.0, left: 5.0),
                                  child: DropdownButtonFormField<String>(
                                    value: FoodtypeReport,
                                    onChanged: (value) {
                                      //setState(() {
                                      FoodtypeReport = value.toString();
                                      // _FoodtypeReport = FoodtypeReport;
                                      //});
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: Divider.createBorderSide(
                                              context)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: Divider.createBorderSide(
                                              context)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: Divider.createBorderSide(
                                              context)),
                                      filled: true,
                                      contentPadding: const EdgeInsets.all(8),
                                    ),
                                    items: const <DropdownMenuItem<String>>[
                                      DropdownMenuItem<String>(
                                        value: 'ใช้คำพูดที่ไม่เหมาะสม',
                                        child: Text('ใช้คำพูดที่ไม่เหมาะสม'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'โพสต์สิ่งที่ไม่เกี่ยวกับอาหาร',
                                        child: Text(
                                            'โพสต์สิ่งที่ไม่เกี่ยวกับอาหาร'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'ใช้รูปที่ไม่เหมาะสม',
                                        child: Text('ใช้รูปที่ไม่เหมาะสม'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'ให้ข้อมูลเท็จ',
                                        child: Text('ให้ข้อมูลเท็จ'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'อื่นๆ',
                                        child: Text('อื่นๆ'),
                                      ),
                                    ],
                                    dropdownColor: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'หมายเหตุ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          255, 253, 253, 253),
                                    ),
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                    maxLines: 4,
                                    controller: Fooddetail,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors
                                            .black, // background (button) color
                                        foregroundColor: Colors
                                            .white, // foreground (text) color
                                      ),
                                      onPressed: () async {
                                        FirebaseFirestore firestore =
                                            FirebaseFirestore.instance;
                                        final DocumentReference foodReport =
                                            firestore
                                                .collection("FoodReport")
                                                .doc();

                                        try {
                                          Map<String, dynamic> dataMap = {
                                            'Report': FoodtypeReport,
                                            'Detail': Fooddetail.text,
                                            'Time': Timestamp.now(),
                                            'ID_Food': id_food!,
                                            'ID_Report': foodReport.id //เก็บไว้
                                          };

                                          await foodReport.set(dataMap);
                                          Fooddetail.clear();
                                          Get.snackbar(
                                              'หัวข้อ', 'รายงานสำเร็จ');
                                          print('Successfull');
                                        } catch (e) {
                                          Get.snackbar(
                                              'หัวข้อ', 'รายงานไม่สำเร็จ');
                                          print("Error: $e");
                                        }
                                        ;
                                        // print('FoodID = ');
                                        // print(id_food!);

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('ส่ง')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

//-----------------------------------------------------
            //Menu Home Work
            SpeedDialChild(
                child: Icon(Icons.menu_book_outlined),
                label: 'ส่งการบ้าน',
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 500,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListView(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10.0,
                                ),
                                const Center(
                                  child: Text(
                                    'ส่งการบ้านกันเถอะ !',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'การบ้านของ  ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      name_food ?? '',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 127, 7),
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ButtonWidget(
                                      //Button Select file
                                      icon: Icons.attach_file,
                                      text: 'เลือกไฟล์',
                                      onClick: () {
                                        selectFile();
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 180),
                                  child: Text(
                                    '***อัพโหลดรูปอย่างน้อย 1 รูป',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: SenWork,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      hintText:
                                          'กรอกความคิดเห็นเกี่ยวกับการปรับสูตร',
                                    ),
                                    maxLines: 5,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 255, 196, 0)),
                                    ),
                                    onPressed: () async {
                                      print('Success');
                                      commentModifyfood = SenWork.text;
                                      if (commentModifyfood!.isNotEmpty) {
                                        uploadFileModify();
                                        SenWork.clear();
                                        Navigator.of(context).pop();
                                        Get.snackbar(
                                            'ผลการอัปโหลด', 'อัปโหลดสำเร็จ');
                                      } else {
                                        SenWork.clear();

                                        Get.snackbar(
                                            'ผลการอัปโหลด', 'อัปโหลดไม่สำเร็จ');
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ส่งการบ้าน',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(
                                          Icons.done_all_outlined,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // TextButton(
                                //     onPressed: () async {
                                //       print('Success');
                                //       commentModifyfood = SenWork.text;
                                //       uploadFileModify();
                                //       SenWork.clear();
                                //       Navigator.of(context).pop();
                                //     },
                                //     child: const Text('ส่ง')),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
            //Menu Comment
            SpeedDialChild(
                child: Icon(Icons.comment),
                label: 'คอมเม้นท์',
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: ListView(
                            children: <Widget>[
                              const SizedBox(
                                height: 10.0,
                              ),
                              const Center(
                                child: Text(
                                  'คอมเมนต์',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: Comment,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText:
                                        'กรอกความคิดเห็นเกี่ยวกับการคอมเม้น',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  maxLines: 7,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 255, 196, 0)),
                                  ),
                                  onPressed: () async {
                                    // print('Success');
                                    // commentComment = Comment.text;
                                    // uploadFileComment();
                                    // Comment.clear();
                                    // Navigator.of(context).pop();
                                    // //
                                    commentComment = Comment.text;
                                    if (commentComment!.isNotEmpty) {
                                      uploadFileComment();
                                      Comment.clear();
                                      Navigator.of(context).pop();
                                      Get.snackbar(
                                          'ผลการอัปโหลด', 'อัปโหลดสำเร็จ');
                                    } else {
                                      Comment.clear();

                                      Get.snackbar(
                                          'ผลการอัปโหลด', 'อัปโหลดไม่สำเร็จ');
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'คอมเมนต์',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
            //Menu Review
            SpeedDialChild(
              child: Icon(Icons.reviews),
              label: 'รีวิว',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: false,
                  context: context,
                  builder: (BuildContext context) {
                    int tempRating =
                        _rating; // สร้างตัวแปรชั่วคราวเพื่อจัดการคะแนน

                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: ListView(
                                children: <Widget>[
                                  const Center(
                                    child: Text(
                                      'รีวิวสูตรอาหารกันเถอะ !',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 1; i <= 5; i++)
                                        GestureDetector(
                                          onTapDown: (_) {
                                            if (tempRating != i) {
                                              tempRating = i;
                                              setState(
                                                  () {}); // อัปเดตสถานะใน StatefulBuilder เฉพาะเมื่อคะแนนเปลี่ยนแปลง
                                            }
                                          },
                                          onTapUp: (_) {
                                            _rating = tempRating;
                                          },
                                          child: Icon(
                                            Icons.star,
                                            size: 40,
                                            color: i <= tempRating
                                                ? Colors.orange
                                                : Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      tempRating > 0
                                          ? 'คุณให้ $tempRating ดาว!'
                                          : 'ให้คะแนนสูตร',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ButtonWidget(
                                        //Button Select file
                                        icon: Icons.attach_file,
                                        text: 'เลือกไฟล์',
                                        onClick: () {
                                          selectFile();
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 170),
                                    child: Text(
                                      '***อัพโหลดรูปอย่างน้อย 1 รูป',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextField(
                                    controller: Review,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      labelText:
                                          'กรอกความคิดเห็นเกี่ยวกับการรีวิว',
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 255, 196, 0)),
                                    ),
                                    onPressed: () async {
                                      rating = tempRating;
                                      commentReview = Review.text;
                                      print('Success');
                                      uploadFileReview();
                                      CalculatorService calculatorService =
                                          CalculatorService();

                                      try {
                                        await calculatorService.calRating();
                                        // ทำสิ่งที่คุณต้องการกับผลลัพธ์หลังจากการคำนวณคะแนน
                                      } catch (e) {
                                        // จัดการข้อผิดพลาดที่เกิดขึ้นหากมี
                                        print('เกิดข้อผิดพลาด: $e');
                                      }
                                      Review.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: Text(
                                            'ส่งรีวิว',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Icon(
                                          Icons.done_all_outlined,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),

                                  // TextButton(
                                  //     onPressed: () async {
                                  //       rating = tempRating;
                                  //       commentReview = Review.text;
                                  //       print('Success');
                                  //       uploadFileReview();
                                  //       CalculatorService calculatorService =
                                  //           CalculatorService();

                                  //       try {
                                  //         await calculatorService.calRating();
                                  //         // ทำสิ่งที่คุณต้องการกับผลลัพธ์หลังจากการคำนวณคะแนน
                                  //       } catch (e) {
                                  //         // จัดการข้อผิดพลาดที่เกิดขึ้นหากมี
                                  //         print('เกิดข้อผิดพลาด: $e');
                                  //       }
                                  //       Review.clear();
                                  //       Navigator.of(context).pop();
                                  //     },
                                  //     child: const Text('ส่ง')),
                                  // บริเวณอื่น ๆ ของป๊อปอัพเมนู
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),

///////////////////////////////////////////////Tab view เด้อจ้าาา
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text('หน้าข้อมูลอาหาร'),
              centerTitle: true,
              flexibleSpace: ClipPath(
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
              bottom: const TabBar(
                indicatorColor: Color.fromARGB(255, 0, 0, 0),
                labelColor: Color.fromARGB(255, 255, 255, 255),
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(Icons.notes_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.menu_book_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.comment),
                  ),
                  Tab(
                    icon: Icon(Icons.reviews),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.white38,
            body: TabBarView(
//Detail Tab**
              children: [
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(66, 199, 199, 199),
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                              //   image: DecorationImage( //ทำให้ภาพออกแบบไม่ค้าง
                              //   image: NetworkImage(image_food ?? ''),
                              //   fit: BoxFit.cover,
                              // ),
                            ),

//Slide

                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width *
                                      0.75, // ตั้งความสูงให้เท่ากับความกว้างเพื่อทำให้รูปภาพเป็นสี่เหลี่ยม
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageUrls.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Slidable(
                                        actionPane: SlidableStrechActionPane(),
                                        actionExtentRatio: 0.50,
                                        child: GestureDetector(
                                          onTap: () {
                                            _showImagePopup(context,
                                                imageUrls[index], index);
                                          },
                                          child: AspectRatio(
                                            aspectRatio:
                                                1.0, // รักษาสัดส่วนรูปภาพ
                                            child: Image.network(
                                              imageUrls[index],
                                              fit: BoxFit
                                                  .cover, // ลดขนาดรูปภาพเพื่อให้เต็มกรอบ
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // child: Column(
                          //   children: <Widget>[
                          //     SizedBox(
                          //       height: 300,
                          //       width: double.infinity,
                          //       child: FutureBuilder(
                          //         future: _fetchImages(),
                          //         builder: (context, snapshot) {
                          //           if (snapshot.connectionState == ConnectionState.done) {
                          //           return AnotherCarousel(
                          //             images: [
                          //               //VideoCarouselItem(videoUrl: 'https://firebasestorage.googleapis.com/v0/b/project-food-c14c5.appspot.com/o/files%2FH5sET0TQaRIx9qXgkq4e%2FVideo%2FVID_20231013_234214.mp4?alt=media&token=a44332cb-2cb7-4418-b7f9-71f72a96baa7'),
                          //               imageUrls.length
                          //             ],
                          //             dotSize: 4,
                          //             indicatorBgPadding: 5.0,
                          //           );
                          //           } else{
                          //             return Center(
                          //               child: SpinKitCircle( // หรือใช้ SpinKitDualRing, SpinKitChasingDots, SpinKitFadingCircle, หรือสไตล์ที่คุณต้องการ
                          //                   color: Colors.amber, // สีของวงกลม
                          //                   size: 50.0, // ขนาดของวงกลม
                          //                 ),
                          //             );
                          //           }
                          //         }
                          //       ),
                          //     ),

                          //   ],
                          // ),
                        ),
                        //),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
//Bookmark Button
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(35)),
                                child: IconButton(
                                  onPressed: () async {
                                    getname(userid);
                                    setState(() {
                                      isBookmarked = !isBookmarked;
                                    });
                                    isBookmarked
                                        ? await followerService.addBookmark(
                                            userid, getfoodID)
                                        : await followerService.unBookmark(
                                            userid, getfoodID);
                                  },
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_outline,
                                    color: isBookmarked
                                        ? Colors.amber
                                        : const Color.fromARGB(255, 0, 0, 0),
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200, left: 280),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(35)),
                            child: IconButton(
                              onPressed: () async {
                                Get.to(VideoPage(), arguments: videoUrls);
                                //Get.snackbar('title', videoUrls[0]);
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                color: Color.fromARGB(255, 255, 136, 0),
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Stack(
                          children: <Widget>[
//Name Card
                            cardDetail(
                              title: name_food,
                              subtitle: type_food,
                              rating: point_food,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20.0, 110, 20, 5),
                                height: 90,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
//Profile User
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                              height: 70,
                                              width: 100,
                                              child: ProfilePicture(
                                                  imageXFile: imageXFile,
                                                  image: image))
                                        ],
                                      ),
                                    ),
                                    Padding(
////////////Card Profile
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, top: 10),
                                            child: Text(
                                              '$name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 9,
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: 100,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Color.fromARGB(
                                                            255,
                                                            255,
                                                            156,
                                                            7)), // สีพื้นหลังเมื่อปุ่มไม่ได้ถูกกด
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(Colors
                                                            .white), // สีของข้อความ
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsetsGeometry>(
                                                  EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical:
                                                          1), // การขยับของข้อความภายในปุ่ม
                                                ),
                                                textStyle: MaterialStateProperty
                                                    .all<TextStyle>(
                                                  TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ), // สไตล์ข้อความ
                                              ),
                                              onPressed: () {
                                                Get.to(UserLinkProfile(),
                                                    arguments: user_id);
                                              },
                                              child: Text('ดูโปรไฟล์'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
//Time Card
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(250.0, 110, 20, 5),
                                height: 90,
                                width: 120,
                                decoration: BoxDecoration(
                                  gradient: kgradeint,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Icon(
                                        //   Icons.timer,
                                        //   color: Colors.white,
                                        // ),
                                        Text(
                                          "$time_food",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "นาที",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
////////////////////////////////////////////////Video
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(20.0, 215, 20, 5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: new LinearGradient(
                                      colors: [
                                        Color.fromARGB(240, 255, 153, 0),
                                        Color.fromARGB(255, 61, 37, 0)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(StepViewer(),
                                          transition: Transition.zoom,
                                          arguments: id_food);
                                    },
                                    child: SizedBox(
                                      height: 73,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 40.0, top: 15),
                                            child: Row(
                                              children: [
                                                Icon(Icons.play_arrow_rounded,
                                                    color: Colors.white),
                                                Text('ดูวิดีโอขั้นตอน',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28)),
                                              ],
                                            ),
                                          ),
                                          Opacity(
                                            opacity: 0.3,
                                            child: Container(
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  image: new NetworkImage(
                                                      image_food ?? ''),
                                                  fit: BoxFit.fitWidth,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ),

/////////////////////////////////////////////////Detail
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20.0, 300, 20, 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const Text(
                                              'รายละเอียด',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text(description_food ?? ''),
                                            ),
/////////Solution
                                            ExpansionTile(
                                              title: const Text(
                                                'วัตถุดิบ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              trailing: Icon(
                                                isExpanded
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down,
                                                color: Colors.amber,
                                              ),
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                      ingradent_food ?? ''),
                                                ),
                                              ],
                                              onExpansionChanged:
                                                  (bool expanded) {
                                                setState(() =>
                                                    isExpanded = expanded);
                                              },
                                            ),
/////////////Ingredients
                                            ExpansionTile(
                                              title: const Text(
                                                'วิธีการทำ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              trailing: Icon(
                                                isExpanded
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down,
                                                color: Colors.amber,
                                              ),
                                              children: <Widget>[
                                                ListTile(
                                                  title:
                                                      Text(solution_food ?? ''),
                                                ),
                                              ],
                                              onExpansionChanged:
                                                  (bool expanded) {
                                                setState(() =>
                                                    isExpanded = expanded);
                                              },
                                            ),
                                          ],
                                        ),
                                        const Text(''),
                                        const SizedBox(
                                          height: 10,
                                        ),
///////////////////////
                                      ]),
                                ),
                              ),
                            ),
                          ], //แปะได้
                        ),
                      ),
                    ),
                  ],
                ),

/////////////////////////ALL TAB/////////////////////////////////////////
//Home Work Tab
                FutureBuilder<void>(
                  future: _fetch(), // คำสั่งดึงข้อมูลที่แสดง
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return Container(
                      color: Colors.yellowAccent,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: AllImageAllImageModify.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> modifyData =
                                    modifyList[index];

                                Timestamp timestamp =
                                    modifyData['Time'] as Timestamp;
                                DateTime dateTime = timestamp.toDate();
                                String thaiDateTime = DateFormat.yMMMMd('th_TH')
                                    .add_Hms()
                                    .format(dateTime);
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: 5)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children:
                                              AllImageAllImageModify[index]
                                                  .map((imageURLs) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                imageURLs,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      // Text(
                                      //     'ID_Food : ${modifyData['ID_Food']}'),
                                      // Text('ID_Mod : ${modifyData['ID_Mod']}'),

                                      FutureBuilder<String>(
                                        future: getname(modifyData[
                                            'Uid']), // เรียกใช้ getname โดยส่ง modifyData['Uid']
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            // การดำเนินการเมื่อ Future สมบูรณ์
                                            String userName = snapshot.data ??
                                                'ไม่พบชื่อ'; // ดึงค่าจาก snapshot.data
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(UserLinkProfile(),
                                                      arguments:
                                                          modifyData['Uid']);
                                                },
                                                child: Text(userName,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 5),
                                              ),
                                            ); // แสดงชื่อผู้ใช้
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'เกิดข้อผิดพลาดในการดึงข้อมูล');
                                          } else {
                                            // การดำเนินการในระหว่างรอ Future
                                            return CircularProgressIndicator(); // หรือ Widget แสดงการโหลด
                                          }
                                        },
                                      ),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                            'คอมเมนต์ : ${modifyData['Comment']}',
                                            style: TextStyle(fontSize: 20),
                                            maxLines: 5),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 5),
                                        child: Text(
                                          'โพสต์เมื่อ : $thaiDateTime',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: InkWell(
                                          onTap: () {
                                            idMod = modifyData['ID_Mod'];
                                            showModalBottomSheet(
                                              isScrollControlled: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  child: SizedBox(
                                                    height: 400,
                                                    child: Center(
                                                      child: ListView(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                'ตอบกลับ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                ReplyMod,
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  253,
                                                                  253,
                                                                  253),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              hintText:
                                                                  'ตอบกลับคอมเม้น', // ใช้ hintText เป็นคำแนะนำ
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                            ),
                                                            maxLines: 5,
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .amber,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      print(
                                                                          'Success');

                                                                      replyMod =
                                                                          ReplyMod
                                                                              .text;
                                                                      if (replyMod!
                                                                          .isNotEmpty) {
                                                                        uploadFileReplyMod();
                                                                        Get.to(
                                                                            ReplyCommentFood(),
                                                                            arguments:
                                                                                modifyData['ID_Mod']);
                                                                        ReplyMod
                                                                            .clear();

                                                                        Get.snackbar(
                                                                            'ผลการอัปโหลด',
                                                                            'อัปโหลดสำเร็จ');
                                                                      } else {
                                                                        ReplyMod
                                                                            .clear();

                                                                        Get.snackbar(
                                                                            'ผลการอัปโหลด',
                                                                            'อัปโหลดไม่สำเร็จ');
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'ส่ง')),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 400,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.reply,
                                                      color: Colors.white),
                                                  Text(
                                                    ' ตอบกลับ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Report Button
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //Report Button
                                      InkWell(
                                        onTap: () {
                                          Get.to(ReplyModFood(),
                                              arguments: modifyData['ID_Mod']);
                                        },
                                        child: Container(
                                          width: 400,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons
                                                    .remove_red_eye_rounded),
                                                Text(
                                                  ' ดูการตอบกลับ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(modCountList.length
                                                    .toString()),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

//Comment Tab
                FutureBuilder<void>(
                  future: _fetch(), // คำสั่งดึงข้อมูลที่แสดง
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return Container(
                      color: Colors.red,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: commentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> commentData =
                                    commentList[index];

                                Timestamp timestamp =
                                    commentData['Time'] as Timestamp;
                                DateTime dateTime = timestamp.toDate();
                                String thaiDateTime = DateFormat.yMMMMd('th_TH')
                                    .add_Hms()
                                    .format(dateTime);
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: 5)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text('ID_Food : ${modifyData['ID_Food']}'),
                                      // Text('ID_Mod : ${modifyData['ID_Mod']}'),

                                      FutureBuilder<String>(
                                        future: getname(commentData[
                                            'Uid']), // เรียกใช้ getname โดยส่ง modifyData['Uid']
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            // การดำเนินการเมื่อ Future สมบูรณ์
                                            String userName = snapshot.data ??
                                                'ไม่พบชื่อ'; // ดึงค่าจาก snapshot.data
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(UserLinkProfile(),
                                                      arguments:
                                                          commentData['Uid']);
                                                },
                                                child: Text(userName,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 5),
                                              ),
                                            ); // แสดงชื่อผู้ใช้
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'เกิดข้อผิดพลาดในการดึงข้อมูล');
                                          } else {
                                            // การดำเนินการในระหว่างรอ Future
                                            return CircularProgressIndicator(); // หรือ Widget แสดงการโหลด
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        child: Text(
                                            'คอมเม้นต์ : ${commentData['Comment']}',
                                            style: TextStyle(fontSize: 20),
                                            maxLines: 5),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        child: Text(
                                          'โพสต์เมื่อ : $thaiDateTime',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: InkWell(
                                          onTap: () {
                                            // Get.snackbar(
                                            //     '${commentData['ID_Comment']}',
                                            //     'message');
                                            idComment =
                                                commentData['ID_Comment'];
                                            showModalBottomSheet(
                                              isScrollControlled: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  child: SizedBox(
                                                    height: 400,
                                                    child: Center(
                                                      child: ListView(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                'ตอบกลับ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                ReplyComment,
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  253,
                                                                  253,
                                                                  253),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              hintText:
                                                                  'ตอบกลับคอมเม้น', // ใช้ hintText เป็นคำแนะนำ
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                            ),
                                                            maxLines:
                                                                5, // กำหนดจำนวนบรรทัดสูงสุด
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .amber,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                print(
                                                                    'Success');
                                                                //
                                                                replyComment =
                                                                    ReplyComment
                                                                        .text;
                                                                if (replyComment!
                                                                    .isNotEmpty) {
                                                                  uploadFileReplyComment();
                                                                  Get.to(
                                                                      ReplyCommentFood(),
                                                                      arguments:
                                                                          commentData[
                                                                              'ID_Comment']);
                                                                  ReplyComment
                                                                      .clear();

                                                                  Get.snackbar(
                                                                      'ผลการอัปโหลด',
                                                                      'อัปโหลดสำเร็จ');
                                                                } else {
                                                                  ReplyComment
                                                                      .clear();

                                                                  Get.snackbar(
                                                                      'ผลการอัปโหลด',
                                                                      'อัปโหลดไม่สำเร็จ');
                                                                }
                                                              },
                                                              child: const Text(
                                                                'ส่ง',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 400,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.reply,
                                                      color: Colors.white),
                                                  Text(
                                                    ' ตอบกลับ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Report Button
                                      SizedBox(
                                        height: 10,
                                      ),

                                      InkWell(
                                        onTap: () {
                                          Get.snackbar(
                                              '${commentData['ID_Comment']}',
                                              'message');
                                          Get.to(ReplyCommentFood(),
                                              arguments:
                                                  commentData['ID_Comment']);
                                        },
                                        child: Container(
                                          width: 400,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons
                                                    .remove_red_eye_rounded),
                                                Text(
                                                  ' ดูการตอบกลับ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(commentCountList.length
                                                    .toString()),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

//Review Tab
                FutureBuilder<void>(
                  future: _fetch(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return Container(
                      color: Colors.yellowAccent,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: AllImageAllImageReview.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map<String, dynamic> reviewData =
                                    reviewList[index];
                                String idrv = reviewData['ID_Review'];
                                //reviewData[index].
                                Map<String, dynamic> reviewC =
                                    reviewCountList[index];
                                // print('reviewC = ');
                                //print(reviewC['ID_Review']);

                                Timestamp timestamp =
                                    reviewData['Time'] as Timestamp;
                                DateTime dateTime = timestamp.toDate();
                                String thaiDateTime = DateFormat.yMMMMd('th_TH')
                                    .add_Hms()
                                    .format(dateTime);
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(width: 5)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children:
                                              AllImageAllImageReview[index]
                                                  .map((imageURLs) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Image.network(
                                                    imageURLs,
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text('${reviewData['Comment']}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 5),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Text(
                                                'คะแนน : ${reviewData['Rating']}',
                                                style: TextStyle(fontSize: 20),
                                                maxLines: 5),
                                          ),
                                          Icon(Icons.star, color: Colors.amber),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 3),
                                        child: Text(
                                          'โพสต์เมื่อ : $thaiDateTime',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: InkWell(
                                          onTap: () {
                                            // Get.snackbar(
                                            //     '${reviewData['ID_Review']}',
                                            //     'message');

                                            idReview = reviewData['ID_Review'];
                                            ////////////////////////
                                            showModalBottomSheet(
                                              isScrollControlled: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                  child: SizedBox(
                                                    height: 400,
                                                    child: Center(
                                                      child: ListView(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child: Text(
                                                                'ตอบกลับ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                ReplyReview,
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  253,
                                                                  253,
                                                                  253),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              hintText:
                                                                  'ตอบกลับคอมเม้น', // ใช้ hintText เป็นคำแนะนำ
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                            ),
                                                            maxLines:
                                                                5, // กำหนดจำนวนบรรทัดสูงสุด
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .amber,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                print(
                                                                    'Success');

                                                                replyReview =
                                                                    ReplyReview
                                                                        .text;
                                                                if (replyReview!
                                                                    .isNotEmpty) {
                                                                  uploadFileReplyReview();
                                                                  Get.to(
                                                                      ReplyCommentFood(),
                                                                      arguments:
                                                                          reviewData[
                                                                              'ID_Review']);
                                                                  ReplyReview
                                                                      .clear();

                                                                  Get.snackbar(
                                                                      'ผลการอัปโหลด',
                                                                      'อัปโหลดสำเร็จ');
                                                                } else {
                                                                  ReplyReview
                                                                      .clear();

                                                                  Get.snackbar(
                                                                      'ผลการอัปโหลด',
                                                                      'อัปโหลดไม่สำเร็จ');
                                                                }
                                                              },
                                                              child: const Text(
                                                                'ส่ง',
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 400,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.reply,
                                                      color: Colors.white),
                                                  Text(
                                                    ' ตอบกลับ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Report Button
                                      SizedBox(
                                        height: 10,
                                      ),
                                      //Report Button
                                      InkWell(
                                        onTap: () {
                                          // Get.snackbar(
                                          //     '${reviewData['ID_Review']}',
                                          //     'message');
                                          Get.to(ReplyReviewFood(),
                                              arguments:
                                                  reviewData['ID_Review']);
                                        },
                                        child: Container(
                                          width: 400,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons
                                                    .remove_red_eye_rounded),
                                                Text(
                                                  ' ดูการตอบกลับ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // if (reviewData['ID_Review'] ==
                                                //     reviewCountdata[
                                                //         'ID_Review'])

                                                //tONegkuQUWsiy0aLkKci
                                                if (reviewData['ID_Review'] ==
                                                    reviewC['ID_Review'])
                                                  Text(reviewCountList.length
                                                      .toString()),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // _fetchImagesModify();
                                _fetch();
                              });
                            },
                            child: Text('รีเฟรช'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class cardDetail extends StatelessWidget {
  const cardDetail({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rating,
  });

  final String? title;
  final String? subtitle;
  final String? rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 5, 20, 5),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$title',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color.fromARGB(255, 255, 136, 0)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$rating   ',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '$subtitle',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
        ),
      ),
    );
  }
}
