import "dart:io";
import "package:cs342_project/app_pages/mask_main.dart";
import "package:cs342_project/app_pages/page_sign_up.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/global.dart";
import "package:cs342_project/models/app_user.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import "../constants.dart";
import "../widgets/green_button.dart";
import "../widgets/text_field_icon.dart";

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirestoreDatabase _userDB = FirestoreDatabase('users');

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _firstNameText = currentAppUser!.firstName, 
    _lastNameText = currentAppUser!.lastName, 
    _usernameText = currentAppUser!.username;
  final String  _oldPasswordText = currentAppUser!.password;

  String _saveChangesErrorText = 'Save Changes', 
    _changePasswordErrorText = 'Change Password';

  bool _isSaveChangesError = false, _isSaveChangesSuccess = false,
    _isChangePasswordError = false, _isWeakPassword = false,
    _isChangePasswordSuccess = false;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(text: _firstNameText);
    _lastNameController = TextEditingController(text: _lastNameText);
    _usernameController = TextEditingController(text: _usernameText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppPalette.green,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            //FIXME
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const MainMask())
            );
          }, 
          icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _editProfile()
      )
    );
  }

  void _checkTextFieldChange(bool forSaveChange) {
    setState(() {
      if (forSaveChange) {
        _isSaveChangesError = false;
        _isSaveChangesSuccess = false;
        _saveChangesErrorText = 'Save Changes';
      } else {
        _isChangePasswordError = false;
        _isChangePasswordSuccess = false;
        _changePasswordErrorText = 'Change Password';
      }
    });
  }

  Widget _editProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _profileImage(),

        const SizedBox(height: 20),

        TextFieldWithIcon(
          controller: _firstNameController, 
          prefixIcon: const Icon(Icons.edit, size: 30),
          onChanged: (text) => _checkTextFieldChange(true), 
          prompt: 'First Name',
          sizedBoxHeight: 10,
          isErrorLogic: _isSaveChangesError,
          isSuccessLogic: _isSaveChangesSuccess,
        ),
    
        TextFieldWithIcon(
          controller: _lastNameController, 
          prefixIcon: const Icon(Icons.edit, size: 30),
          onChanged: (text) => _checkTextFieldChange(true), 
          prompt: 'Last Name',
          sizedBoxHeight: 10,
          isErrorLogic: _isSaveChangesError,
          isSuccessLogic: _isSaveChangesSuccess,
        ),
    
        TextFieldWithIcon(
          controller: _usernameController, 
          prefixIcon: const Icon(Icons.person, size: 30),
          onChanged: (text) => _checkTextFieldChange(true), 
          prompt: 'Username',
          sizedBoxHeight: 15,
          isErrorLogic: _isSaveChangesError,
          isSuccessLogic: _isSaveChangesSuccess,
        ),

        greenButton(_saveChangesErrorText, 
          _saveChangesValidation,
          isDisabled: _isSaveChangesError
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
          controller: _oldPasswordController, 
          prefixIcon: const Icon(Icons.lock, size: 30), 
          isObsecured: true,
          onChanged: (text) => _checkTextFieldChange(false),
          prompt: 'Current Password',
          sizedBoxHeight: 10,
          isErrorLogic: _isChangePasswordError,
          isSuccessLogic: _isChangePasswordSuccess,
        ),

        TextFieldWithIcon(
          controller: _newPasswordController, 
          prefixIcon: const Icon(Icons.lock, size: 30),
          isObsecured: true,
          onChanged: (text) => _checkTextFieldChange(false), 
          prompt: 'New Password',
          sizedBoxHeight: 10,
          isErrorLogic: _isChangePasswordError,
          isSuccessLogic: _isChangePasswordSuccess,
        ),
        
        TextFieldWithIcon(
          controller: _confirmPasswordController, 
          prefixIcon: const Icon(Icons.lock, size: 30), 
          isObsecured: true,
          onChanged: (text) => _checkTextFieldChange(true),
          prompt: 'Confirm New Password',
          sizedBoxHeight: 15,
          isErrorLogic: _isChangePasswordError,
          isSuccessLogic: _isChangePasswordSuccess,
        ),
    
        greenButton(_changePasswordErrorText, 
          _changePasswordValidation,
          isDisabled: _isChangePasswordError
        ),
      ],
    );
  }

  Widget _profileImage() {
    return CircleAvatar(
      maxRadius: 100,
      backgroundImage: profileImage,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () => takePicture(false),
              icon: const Icon(Icons.image),
              iconSize: 40,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppPalette.green),
                elevation: MaterialStatePropertyAll(10)
              ),
            ),
            
            IconButton(
              onPressed: () => takePicture(true),
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

  Future takePicture(bool fromCamera) async {
    try {
      XFile? image;
      if (fromCamera) { 
        image = await ImagePicker().pickImage(source: ImageSource.camera); 
      } else {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
      }

      if (image == null) { return; }

      setState(() {
        profileImage = FileImage(File(image!.path)) as ImageProvider<Object>;
      });
    } on PlatformException {
      rethrow;
    } 
  }
  
  void _saveChangesValidation() async {
    if (_firstNameController.text.capitalize() == _firstNameText &&
      _lastNameController.text.capitalize() == _lastNameText &&
      _usernameController.text.toLowerCase() == _usernameText) 
    {
      _setTextFields();
      return;
    }
    if (_isSaveChangesError) { return; }

    setState(() {
      primaryFocus!.unfocus();

      if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty) {
        _setTextFields();
        
        _isSaveChangesError = true;
        _saveChangesErrorText = 'Please fill the blanks';
      }
    });

    if (!_isSaveChangesError) {
      setState(() {
        _firstNameText = _firstNameController.text.capitalize();
        _lastNameText = _lastNameController.text.capitalize();
        _usernameText = _usernameController.text.toLowerCase();

        currentAppUser = AppUser(
          email: currentAppUser!.email, 
          firstName: _firstNameText, 
          lastName: _lastNameText, 
          username: _usernameText, 
          password: currentAppUser!.password, 
          profileImageURL: currentAppUser!.profileImageURL
        );
        
        _isSaveChangesSuccess = true;
        _saveChangesErrorText = 'Successfully Changed';
      });

      _setTextFields();

      await _userDB.updateDocument(currentUid!, currentAppUser!.toFirestore());
    }
  }

  void _setTextFields() {
    setState(() {
      _firstNameController.text = _firstNameText;
      _lastNameController.text = _lastNameText;
      _usernameController.text = _usernameText;
    });
  }

  void _changePasswordValidation() async {
    if (_isChangePasswordError) { return; }

    setState(() {
      primaryFocus!.unfocus();
      if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
        _isChangePasswordError = true;
        _changePasswordErrorText = 'Please fill the blanks';
      } else if (_oldPasswordController.text != _oldPasswordText) {
        _isChangePasswordError = true;
        _changePasswordErrorText = 'Wrong current password';
      } else if (_newPasswordController.text != _confirmPasswordController.text) {
        _isChangePasswordError = true;
        _changePasswordErrorText = 'Wrong confirmation';
      }
    });

    _isWeakPassword = false;
    await _changePassword();
    setState(() {
      if (_isWeakPassword) {
        _isChangePasswordError = true;
        _changePasswordErrorText = 'Password should be \nat least 6 letters';
      }
    });

    if (!_isChangePasswordError) {
      setState(() {
        currentAppUser = AppUser(
          email: currentAppUser!.email, 
          firstName: currentAppUser!.firstName, 
          lastName: currentAppUser!.lastName, 
          username: currentAppUser!.username, 
          password: _newPasswordController.text, 
          profileImageURL: currentAppUser!.profileImageURL
        );

        _isChangePasswordSuccess = true;
        _changePasswordErrorText = 'Successfully Changed';
      });

      await _userDB.updateDocument(currentUid!, currentAppUser!.toFirestore());
    }

    setState(() {
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _changePassword() async {
    try {
      await currentUser!.updatePassword(_newPasswordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _isWeakPassword = true;
      }
    }
  }

}