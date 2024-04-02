import "package:cloud_firestore/cloud_firestore.dart";
import "package:cs342_project/app_pages/page_edit_profile.dart";
import "package:cs342_project/constants.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/models/review.dart";
import "package:cs342_project/widgets/green_button.dart";
import "package:cs342_project/widgets/review_card.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart" show timeDilation;
import "../global.dart";

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return currentUser != null ? _account() : _toStartReview();
  }

  Widget _account() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _profileBar(context),

          const SizedBox(height: 10),

          Text("Your Reviews", style: AppTextStyle.heading1.merge(AppTextStyle.bold)),

          _yourReviews()
        ],
      ),
    );
  }

  Widget _profileBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'profileAvatar',
              child: CircleAvatar(
                maxRadius: 40,
                backgroundImage: currentAppUser!.getProfileImage(),
              ),
            ),

            const SizedBox(width: 10),

            _rightBar()
          ],
        ),
      ),
    );
  }

  Widget _rightBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello, ${currentAppUser!.username}!", 
          style: AppTextStyle.heading1.merge(AppTextStyle.bold),
        ),
        greenButton("Edit Profile", 
          () => Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const EditProfilePage())
          )
        )
      ],
    );
  }

  Widget _yourReviews() {
    final FirestoreDatabase reviewDB = FirestoreDatabase('reviews');
    return StreamBuilder<QuerySnapshot>(
      stream: reviewDB.getStream('userID'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Object?>> reviewDocList = snapshot.data?.docs ?? [];
          List<Review> reviewList = [];
          List<Widget> reviewCardList = [];

          for (QueryDocumentSnapshot<Object?> doc in reviewDocList) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            Review review = Review.fromFirestore(data);

            if (review.userID.id == currentUser!.uid) {
              reviewList.add(review);
            }
          }

          for (Review r in reviewList) {
            reviewCardList.add(
            ReviewCard(
              review: r, 
              appUser: currentAppUser!)
            );
          }

          return Expanded(
            child: SingleChildScrollView(
              child: Column(children: reviewCardList)
            ),
          );
        } else {
          return const Text("No Review in database...");
        }
      }
    );
  }

  Widget _toStartReview() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'To start reviewing, please log into your account.',
            textAlign: TextAlign.center,
            style: AppTextStyle.heading1,
          ),
          greenButton('Login / Register', () => Navigator.pop(context))
        ],
      ),
    );
  }

}
