import 'package:cloud_firestore/cloud_firestore.dart';

class Follower {
  final String documentId; // เพิ่ม field documentId เพื่อใช้เป็น ID ของเอกสาร
  final String followerID;
  final String userID;

  Follower({required this.documentId, required this.followerID, required this.userID});
}

class FollowerService {
  //ฟังก์ชันติดตาม
  // เพิ่มข้อมูลผู้ใช้งาน
Future<void> addUser(String userId, String userName) {
  CollectionReference users = FirebaseFirestore.instance.collection('followers');
  
  return users
      .doc(userId)
      .set({
        'followersID': [] // ตั้งค่าให้เป็น List เปล่าก่อน
      });
}


// เพิ่มผู้ติดตามใหม่ใน List ของผู้ใช้งาน
Future<void> addFollower(String userId, String followerId) {
  CollectionReference followers = FirebaseFirestore.instance
      .collection('followers')
      .doc(userId)
      .collection('followersID'); // Subcollection "followers"

  return followers
      .doc(followerId)
      .set({
        'followdate' : Timestamp.now(),
        
      });
}

Future<void> unfollowUser(String userId, String followerId) {
  CollectionReference followers = FirebaseFirestore.instance
      .collection('followers')
      .doc(userId)
      .collection('followersID'); // Subcollection "followers"

  return followers
      .doc(followerId)
      .delete();
}

//บุ๊คมาร์ค ติดดาว
Future<void> addBook(String userId, String foodid) {
  CollectionReference bookmark = FirebaseFirestore.instance.collection('bookmark');
  
  return bookmark
      .doc(foodid)
      .set({
        'bookmarkID': [] 
      });
}


Future<void> addBookmark(String userId, String foodid) {
  CollectionReference bookmark = FirebaseFirestore.instance
      .collection('bookmark')
      .doc(userId)
      .collection('bookmarkID'); // Subcollection "bookmark"

  return bookmark
      .doc(foodid)
      .set({
        'bookmarkdate' : Timestamp.now(),
        
      });
}

Future<void> unBookmark(String userId, String foodid) {
  CollectionReference bookmark = FirebaseFirestore.instance
      .collection('bookmark')
      .doc(userId)
      .collection('bookmarkID'); 

  return bookmark
      .doc(foodid)
      .delete();
}

Future<String> getBookmarkID (String userid,String foodid) async{
  CollectionReference bookmark = FirebaseFirestore.instance
    .collection('bookmark')
    .doc(userid)
    .collection('bookmarkID');

   QuerySnapshot querySnapshot = await bookmark.get();

  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.id;
  } else {
    return ''; // หรือค่าเริ่มต้นที่เหมาะสมตามที่คุณต้องการ
  }
}
 


}
