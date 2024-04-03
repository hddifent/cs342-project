import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs342_project/app_pages/page_write_review.dart';
import 'package:cs342_project/constants.dart';
import 'package:cs342_project/database/firestore.dart';
import 'package:cs342_project/global.dart';
import 'package:cs342_project/models/app_user.dart';
import 'package:cs342_project/models/dorm.dart';
import 'package:cs342_project/models/review.dart';
import 'package:cs342_project/widgets/green_button.dart';
import 'package:cs342_project/widgets/loading.dart';
import 'package:cs342_project/widgets/review_card.dart';
import 'package:flutter/material.dart';

import '../database/firebase_auth.dart';

class DormReviewPage extends StatefulWidget {
  final Dorm dorm;

  const DormReviewPage({super.key, required this.dorm});

  @override
  State<DormReviewPage> createState() => _DormReviewPageState();
}

class _DormReviewPageState extends State<DormReviewPage> {
  bool _isLoading = true;

  List<ReviewCard> _reviews = [];
  ReviewCard? userReview;
  String? userReviewID;
  int _totalReview = -1;

  @override
  void initState() {
    super.initState();
    _getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AuthenticationDatabase.getCurrentUser() == null ? 
                    const SizedBox(height: 0) : _getYourReview(),
                  AuthenticationDatabase.getCurrentUser() == null 
                    ? const SizedBox(height: 0) : const SizedBox(height: 10),
              
                  Text("Reviews ($_totalReview)", style: AppTextStyle.heading1.merge(AppTextStyle.bold)),
                  Column(children: _reviews)
                ]
              ),
            )
          )
        ),
        loading(_isLoading)
      ]
    );
  }

  Widget _getYourReview() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Review",
              style: AppTextStyle.heading1.merge(AppTextStyle.bold)
            ),
            greenButton(
              userReview == null ? "Write" : "Edit",
              _reviewAction, width: 100, icon: Icons.edit
            )
          ]
        ),

        userReview ?? const SizedBox(width: 0, height: 0)
      ]
    );
  }

  void _reviewAction() {
    Navigator.pushReplacement(context, 
      MaterialPageRoute(
        builder: (context) 
          => WriteReviewPage(
            dorm: widget.dorm,
            isEdit: userReview != null,
            review: userReview?.review,
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
      _isLoading = false;
    });
  }

  Future<List<ReviewCard>> _getReviewList(List<AppUser> appUserList) async {
    List<Review> reviewList = [];
    List<ReviewCard> reviewCardList = [];

    FirestoreDatabase reviewsDB = FirestoreDatabase("reviews");
  
    await reviewsDB.collection.get().then((reviewCollection) {
      if (reviewCollection.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> doc in reviewCollection.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Review review = Review.fromFirestore(data);
          review.reviewID = doc.id;
          if (review.dormID.id == widget.dorm.dormID) {
            reviewList.add(review);
          }
        }

        reviewList.sort((a, b) => b.postTimestamp.compareTo(a.postTimestamp));
        for (Review review in reviewList) {
          ReviewCard reviewCard = ReviewCard(
            review: review,
            appUser: appUserList.firstWhere((element) => element.userID == review.userID.id)
          );

          reviewCardList.add(reviewCard);

          if (currentAppUser != null && review.userID.id == currentAppUser!.userID) {
            userReview = reviewCard;
            userReviewID = review.reviewID;
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