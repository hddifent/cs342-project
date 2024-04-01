import "package:cs342_project/app_pages/page_edit_profile.dart";
import "package:cs342_project/widgets/green_button.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart" show timeDilation;
import "../global.dart";
import "../models/dorm.dart";
import "../widgets/dorm_card.dart";

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Center(
      child: currentUser != null ?
        _account() :
        _toStartReview()
    );
  }

  Widget _account() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: _profileBar(context)),

          const SizedBox(height: 10),

          const Text("Your Reviews", 
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          ),

          Center(child: _yourReviews())
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello, ${currentAppUser!.username}!", 
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        greenButton("Edit Profile", 
          () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const EditProfilePage())
          )
        )
      ],
    );
  }

  Widget _yourReviews() {
    // TODO: This Is Also Placeholder, Adjust This Later
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const DormCard(
            dorm: Dorm(dormName: "KU Home", dormDescription: "Right there, inside the university. You can't get any better than this."),
            isSpecify: true,
          )
        ],
      ),
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
            style: TextStyle(fontSize: 25),
          ),
          greenButton('Login / Register', () => Navigator.pop(context))
        ],
      ),
    );
  }

}
