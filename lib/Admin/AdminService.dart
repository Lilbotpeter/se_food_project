import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFetch {
  final String
      nameCollection; // เพิ่ม field documentId เพื่อใช้เป็น ID ของเอกสาร

  AdminFetch({required this.nameCollection});
}

class AdminService {
  Future<List<dynamic>> fetchReportUserData(String nameCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> ReportDataList = [];

      QuerySnapshot querySnapshot =
          await firestore.collection(nameCollection).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;

        String Snapidx = snapID;
        //pull id report
        DocumentSnapshot docFirestoreDoc =
            await firestore.collection(nameCollection).doc(Snapidx).get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> modData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          ReportDataList.add({
            'Detail': modData['Detail'],
            'ID_User': modData['ID_User'],
            'Report': modData['Report'],
            'Time': modData['Time'],
            'ID_Report': modData['ID_Report']
          });
        }
      }
      return ReportDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }

  Future<List<dynamic>> fetchReportFoodData(String nameCollection) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<dynamic> ReportDataList = [];

      QuerySnapshot querySnapshot =
          await firestore.collection(nameCollection).get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String snapID = docSnapshot.id;

        String Snapidx = snapID;
        //pull id report
        DocumentSnapshot docFirestoreDoc =
            await firestore.collection(nameCollection).doc(Snapidx).get();

        if (docFirestoreDoc.exists) {
          Map<String, dynamic> modData =
              docFirestoreDoc.data() as Map<String, dynamic>;

          ReportDataList.add({
            'Detail': modData['Detail'],
            'ID_Food': modData['ID_Food'],
            'Report': modData['Report'],
            'Time': modData['Time'],
            'ID_Report': modData['ID_Report']
          });
        }
      }
      return ReportDataList;
    } catch (e) {
      print("Error fetching images: $e");
      throw e;
    }
  }
}
