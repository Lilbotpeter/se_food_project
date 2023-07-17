import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.imageXFile,
    required this.image,
  });

  final File? imageXFile;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.amberAccent,
      minRadius: 58.0,
      child: CircleAvatar(
        radius: 50.0,
        backgroundImage: imageXFile == null
            ? NetworkImage(image ?? '')
            : Image.file(imageXFile!).image,
      ),
    );
  }
}