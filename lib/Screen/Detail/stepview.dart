import 'dart:io';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'detail_service.dart';

class StepViewer extends StatefulWidget {
  const StepViewer({super.key});

  @override
  State<StepViewer> createState() => _StepViewerState();
}

class _StepViewerState extends State<StepViewer> {
  // late VideoPlayerController _videoPlayerController;
  // late Future<void> _initializeVideoPlayerFuture;
  // final List<String> getVdoID = Get.arguments as List<String>;
  int selectedVideoIndex = 0;
  List<String> videoUrls = [];
  List<File> thumbnails = [];
  final String getfoodID = Get.arguments as String; //รับ Food ID
  List<dynamic> stepList = [];

  Future<void> getVideoThumbnails() async {
    for (String? videoUrl in videoUrls) {
      if (videoUrl != null) {
        final thumbnail = await VideoThumbnail.thumbnailData(
          video: videoUrl,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 64,
          quality: 75,
        );

        final thumbnailFile = File.fromRawPath(thumbnail!);
        setState(() {
          thumbnails.add(thumbnailFile);
        });
      } else {
        // Handle the case where videoUrl is null (if needed)
      }
    }
  }

  Future<void> _fetchVideos() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      ListResult result = await storage
          .ref()
          .child('StepDetail')
          .child(getfoodID)
          .child('Video')
          .listAll();

      try {
        ListResult result = await storage
            .ref()
            .child('StepDetail')
            .child(getfoodID)
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

  Future<void> _fetchStepData() async {
    try {
      List<dynamic> StepList = await DetailService().fetchStepData(getfoodID);
      stepList = StepList;
    } catch (e) {
      // จัดการกับข้อผิดพลาดในการเรียก fetchReviewData ที่นี่
      print('Error in fetchReviewData (Modify): $e');
    }
  }

  // Future<List<String>> getDownloadURLs() async {
  // final storage = FirebaseStorage.instance;
  // List<String> videoUrls = [];
  // final destination = 'StepDetail/$getfoodID/Video';

  //         ListResult videoResult = await storage
  //           .ref(destination).listAll();

  //       for (Reference ref in videoResult.items) {
  //         String videoURL = await ref.getDownloadURL();
  //         videoUrls.add(videoURL);
  //       }

  //     return videoUrls;
  //   }

  @override
  void initState() {
    super.initState();
    _fetchVideos();
    _fetchStepData();
    getVideoThumbnails();
    // _videoPlayerController = VideoPlayerController.network(
    //   getVdoID[selectedVideoIndex],
    // );

    // _initializeVideoPlayerFuture =
    //     _videoPlayerController.initialize().then((_) {
    //   // อย่าลืมรอให้วิดีโอเริ่มต้นเสร็จ
    //   setState(() {}); // รีเรนเดอร์ UI หลังจากวิดีโอเริ่มต้นเสร็จ
    // });
  }

  //   @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ขั้นตอน')),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.withOpacity(0.9), Colors.orange],
              begin: FractionalOffset(0.0, 0.4),
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(),
                    child: videoUrls.length != 0
                        ? ListView.builder(
                            itemCount: videoUrls.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> stepdata = stepList[index];
                              // กำหนดวิดีโอที่ต้องการแสดงเป็นรูปและข้อมูลอื่น ๆ ที่ต้องการ
                              // เช่นรูป thumbnail จาก thumbnails[index]
                              // และคำอธิบายอื่น ๆ
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: ListTile(
                                        // นี่คือวิดีโอที่คุณต้องการแสดง
                                        // ในรูปแบบรูป thumbnail หรืออื่น ๆ
                                        title: Text(
                                          '${stepdata['title']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                        ),

                                        // leading: thumbnails.isNotEmpty && thumbnails[index] != null
                                        //               ? Image.file(thumbnails[index],fit: BoxFit.fill,)
                                        //               : Center(child: CircularProgressIndicator()), // ตรวจสอบว่ามี thumbnails และ thumbnails[index] ไม่เป็น null
                                        // ข้อมูลเพิ่มเติมหรือคำอธิบาย
                                        subtitle: Text(
                                          '${stepdata['description']}',
                                          maxLines: 5,
                                        ),
                                      ),
                                    ),
                                    Text(videoUrls[index].toString()),
                                    // Image.network(videoUrls[index]),
                                    Chewie(
                                      controller: ChewieController(
                                        videoPlayerController:
                                            VideoPlayerController.network(
                                                videoUrls[index]),
                                        aspectRatio: 16 / 9, // สัดส่วนของวิดีโอ
                                        autoPlay:
                                            false, // กำหนดให้วิดีโอไม่ถูกเล่นอัตโนมัติ
                                        looping:
                                            false, // กำหนดให้วิดีโอไม่วนซ้ำ
                                        autoInitialize:
                                            true, // กำหนดให้วิดีโอเตรียมพร้อมในระหว่างการโหลด
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(child: Text('ไม่มีวิดีโอ')),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () {
              //     Get.snackbar('title', '$videoUrls');
              //   },
              //   child: Text('Show SnackBar'),
              // ),
            ],
          ),
        ));
  }
}
