import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  final List<String> getVdoID = Get.arguments as List<String>;
  int selectedVideoIndex = 0;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      getVdoID[selectedVideoIndex],
    );

    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      // อย่าลืมรอให้วิดีโอเริ่มต้นเสร็จ
      setState(() {}); // รีเรนเดอร์ UI หลังจากวิดีโอเริ่มต้นเสร็จ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              )
            : CircularProgressIndicator(), // แสดงแถบความคืบหน้าขณะรอวิดีโอเริ่มต้น
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_videoPlayerController.value.isPlaying) {
              _videoPlayerController.pause();
            } else {
              _videoPlayerController.play();
            }
          });
        },
        child: Icon(
          _videoPlayerController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
      bottomNavigationBar: getVdoID.length >= 2
          ? BottomNavigationBar(
              items: getVdoID.asMap().entries.map((entry) {
                final index = entry.key;
                return BottomNavigationBarItem(
                  icon: Icon(Icons.video_label),
                  label: 'Video ${index+1}',
                );
              }).toList(),
              currentIndex: selectedVideoIndex,
              onTap: (index) {
                selectedVideoIndex = index;
                _videoPlayerController = VideoPlayerController.network(
                  getVdoID[selectedVideoIndex],
                );
                _initializeVideoPlayerFuture =
                    _videoPlayerController.initialize().then((_) {
                  setState(() {});
                });
              },
            )
          : null, // ไม่แสดง BottomNavigationBar ถ้ารายการน้อยกว่า 2 รายการ
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
