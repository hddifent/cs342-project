import "package:cs342_project/app_pages/page_camera.dart";
import "package:flutter/material.dart";
import "../constants.dart";
import "../widgets/green_button.dart";
import "../widgets/text_field_icon.dart";

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppPalette.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _editProfile()
      )
    );
  }

  Widget _editProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _profileImage(),

        const SizedBox(height: 20),

        TextFieldWithIcon(
          controller: _firstNameController, 
          prefixIcon: const Icon(Icons.edit), 
          prompt: 'First Name',
          sizedBoxHeight: 10,
        ),
    
        TextFieldWithIcon(
          controller: _lastNameController, 
          prefixIcon: const Icon(Icons.edit), 
          prompt: 'Last Name',
          sizedBoxHeight: 10,
        ),
    
        TextFieldWithIcon(
          controller: _usernameController, 
          prefixIcon: const Icon(Icons.person), 
          prompt: 'Username',
          sizedBoxHeight: 15,
        ),

        greenButton('Save Changes', 
          () {}
        ),

        const SizedBox(height: 20,),

        const SizedBox(
          height: 2.5,
          width: double.maxFinite,
          child: ClipRRect(
            child: ColoredBox(color: Colors.black)
          ),
        ),

        const SizedBox(height: 20),
    
        TextFieldWithIcon(
          controller: _passwordController, 
          prefixIcon: const Icon(Icons.lock), 
          prompt: 'New Password',
          isObsecured: true,
          sizedBoxHeight: 10,
        ),
        
        TextFieldWithIcon(
          controller: _confirmPasswordController, 
          prefixIcon: const Icon(Icons.lock), 
          prompt: 'Confirm New Password',
          isObsecured: true,
          sizedBoxHeight: 15,
        ),
    
        greenButton('Change Password', 
          () {}
        ),
      ],
    );
  }

  Widget _profileImage() {
    return CircleAvatar(
      maxRadius: 100,
      backgroundImage: const NetworkImage(defaultPictureProfileLink),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.image),
              iconSize: 40,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppPalette.green),
                elevation: MaterialStatePropertyAll(10)
              ),
            ),
            
            IconButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const TakePictureScreen()
                )
              ), 
              icon: const Icon(Icons.camera_alt_rounded),
              iconSize: 40,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppPalette.green),
                elevation: MaterialStatePropertyAll(10)
              ),
            ),
          ],
        )
      ),
    );
  }

}