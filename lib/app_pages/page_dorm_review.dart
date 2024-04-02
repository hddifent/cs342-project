import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs342_project/app_pages/page_write_review.dart';
import 'package:cs342_project/constants.dart';
import 'package:cs342_project/database/firestore.dart';
import 'package:cs342_project/global.dart';
import 'package:cs342_project/models/app_user.dart';
import 'package:cs342_project/models/dorm.dart';
import 'package:cs342_project/models/review.dart';
import 'package:cs342_project/widgets/green_button.dart';
import 'package:cs342_project/widgets/review_card.dart';
import 'package:flutter/material.dart';

class DormReviewPage extends StatefulWidget {
  final Dorm dorm;

  const DormReviewPage({super.key, required this.dorm});

  @override
  State<DormReviewPage> createState() => _DormReviewPageState();
}

class _DormReviewPageState extends State<DormReviewPage> {
  bool _loading = true;

  List<ReviewCard> _reviews = [];
  int _totalReview = -1;

  @override
  void initState() {
    super.initState();
    _getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
          
            children: <Widget>[
              // TODO: Check for user review...
              currentUser == null ? const SizedBox(height: 0) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Review",
                    style: AppTextStyle.heading1.merge(AppTextStyle.bold)
                  ),
                  greenButton("Write", _writeReview, width: 100, icon: Icons.edit)
                ]
              ),
          
              currentUser == null ? const SizedBox(height: 0) : const SizedBox(height: 10),
          
              _loading ? const CircularProgressIndicator()
                       : Text("Reviews ($_totalReview)", style: AppTextStyle.heading1.merge(AppTextStyle.bold)),
          
              _loading ? const SizedBox(height: 0) : Column(children: _reviews)
            ]
          ),
        )
      )
    );
  }

  void _writeReview() {
    Navigator.push(context, 
      MaterialPageRoute(
        builder: (context) 
          => WriteReviewPage(
            dormName: widget.dorm.dormName,
            dormID: widget.dorm.dormID,
          )
      )
    );
  }

  void _getInitData() async {
    List<AppUser> appUserList = [];
    
    await _getUserList().then((value) => appUserList = value);
    await _getReviewList(appUserList).then((value) => _reviews = value);

    if (!mounted) { return; }
    setState(() {
      _totalReview = _reviews.length;
      _loading = false;
    });
  }

  Future<List<ReviewCard>> _getReviewList(List<AppUser> appUserList) async {
    List<ReviewCard> reviewCardList = [];

    FirestoreDatabase reviewsDB = FirestoreDatabase("reviews");
  
    await reviewsDB.collection.get().then((reviewCollection) {
      if (reviewCollection.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> doc in reviewCollection.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Review review = Review.fromFirestore(data);

          if (review.dormID.id == widget.dorm.dormID) {
            reviewCardList.add(
              ReviewCard(
                review: review,
                appUser: appUserList.firstWhere((element) => element.userID == review.userID.id)
              )
            );
          }
        }
      }
    });
    
    return reviewCardList;
  }

  Future<List<AppUser>> _getUserList() async {
    List<AppUser> appUserList = [];

    FirestoreDatabase usersDB = FirestoreDatabase("users");

    await usersDB.collection.get().then((appUserCollection) {
      if (appUserCollection.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> doc in appUserCollection.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          appUserList.add(AppUser.fromFirestore(doc.id, data));
        }
      }
    });

    return appUserList;
  }
}