import 'package:flutter/material.dart';

class UploadCustomIcon extends StatelessWidget {
  const UploadCustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 32,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left:12),
            width: 50,
            decoration: BoxDecoration(
              color:Color.fromARGB(255, 245, 141, 5),
              borderRadius: BorderRadius.circular(8),

            ),
          ),

          Container(
            margin: const EdgeInsets.only(right:12),
            width: 40,
            decoration: BoxDecoration(
              color:Color.fromARGB(255, 255, 175, 143),
              borderRadius: BorderRadius.circular(8),

            ),
          ),

          Center(
            child: Container(
              height: double.infinity,
              width: 40,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}