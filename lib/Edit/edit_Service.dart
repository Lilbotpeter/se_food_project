import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
            // print('idReviewFood = ');
            // print(idReview.id);

            if (idReview['Uid'] == docID) {
              print('True Ballza');
              try {
                await firestore
                    .collection('ReviewFood')
                    .doc(IdFood)
                    .collection('ReviewID')
                    .doc(idReview.id)
                    .delete();

                FirebaseStorage storage = FirebaseStorage.instance;
                FirebaseStorage storage2 = FirebaseStorage.instance;
                ListResult result = await storage
                    .ref()
                    .child('ReviewFood')
                    .child(idReview.id)
                    .child('Image')
                    .listAll();
                ListResult result2 = await storage2
                    .ref()
                    .child('ReviewFood')
                    .child(idReview.id)
                    .child('Video')
                    .listAll();
                for (Reference ref in result.items) {
                  // ลบแต่ละรูปภาพ
                  await ref.delete();
                }
                for (Reference ref2 in result2.items) {
                  // ลบแต่ละรูปภาพ
                  await ref2.delete();
                }
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
                FirebaseStorage storage = FirebaseStorage.instance;
                FirebaseStorage storage2 = FirebaseStorage.instance;
                ListResult result = await storage
                    .ref()
                    .child('ModifyFood')
                    .child(idModify.id)
                    .child('Image')
                    .listAll();
                ListResult result2 = await storage2
                    .ref()
                    .child('ModifyFood')
                    .child(idModify.id)
                    .child('Video')
                    .listAll();
                for (Reference ref in result.items) {
                  // ลบแต่ละรูปภาพ
                  await ref.delete();
                }
                for (Reference ref2 in result2.items) {
                  // ลบแต่ละรูปภาพ
                  await ref2.delete();
                }
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
    String IdComment;

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
        for (QueryDocumentSnapshot idcomment in comment.docs) {
          IdComment = idcomment.id;
          QuerySnapshot replyComment = await firestore
              .collection('ReplyComment')
              .doc(idcomment.id)
              .collection('ReplyCommentID')
              .get();
          if (replyComment.docs.isNotEmpty) {
            for (QueryDocumentSnapshot idreplyComment in replyComment.docs) {
              print('idComment = ');
              print(idreplyComment.id);
              if (idreplyComment['Uid'] == docID) {
                print('True Ballza');
                try {
                  await firestore
                      .collection('ReplyComment')
                      .doc(IdComment)
                      .collection('ReplyCommentID')
                      .doc(idreplyComment.id)
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
      }
      return;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

//--------------------------------------------
  Future DeleteReplyReview(String docID) async {
    String IdFood;
    String IdReview;

    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot idFood in querySnapshot.docs) {
        // print('idFood = ');
        // print(idFood.id);
        IdFood = idFood.id;
        QuerySnapshot comment = await firestore
            .collection('ReviewFood')
            .doc(idFood.id)
            .collection('ReviewID')
            .get();
        for (QueryDocumentSnapshot idReview in comment.docs) {
          IdReview = idReview.id;
          QuerySnapshot replyReview = await firestore
              .collection('ReplyReview')
              .doc(idReview.id)
              .collection('ReplyReviewID')
              .get();
          if (replyReview.docs.isNotEmpty) {
            for (QueryDocumentSnapshot idreplyReview in replyReview.docs) {
              print('idreplyReview = ');
              print(idreplyReview.id);
              if (idreplyReview['Uid'] == docID) {
                print('True Ballza');
                try {
                  await firestore
                      .collection('ReplyReview')
                      .doc(IdReview)
                      .collection('ReplyReviewID')
                      .doc(idreplyReview.id)
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
      }
      return;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

//--------------------------------------------
  Future DeleteReplyMod(String docID) async {
    String IdFood;
    String IdReview;

    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot idFood in querySnapshot.docs) {
        print('idFood = ');
        print(idFood.id);
        IdFood = idFood.id;
        QuerySnapshot comment = await firestore
            .collection('ModifyFood')
            .doc(idFood.id)
            .collection('ModID')
            .get();
        for (QueryDocumentSnapshot idReview in comment.docs) {
          IdReview = idReview.id;
          QuerySnapshot replyReview = await firestore
              .collection('ReplyMod')
              .doc(idReview.id)
              .collection('ReplyModID')
              .get();
          print('idFood = ');
          print(IdReview);
          if (replyReview.docs.isNotEmpty) {
            for (QueryDocumentSnapshot idreplyReview in replyReview.docs) {
              print('idreplyModifyFood = ');
              print(idreplyReview.id);
              if (idreplyReview['Uid'] == docID) {
                print('True Ballza');
                try {
                  await firestore
                      .collection('ReplyMod')
                      .doc(IdReview)
                      .collection('ReplyModID')
                      .doc(idreplyReview.id)
                      .delete();
                  print(
                      'ลบข้อมูลเรียบร้อย'); // คุณสามารถแสดงข้อความนี้เพื่อแจ้งให้ทราบว่าข้อมูลถูกลบเรียบร้อย
                } catch (e) {
                  print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
                }
              }
            }
          } else {
            print('No data555');
          }
        }
      }
      return;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

//--------------------------------------------
  Future DeleteFood(String docID) async {
    String IdFood;
    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('Foods').get();
      for (QueryDocumentSnapshot idFood in querySnapshot.docs) {
        IdFood = idFood.id;
        if (querySnapshot.docs.isNotEmpty) {
          if (idFood['User_id'] == docID) {
            print('True Ballza');
            try {
              await firestore.collection('Foods').doc(idFood.id).delete();
              FirebaseStorage storage = FirebaseStorage.instance;
              FirebaseStorage storage2 = FirebaseStorage.instance;
              ListResult result = await storage
                  .ref()
                  .child('files')
                  .child(IdFood)
                  .child('Image')
                  .listAll();

              ListResult result2 = await storage2
                  .ref()
                  .child('files')
                  .child(IdFood)
                  .child('Video')
                  .listAll();

              for (Reference ref in result.items) {
                // ลบแต่ละรูปภาพ
                print('Picture = ' + ref.toString());
                await ref.delete();
              }
              for (Reference ref2 in result2.items) {
                // ลบแต่ละรูปภาพ
                print('Video = ' + ref2.toString());
                await ref2.delete();
              }

              print(idFood['User_id'] +
                  'ถูกลบข้อมูลเรียบร้อย'); // คุณสามารถแสดงข้อความนี้เพื่อแจ้งให้ทราบว่าข้อมูลถูกลบเรียบร้อย
            } catch (e) {
              print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
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
  Future DeleteUser(String docID) async {
    String IdUser;
    try {
      //print('idFood = ');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore.collection('users').get();
      for (QueryDocumentSnapshot idUser in querySnapshot.docs) {
        IdUser = idUser.id;
        if (querySnapshot.docs.isNotEmpty) {
          if (idUser['Uid'] == docID) {
            print('True Ballza');
            try {
              await firestore.collection('users').doc(docID).delete();
              FirebaseStorage storage = FirebaseStorage.instance;
              ListResult result =
                  await storage.ref().child('Profile Picture').listAll();

              for (Reference ref in result.items) {
                // ลบแต่ละรูปภาพ
                if (ref.name == IdUser) {
                  print('สำเร็จแล้ว');
                  print('Picture = ' + ref.name);
                  await ref.delete();
                } else {
                  print('ไม่สำเร็จ ลองใหม่นะ');
                }
              }
              print(idUser.id + 'ถูกลบข้อมูลเรียบร้อย' + idUser['Uid']);
            } catch (e) {
              print('เกิดข้อผิดพลาดในการลบข้อมูล: $e');
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
}
