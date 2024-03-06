import "package:cs342_project/app_pages/page_edit_profile.dart";
import "package:cs342_project/constants.dart";
import "package:cs342_project/widgets/green_button.dart";
import "package:flutter/material.dart";

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _profileBar(context),
          ],
        ),
      )
    );
  }

  Widget _profileBar(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircleAvatar(
            maxRadius: 40,
            backgroundImage: NetworkImage(defaultPictureProfileLink),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Hello, [Username]!", 
                style: TextStyle(fontSize: 25),
              ),
              greenButton("Edit Profile", 
                () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const EditProfilePage())
                )
              )
            ],
          )
        ],
      ),
    );
  }

}
