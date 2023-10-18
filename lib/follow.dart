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

Future<String> getBookmarkID (String userid, String foodid) async {
  DocumentReference userDoc = FirebaseFirestore.instance
      .collection('bookmark')
      .doc(userid);

  DocumentSnapshot userSnapshot = await userDoc.get();

  if (userSnapshot.exists) {
    CollectionReference bookmarkCollection = userDoc.collection('bookmarkID');

    QuerySnapshot bookmarkSnapshot = await bookmarkCollection.get();

    if (bookmarkSnapshot.docs.isNotEmpty) {
      return bookmarkSnapshot.docs.first.id;
    }
  }

  return ''; // หรือคืนค่าเริ่มต้นที่คุณต้องการ
}

Future<int> getFollowerNum(String userId) async {
  DocumentReference userDoc = FirebaseFirestore.instance
      .collection('followers')
      .doc(userId);

  try {
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      CollectionReference followerCollection = userDoc.collection('followersID');

      QuerySnapshot followerSnapshot = await followerCollection.get();

      return followerSnapshot.docs.length; // คืนจำนวนของเอกสารในคอลเลคชัน "followersID"
    }
  } catch (e) {
    // รับข้อผิดพลาดที่เกิดขึ้น
    print('เกิดข้อผิดพลาด: $e');
  }

  return 0; // หรือคืนค่าเริ่มต้นที่คุณต้องการถ้าไม่มีข้อมูล
}




}
