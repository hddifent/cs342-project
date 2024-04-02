import "package:cloud_firestore/cloud_firestore.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/models/review.dart";
import "package:firebase_storage/firebase_storage.dart";

class Dorm {
  final String dormID;

  final String dormName;
  final String dormDescription;
  final GeoPoint geoLocation;
  final String location;
  final int monthlyPrice;
  final Map<String, dynamic> contactInfo;

  double rating = 0;
  List<String> imagePath = [];

  Dorm._(this.dormID, {
    required this.dormName,
    required this.dormDescription,
    required this.geoLocation,
    required this.location,
    required this.monthlyPrice,
    required this.contactInfo
  });

  static Future<Dorm> fromFirestore(String dormID, Map<String, dynamic> map) async {
    map["description"] = (map["description"] as String).replaceAll(r"\n", "\n");

    Dorm dorm = Dorm._(dormID,
      dormName: map["name"],
      dormDescription: map["description"],
      geoLocation: map["geoLocation"],
      location: map["location"],
      monthlyPrice: map["monthlyPrice"],
      contactInfo: map["contactInfo"]
    );

    await dorm._getRating();
    await dorm._getImages();

    return dorm;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": dormName,
      "description": dormDescription,
      "geoLocation": geoLocation,
      "location": location,
      "monthlyPrice": monthlyPrice,
      "contactInfo": contactInfo
    };
  }

  Future<void> _getRating() async {
    double totalScore = 0;
    int totalReview = 0;

    FirestoreDatabase db = FirestoreDatabase("reviews");

    await db.collection.get().then((reviewCollection) {
      if (reviewCollection.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> doc in reviewCollection.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Review review = Review.fromFirestore(data);

          if (review.dormID.id == dormID) {
            totalScore += review.getOverallRating();
            totalReview += 1;
          }
        }
      }
    });

    rating = totalReview > 0 ? totalScore / totalReview : 0;
  }

  Future<void> _getImages() async {
    Reference storageRef = FirebaseStorage.instance.ref().child("dormImages/$dormID");
    ListResult listResult = await storageRef.listAll();
    for (Reference r in listResult.items) {
      imagePath.add(await r.getDownloadURL());
    }
  }
}