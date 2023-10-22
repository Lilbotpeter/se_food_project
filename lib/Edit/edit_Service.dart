import 'package:cloud_firestore/cloud_firestore.dart';

class EditService {
  String hello() {
    print('Hello World');
    return 'Hello World';
  }

  Future DeleteCommentData(String docID) async {
    String IdFood;
    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot idFood in querySnapshot.docs) {
        // print('idFood = ');
        // print(idFood.id);
        IdFood = idFood.id;
        QuerySnapshot comment = await firestore
            .collection('CommentFood')
            .doc(idFood.id)
            .collection('CommentID')
            .get();

        if (comment.docs.isNotEmpty) {
          for (QueryDocumentSnapshot idComment in comment.docs) {
            print('idComment = ');
            print(idComment.id);
            if (idComment['Uid'] == docID) {
              print('True Ballza');
              try {
                await firestore
                    .collection('CommentFood')
                    .doc(IdFood)
                    .collection('CommentID')
                    .doc(idComment.id)
                    .delete();
                print(
                    'ลบข้อมูลเรียบร้อย'); // คุณสามารถแสดงข้อความนี้เพื่อแจ้งให้ทราบว่าข้อมูลถูกลบเรียบร้อย
              } catch (e) {
                print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
              }
            }
          }
        } else {
          print('No data');
        }
      }
      return;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

//--------------------------------------------
  Future DeleteReviewData(String docID) async {
    String IdFood;
    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot idFood in querySnapshot.docs) {
        // print('idFood = ');
        // print(idFood.id);
        IdFood = idFood.id;
        QuerySnapshot Review = await firestore
            .collection('ReviewFood')
            .doc(idFood.id)
            .collection('ReviewID')
            .get();

        if (Review.docs.isNotEmpty) {
          for (QueryDocumentSnapshot idReview in Review.docs) {
            print('idReviewFood = ');
            print(idReview.id);
            if (idReview['Uid'] == docID) {
              print('True Ballza');
              try {
                await firestore
                    .collection('ReviewFood')
                    .doc(IdFood)
                    .collection('ReviewID')
                    .doc(idReview.id)
                    .delete();
                print(
                    'ลบข้อมูลเรียบร้อย'); // คุณสามารถแสดงข้อความนี้เพื่อแจ้งให้ทราบว่าข้อมูลถูกลบเรียบร้อย
              } catch (e) {
                print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
              }
            }
          }
        } else {
          print('No data');
        }
      }
      return;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  //--------------------------------------------
  Future DeleteModData(String docID) async {
    String IdFood;
    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot idFood in querySnapshot.docs) {
        // print('idFood = ');
        // print(idFood.id);
        IdFood = idFood.id;
        QuerySnapshot Modify = await firestore
            .collection('ModifyFood')
            .doc(idFood.id)
            .collection('ModID')
            .get();

        if (Modify.docs.isNotEmpty) {
          for (QueryDocumentSnapshot idModify in Modify.docs) {
            print('idModify = ');
            print(idModify.id);
            if (idModify['Uid'] == docID) {
              print('True Ballza');
              try {
                await firestore
                    .collection('ModifyFood')
                    .doc(IdFood)
                    .collection('ModID')
                    .doc(idModify.id)
                    .delete();
                print(
                    'ลบข้อมูลเรียบร้อย'); // คุณสามารถแสดงข้อความนี้เพื่อแจ้งให้ทราบว่าข้อมูลถูกลบเรียบร้อย
              } catch (e) {
                print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
              }
            }
          }
        } else {
          print('No data');
        }
      }
      return;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  //--------------------------------------------
  Future DeleteReplyCommentData(String docID) async {
    String IdFood;
    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot idFood in querySnapshot.docs) {
        // print('idFood = ');
        // print(idFood.id);
        IdFood = idFood.id;
        QuerySnapshot comment = await firestore
            .collection('CommentFood')
            .doc(idFood.id)
            .collection('CommentID')
            .get();

        if (comment.docs.isNotEmpty) {
          for (QueryDocumentSnapshot idComment in comment.docs) {
            print('idComment = ');
            print(idComment.id);
            if (idComment['Uid'] == docID) {
              print('True Ballza');
              try {
                await firestore
                    .collection('CommentFood')
                    .doc(IdFood)
                    .collection('CommentID')
                    .doc(idComment.id)
                    .delete();
                print(
                    'ลบข้อมูลเรียบร้อย'); // คุณสามารถแสดงข้อความนี้เพื่อแจ้งให้ทราบว่าข้อมูลถูกลบเรียบร้อย
              } catch (e) {
                print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
              }
            }
          }
        } else {
          print('No data');
        }
      }
      return;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

//--------------------------------------------
}
