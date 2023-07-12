import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  //Field
  String? email, pathImage, name, phone, uid;

  User({this.email, this.name, this.pathImage, this.phone, this.uid});

  Map<String, dynamic> toJson()=>
  {
    'Email': email,
    'ImageP': pathImage,
    'Name': name,
    'Phone': phone,
    'Uid': uid,
    
  };

  static User fromSnap(DocumentSnapshot snapshot){
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return User(
    email : dataSnapshot['Email'],
    pathImage : dataSnapshot['ImageP'],
    name : dataSnapshot['Name'],
    phone : dataSnapshot['Phone'],
    uid : dataSnapshot['Uid'],
    );
  }

}