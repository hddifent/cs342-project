class Review {
  String ownerUsername;
  String dormID;
  int overallRating;
  int priceRating;
  int hygieneRating;
  int serviceRating;
  int travelingRating;
  String review;
  int helpfulRatedNumber;
  int ratedNumber;

  Review({
    required this.ownerUsername,
    required this.dormID,
    required this.overallRating,
    required this.priceRating,
    required this.hygieneRating,
    required this.serviceRating,
    required this.travelingRating,
    required this.review,
    this.helpfulRatedNumber = 0,
    this.ratedNumber = 0
  });

  double getHelpfulRatio() {
    return helpfulRatedNumber/ratedNumber;
  }

  factory Review.fromFirestore(Map<String, dynamic> map) {
    return Review(
      ownerUsername: map['ownerUsername'],
      dormID: map['dormID'], 
      overallRating: map['overallRating'], 
      priceRating: map['priceRating'], 
      hygieneRating: map['hygieneRating'], 
      serviceRating: map['serviceRating'], 
      travelingRating: map['travelingRating'], 
      review: map['review'],
      helpfulRatedNumber: map['helpfulRatedNumber'],
      ratedNumber: map['ratedNumber']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "ownerUsername": ownerUsername,
      "dormID": dormID,
      "overallRating": overallRating,
      "priceRating": priceRating,
      "hygieneRating": hygieneRating,
      "serviceRating": serviceRating,
      "travelingRating": travelingRating,
      "review": review,
      "helpfulRatedNumber": helpfulRatedNumber,
      "ratedNumber": ratedNumber
    };
  }

}