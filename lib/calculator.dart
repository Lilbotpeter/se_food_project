import 'package:cloud_firestore/cloud_firestore.dart';

class Calculator {
  final int number;
  final String foodID;
  final String reviewsID;

  Calculator(
      {required this.number, required this.foodID, required this.reviewsID});
}

class CalculatorService {
  Future<void> calRating(int number, String foodID) {
    CollectionReference reviews = FirebaseFirestore.instance
        .collection('Review')
        .doc(foodID)
        .collection('ReviewID'); // Subcollection "review"

    return reviews.doc(foodID).get();
  }
}
