import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final String currentUserId;
  final List<String> currentUserFollows;
  final String userid;

  FollowButton({required this.currentUserId, required this.currentUserFollows, required this.userid});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        print("Current : " + userid);
        print("Owner : ");

        // ตรวจสอบว่าผู้ใช้ปัจจุบันติดตามผู้ใช้คนนี้หรือไม่
        bool isFollowing = currentUserFollows.contains(userid);

        // ถ้ายังไม่ได้ติดตาม ให้ติดตาม
        if (!isFollowing) {
          if (!currentUserFollows.contains(userid)) {
            currentUserFollows.add(userid);
            await FirebaseFirestore.instance.collection('followers').doc(currentUserId).set({
              'followers': currentUserFollows,
            });
          }
        }
        // ถ้าติดตามแล้ว ให้ยกเลิกติดตาม
        else {
          if (currentUserFollows.contains(userid)) {
            currentUserFollows.remove(userid);
            await FirebaseFirestore.instance.collection('followers').doc(currentUserId).set({
              'followers': currentUserFollows,
            });
          }
        }
      },
      child: Text(currentUserFollows.contains(userid)
          ? 'กดเพื่อยกเลิกติดตาม'
          : 'กดเพื่อติดตาม'),
    );
  }
}
