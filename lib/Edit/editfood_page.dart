import 'dart:io';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:se_project_food/Authen/authen_part.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Models/foodmodels.dart';
import '../Api/firebase_api.dart';

class EditFoods extends StatefulWidget {
  const EditFoods({super.key});

  @override
  State<EditFoods> createState() => _EditFoodsState();
}

class _EditFoodsState extends State<EditFoods> {
  List<FoodModel> foodModels = [];
  PlatformFile? pickedFile;
  String? edit_nation = 'ไทย';
  String? edit_level = 'ไม่มี';
  String? edit_type = 'ไม่มี';
  String? imageUrl;
  String? videoUrl;
  List<String> imageUrls = [];
  List<String> videoUrls = [];
  final TextEditingController edit_name = TextEditingController();
  final TextEditingController edit_description = TextEditingController();
  final TextEditingController edit_ingredients = TextEditingController();

//  / final TextEditingController edit_level = TextEditingController();
// final TextEditingController edit_nation = TextEditingController();
  final TextEditingController edit_point = TextEditingController();

  final TextEditingController edit_solution = TextEditingController();
  final TextEditingController edit_time = TextEditingController();
  //final TextEditingController edit_type = TextEditingController();

  @override
  void initState() {
    super.initState();
    readData();
  }

  Widget nation(context) {
    // กำหนดค่าเริ่มต้น
    // readData();
    return DropdownButtonFormField<String>(
      value: edit_nation,
      onChanged: (value1) {
        //setState(() {
        edit_nation = value1.toString();
        //});
      },
      decoration: InputDecoration(
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
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ไทย',
          child: Text('ไทย'),
        ),
        DropdownMenuItem<String>(
          value: 'อเมริกา',
          child: Text('อเมริกา'),
        ),
        DropdownMenuItem<String>(
          value: 'อังกฤษ',
          child: Text('อังกฤษ'),
        ),
        DropdownMenuItem<String>(
          value: 'ฝรั่งเศษ',
          child: Text('ฝรั่งเศษ'),
        ),
        DropdownMenuItem<String>(
          value: 'เยอรมัน',
          child: Text('เยอรมัน'),
        ),
        DropdownMenuItem<String>(
          value: 'ญี่ปุ่น',
          child: Text('ญี่ปุ่น'),
        ),
        DropdownMenuItem<String>(
          value: 'อิตาลี',
          child: Text('อิตาลี'),
        ),
        DropdownMenuItem<String>(
          value: 'อินเดีย',
          child: Text('อินเดีย'),
        ),
        DropdownMenuItem<String>(
          value: 'สเปน',
          child: Text('สเปน'),
        ),
        DropdownMenuItem<String>(
          value: 'เกาหลี',
          child: Text('เกาหลี'),
        ),
        DropdownMenuItem<String>(
          value: 'จีน',
          child: Text('จีน'),
        ),
        DropdownMenuItem<String>(
          value: 'อื่นๆ',
          child: Text('อื่นๆ'),
        ),
      ].toList()
        ..sort((a, b) => a.child.toString().compareTo(b.child.toString())),
    );
  }

  Widget level(context) {
    return DropdownButtonFormField<String>(
      value: edit_level,
      onChanged: (value2) {
        //setState(() {
        edit_level = value2.toString();
        //});
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
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ไม่มี',
          child: Text('ไม่มี'),
        ),
        DropdownMenuItem<String>(
          value: 'ง่ายมาก',
          child: Text('ง่ายมาก'),
        ),
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
        DropdownMenuItem<String>(
          value: 'ยากมาก',
          child: Text('ยากมาก'),
        ),
      ],
    );
  }

  Widget type(context) {
    return DropdownButtonFormField<String>(
      value: edit_type,
      onChanged: (value3) {
        //setState(() {
        edit_type = value3.toString();
        //});
      },
      decoration: InputDecoration(
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
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(
          value: 'ไม่มี',
          child: Text('ไม่มี'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารอีสาน',
          child: Text('อาหารอีสาน'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารใต้',
          child: Text('อาหารใต้'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารเหนือ',
          child: Text('อาหารเหนือ'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารเส้น',
          child: Text('อาหารเส้น'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารสุขภาพ',
          child: Text('อาหารสุขภาพ'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารตามสั่ง',
          child: Text('อาหารตามสั่ง'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารทะเล',
          child: Text('อาหารทะเล'),
        ),
        DropdownMenuItem<String>(
          value: 'ของทอด',
          child: Text('ของทอด'),
        ),
        DropdownMenuItem<String>(
          value: 'ชา/กาแฟ',
          child: Text('ชา/กาแฟ'),
        ),
        DropdownMenuItem<String>(
          value: 'ชาบู/สุกี้',
          child: Text('ชาบู/สุกี้'),
        ),
        DropdownMenuItem<String>(
          value: 'ชานมไข่มุก',
          child: Text('ชานมไข่มุก'),
        ),
        DropdownMenuItem<String>(
          value: 'ซูชิ',
          child: Text('ซูชิ'),
        ),
        DropdownMenuItem<String>(
          value: 'ของหวาน',
          child: Text('ของหวาน'),
        ),
        DropdownMenuItem<String>(
          value: 'ฟาสต์ฟู้ด',
          child: Text('ฟาสต์ฟู้ด'),
        ),
        DropdownMenuItem<String>(
          value: 'หม่าล่า',
          child: Text('หม่าล่า'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารจานด่วน',
          child: Text('อาหารจานด่วน'),
        ),
        DropdownMenuItem<String>(
          value: 'โจ๊ก',
          child: Text('โจ๊ก'),
        ),
        DropdownMenuItem<String>(
          value: 'โยเกิร์ต/ไอศกรีม',
          child: Text('โยเกิร์ต/ไอศกรีม'),
        ),
        DropdownMenuItem<String>(
          value: 'ปิ้งย่าง/บาร์บีคิว',
          child: Text('ปิ้งย่าง/บาร์บีคิว'),
          //--------------------------------
        ),
        DropdownMenuItem<String>(
          value: 'เครื่องดื่ม/น้ำผลไม้',
          child: Text('เครื่องดื่ม/น้ำผลไม้'),
        ),
        DropdownMenuItem<String>(
          value: 'อาหารเจ',
          child: Text('อาหารเจ'),
        ),
        DropdownMenuItem<String>(
          value: 'โรตี',
          child: Text('โรตี'),
        ),
        DropdownMenuItem<String>(
          value: 'สเต็ก',
          child: Text('สเต็ก'),
        ),
        DropdownMenuItem<String>(
          value: 'ของทานเล่น/ขนมขบเขี้ยว',
          child: Text('ของทานเล่น/ขนมขบเขี้ยว'),
        ),
        DropdownMenuItem<String>(
          value: 'ติ่มซำ',
          child: Text('ติ่มซำ'),
        ),
        DropdownMenuItem<String>(
          value: 'ยำ',
          child: Text('ยำ'),
        ),
        DropdownMenuItem<String>(
          value: 'อื่นๆ',
          child: Text('อื่นๆ'),
        ),
      ].toList()
        ..sort((a, b) => a.child.toString().compareTo(b.child.toString())),
    );
  }

  final String getfoodID = Get.arguments as String; //ตัวรับ

//ดึงข้อมูลมาแสดง
  Future<void> readData() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // ทำการเรียกข้อมูลเอกสารจาก Firebase
    DocumentSnapshot sd =
        await firestore.collection('Foods').doc(getfoodID).get();

    // ตรวจสอบว่ามีข้อมูลหรือไม่
    Map<String, dynamic>? data = sd.data() as Map<String, dynamic>?;
    if (sd.exists) {
      // ถ้ามีข้อมูลในเอกสาร คุณสามารถนำข้อมูลมาใช้ได้ตามต้องการ
      foodid = data!['Food_id'];
      edit_level = data!['Food_Level'];
      edit_nation = data!['Food_Nation'];
      edit_type = data!['Food_Type'];
      _fetchImages();
      _fetchVideos();
      // เช่น ถ้าคุณมีค่าของ key 'name' ในเอกสาร สามารถเข้าถึงได้ดังนี้
      setState(() {
        edit_description.text = data!['Food_Description'];
        imageUrl = data!['Food_Image'];
        edit_ingredients.text = data!['Food_Ingredients'];
        videoUrl = data!['Food_Video'];
        edit_name.text = data!["Food_Name"];

        edit_solution.text = data!['Food_Solution'];
        edit_time.text = data!['Food_Time'];
      });
    } else {
      // ถ้าไม่มีข้อมูลในเอกสาร
      print('Document not found!');
    }

    print('Hello Than');
  }

//เลือกรูปภาพ ตอนที่กดเพิ่มรูปภาพ
  Future<void> pickImage() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot sd =
        await firestore.collection('Foods').doc(getfoodID).get();

    Map<String, dynamic>? data = sd.data() as Map<String, dynamic>?;
    if (sd.exists) {
      foodid = data!['Food_id'];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true, // Allow selecting multiple images
    );

    if (result != null) {
      List<PlatformFile> pickedImages = result.files;

      for (PlatformFile pickedImage in pickedImages) {
        await uploadImageToFirebase(pickedImage);
      }

      // Fetch images after uploading is done
      await _fetchImages();

      setState(() {
        imageUrl = imageUrls.isNotEmpty ? imageUrls[0] : null;
      });
    }
  }

  Future<void> pickVideo() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Foods")
        .doc(getfoodID)
        .get();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot sd =
        await firestore.collection('Foods').doc(getfoodID).get();

    Map<String, dynamic>? data = sd.data() as Map<String, dynamic>?;
    if (sd.exists) {
      foodid = data!['Food_id'];
    }

    FilePickerResult? result2 = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true, // Allow selecting multiple images
    );

    if (result2 != null) {
      List<PlatformFile> pickedVideos = result2.files;

      for (PlatformFile pickedVideo in pickedVideos) {
        await uploadVideoToFirebase(pickedVideo);
      }

      // Fetch images after uploading is done

      await _fetchVideos();

      setState(() {
        videoUrl = videoUrls.isNotEmpty ? videoUrls[0] : null;
      });
    }
  }

//ดึงข้อมูลรูปภาพจาก Storage
  Future<void> _fetchImages() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage
          .ref()
          .child('files')
          .child(foodid!)
          .child('Image')
          .listAll();

      try {
        ListResult result = await storage
            .ref()
            .child('files')
            .child(foodid!)
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

  //ดึงข้อมูลรูปภาพจาก Storage
  Future<void> _fetchVideos() async {
    try {
      print("Fetching videos for food ID: $foodid");
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage
          .ref()
          .child('files')
          .child(foodid!)
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

      print("Fetched video URLs: $videoUrls");
    } catch (e) {
      print("Error fetching videos: $e");
    }
  }

  String? foodid;
  //อัปรูปภาพลง Firebase
  Future<void> uploadImageToFirebase(PlatformFile pickedImage) async {
    if (pickedImage == null) return;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files')
          .child(foodid!)
          .child('Image')
          .child(fileName);

      try {
        firebase_storage.UploadTask uploadTask =
            ref.putFile(File(pickedImage.path!));
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadURL;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> uploadVideoToFirebase(PlatformFile pickedImage) async {
    if (pickedImage == null) return;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files')
          .child(foodid!)
          .child('Video')
          .child(fileName);

      try {
        firebase_storage.UploadTask uploadTask =
            ref.putFile(File(pickedImage.path!));
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          videoUrl = downloadURL;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

//โชว์รูปขึ้นมาเมื่อกดคลิกที่รูปจะมีให้เลือกลบว่าจะลบรูปไหน
  void _showImagePopup(BuildContext context, String imageUrl, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await deleteImage(imageUrl, index);
                      Navigator.of(context).pop(); // ปิด Dialog
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.snackbar('ลบรูปภาพ', 'ลบรูปภาพสำเร็จ');
                    },
                    icon: Icon(Icons.add),
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVideoPopup(BuildContext context, String videoUrl, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final VideoPlayerController _controller =
            VideoPlayerController.network(videoUrl);
        _controller.initialize();

        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9, // ปรับค่าตามสัดส่วนของวิดีโอของคุณ
                child: VideoPlayer(_controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _controller.dispose(); // ปิดควบคุมเวลาเมื่อเสร็จ
                      Navigator.of(context).pop(); // ปิดไดอล็อก
                    },
                    icon: Icon(Icons.close),
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

//ลบรูปภาพ
  Future<void> deleteImage(String imageUrl, int index) async {
    if (imageUrl == null) return;

    try {
      // Convert image URL to firebase_storage.Reference
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the image from Firebase Storage
      await ref.delete();

      // Update the imageUrls list to remove the deleted image URL
      setState(() {
        imageUrls.removeAt(index);
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: GestureDetector(
                        onTap: () {
                          _showImagePopup(context, imageUrls[index], index);
                          // _showVideoPopup(context, videoUrls[index], index);
                        },
                        child: Image.network(imageUrls[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                pickImage(); // Function to pick a new image
              },
              child: Text('เพิ่มรูปภาพ'),
            ),
//////////////////////////////
            SizedBox(
              height: MediaQuery.of(context).size.width,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: GestureDetector(
                      onTap: () {
                        _showVideoPopup(context, videoUrls[index], index);
                      },
                      child: VideoPlayer(
                        VideoPlayerController.networkUrl(
                            Uri.parse(videoUrls[index])),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(videoUrls.toString()),
            //Text(imageUrls.toString()),
            ElevatedButton(
              onPressed: () {
                pickVideo(); // Function to pick a new image
              },
              child: Text('เพิ่มวิดิโอ'),
            ),
          ],
        ),
        Text('ชื่ออาหาร'),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_name,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'กรอกข้อมูล',
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("รายละเอียด : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_description,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("วัตถุดิบ : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_ingredients,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("ระดับความยาก : "),
        SizedBox(
          height: 10.0,
        ),
        level(context),
        SizedBox(
          height: 10.0,
        ),
        Text("สัญชาติ : "),
        SizedBox(
          height: 10.0,
        ),
        nation(context),
        // SizedBox(
        //   height: 10.0,
        // ),
        // Text("คะแนน : "),
        // SizedBox(
        //   height: 10.0,
        // ),
        // TextField(
        //   controller: edit_point,
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        //   ),
        // ),
        SizedBox(
          height: 10.0,
        ),
        Text("วิธทำ : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_solution,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("เวลาในการทำ : "),
        SizedBox(
          height: 10.0,
        ),
        TextField(
          controller: edit_time,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text("ประเภท : "),
        SizedBox(
          height: 10.0,
        ),
        type(context),
        SizedBox(
          height: 10.0,
        ),
        TextButton(
            onPressed: () async {
              String _editname = edit_name.text;
              String _editdescription = edit_description.text;
              String _editingredients = edit_ingredients.text;
              String _editlevel = edit_level!;
              String _editnation = edit_nation!;
              // String _editpoint = edit_point.text;
              String _editsolution = edit_solution.text;
              String _edittime = edit_time.text;
              String _edittype = edit_type!;

              final docker =
                  FirebaseFirestore.instance.collection('Foods').doc(getfoodID);

              docker.update({
                'Food_Name': _editname,
                'Food_Description': _editdescription,
                'Food_Ingredients': _editingredients,
                'Food_Level': _editlevel,
                'Food_Nation': _editnation,
                //'Food_Point': _editpoint,
                'Food_Solution': _editsolution,
                'Food_Time': _edittime,
                'Food_Type': _edittype,
                'Food_Image': imageUrl,
              });

              Navigator.of(context).pop();
              //
            },
            child: const Text('ยืนยันการแก้ไข'))
      ]),
    );

    //Stream<List<PersonModel>> readData
  }
}
