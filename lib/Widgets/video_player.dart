import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCarouselItem extends StatefulWidget {
  final String videoUrl;

  VideoCarouselItem({required this.videoUrl});

  @override
  _VideoCarouselItemState createState() => _VideoCarouselItemState();
}

class _VideoCarouselItemState extends State<VideoCarouselItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/project-food-c14c5.appspot.com/o/files%2FH5sET0TQaRIx9qXgkq4e%2FVideo%2FVID_20231013_234214.mp4?alt=media&token=a44332cb-2cb7-4418-b7f9-71f72a96baa7'));

    _controller.initialize().then((_) {
      // ตรวจสอบว่าวิดีโอพร้อมที่จะเล่น
      if (mounted) {
        setState(() {
          _controller.play();
        });
      }
    });

    _controller.setLooping(true); // ตั้งค่าให้วิดีโอเล่นวนซ้ำ
    _controller.play(); // เริ่มเล่นวิดีโอ
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: VideoPlayer(_controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
