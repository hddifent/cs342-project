import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  DocumentReference userID;
  DocumentReference dormID;
  int priceRating;
  int hygieneRating;
  int serviceRating;
  int travelingRating;
  String review;
  int helpfulRatedNumber;
  int ratedNumber;
  Timestamp postTimestamp;

  Review({
    required this.userID,
    required this.dormID,
    required this.priceRating,
    required this.hygieneRating,
    required this.serviceRating,
    required this.travelingRating,
    required this.review,
    this.helpfulRatedNumber = 0,
    this.ratedNumber = 0,
    required this.postTimestamp
  });

  double getOverallRating() {
    return (priceRating + hygieneRating + serviceRating + travelingRating) / 4.0;
  }

  double getHelpfulRatio() {
    return helpfulRatedNumber / ratedNumber.toDouble();
  }

  factory Review.fromFirestore(Map<String, dynamic> map) {
    return Review(
      userID: map['userID'],
      dormID: map['dormID'],
      priceRating: map['priceRating'],
      hygieneRating: map['hygieneRating'],
      serviceRating: map['serviceRating'],
      travelingRating: map['travelingRating'],
      review: map['review'],
      helpfulRatedNumber: map['helpfulRatedNumber'],
      ratedNumber: map['ratedNumber'],
      postTimestamp: map['postTimestamp']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userID": userID,
      "dormID": dormID,
      "priceRating": priceRating,
      "hygieneRating": hygieneRating,
      "serviceRating": serviceRating,
      "travelingRating": travelingRating,
      "review": review,
      "helpfulRatedNumber": helpfulRatedNumber,
      "ratedNumber": ratedNumber,
      "postTImestamp": postTimestamp
    };
  }

}