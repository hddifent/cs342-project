import "package:cloud_firestore/cloud_firestore.dart";
import "package:cs342_project/app_pages/page_edit_profile.dart";
import "package:cs342_project/constants.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/models/review.dart";
import "package:cs342_project/widgets/dorm_card.dart";
import "package:cs342_project/widgets/green_button.dart";
import "package:cs342_project/widgets/loading.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart" show timeDilation;
import "../global.dart";
import "../models/dorm.dart";

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<DormCard> _yourReviewsList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    if (currentUser != null) {
      List<Dorm> dormList = [];
    
      await _getDormList().then((value) => dormList = value);
      await _yourReviews(dormList).then((value) => _yourReviewsList = value);
    }

    if (!mounted) { return; }
    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Stack(
      children: <Widget>[
        currentUser != null ? _account() : _toStartReview(),
        loading(_isLoading)
      ],
    );
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

          Column(children: _yourReviewsList)
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

  Future<List<DormCard>> _yourReviews(List<Dorm> dormList) async {
    List<DormCard> reviewCardList = [];

    FirestoreDatabase reviewDB = FirestoreDatabase("reviews");
  
    await reviewDB.collection.get().then((reviewCollection) {
      if (reviewCollection.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> doc in reviewCollection.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Review review = Review.fromFirestore(data);

          if (currentUser != null && review.userID.id == currentUser!.uid) {
            DormCard dormReviewCard = DormCard(
              dorm: dormList.firstWhere((element) => element.dormID == review.dormID.id),
              isReview: true, review: review, appUser: currentAppUser,
            );

            reviewCardList.add(dormReviewCard);
          }
        }
      }
    });
    
    return reviewCardList;
  }

  Future<List<Dorm>> _getDormList() async {
    List<Dorm> dormList = [];

    FirestoreDatabase dormDB = FirestoreDatabase("dorms");

    await dormDB.collection.get().then((dormCollection) async {
      if (dormCollection.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> doc in dormCollection.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          dormList.add(await Dorm.fromFirestore(doc.id, data));
        }
      }
    });

    return dormList;
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
