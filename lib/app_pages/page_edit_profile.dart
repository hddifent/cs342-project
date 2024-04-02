import "package:cs342_project/app_pages/mask_main.dart";
import "package:cs342_project/database/firebase_auth.dart";
import "package:cs342_project/database/firebase_storage.dart";
import "package:cs342_project/database/firestore.dart";
import "package:cs342_project/global.dart";
import "package:cs342_project/utils/string_extension.dart";
import "package:cs342_project/widgets/loading.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart" show timeDilation;
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
  late final StorageDatabase _storageDB;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _firstNameText = currentAppUser!.firstName, 
    _lastNameText = currentAppUser!.lastName, 
    _usernameText = currentAppUser!.username;

  String _saveChangesErrorText = 'Save Changes', 
    _changePasswordErrorText = 'Change Password';

  bool _isSaveChangesError = false, _isSaveChangesSuccess = false,
    _isChangePasswordError = false, _isChangePasswordSuccess = false,
    _isLoading = false;

  @override
  void initState() {
    super.initState();

    _storageDB = StorageDatabase('profileImages');

    _firstNameController = TextEditingController(text: _firstNameText);
    _lastNameController = TextEditingController(text: _lastNameText);
    _usernameController = TextEditingController(text: _usernameText);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return PopScope(
      canPop: false,
      
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: AppPalette.green,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) 
                    => const MainMask(initialIndex: 2)
                )
              );
            }, 
            icon: const Icon(Icons.arrow_back)
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _editProfile()
            ),
            loading(_isLoading)
          ],
        )
      ),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: 'profileAvatar',
          child: CircleAvatar(
            maxRadius: 100,
            backgroundImage: currentAppUser!.getProfileImage(),
            child: _imageButtons()
          ),
        ),
      ],
    );
  }

  Widget _imageButtons() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            onPressed: () => takePicture(ImageSource.gallery),
            icon: const Icon(Icons.image),
            iconSize: 40,
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppPalette.green),
              elevation: MaterialStatePropertyAll(10)
            ),
          ),
          
          IconButton(
            onPressed: () => takePicture(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_rounded),
            iconSize: 40,
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppPalette.green),
              elevation: MaterialStatePropertyAll(10)
            ),
          ),
        ],
      )
    );
  }

  Future takePicture(ImageSource source) async {
    setState(() { _isLoading = true; });
    try {
      XFile? image = await ImagePicker().pickImage(source: source);

      if (image == null) { return; }

      Uint8List imageFile = await image.readAsBytes();

      String? imageURL = await _storageDB.saveImage(currentUser!.uid, imageFile);

      setState(() {
        currentAppUser!.profileImageURL = imageURL!;
      });

      await _userDB.updateDocument(currentUser!.uid, currentAppUser!.toFirestore());
      setState(() => _isLoading = false);
    } on PlatformException { rethrow; }
    on FirebaseException { rethrow; } 
  }
  
  void _saveChangesValidation() async {
    if (_firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty &&
      _firstNameController.text.capitalize() == _firstNameText &&
      _lastNameController.text.capitalize() == _lastNameText &&
      _usernameController.text.toLowerCase() == _usernameText) 
    {
      _setDescriptionTextFields();
      return;
    }
    if (_isSaveChangesError) { return; }

    setState(() {
      primaryFocus!.unfocus();

      if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty) {
        _setDescriptionTextFields();
        
        _isSaveChangesError = true;
        _saveChangesErrorText = 'Please fill the blanks';
      }
    });

    if (!_isSaveChangesError) {
      setState(() {
        _firstNameText = _firstNameController.text.capitalize();
        _lastNameText = _lastNameController.text.capitalize();
        _usernameText = _usernameController.text.toLowerCase();

        currentAppUser!.firstName = _firstNameText;
        currentAppUser!.lastName = _lastNameText;
        currentAppUser!.username = _usernameText;
        
        _isSaveChangesSuccess = true;
        _saveChangesErrorText = 'Successfully Changed';
      });

      _setDescriptionTextFields();

      await _userDB.updateDocument(currentUser!.uid, currentAppUser!.toFirestore());
    }
  }

  void _setDescriptionTextFields() {
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
      } else if (_newPasswordController.text != _confirmPasswordController.text) {
        _isChangePasswordError = true;
        _changePasswordErrorText = 'Wrong confirmation';
      }
    });

    String? result = await AuthenticationDatabase.changePassword(_newPasswordController.text);
    setState(() {
      if (result == 'weak-password') {
        _isChangePasswordError = true;
        //FIXME
        _changePasswordErrorText = 'Password should be \nat least 6 letters';
      }
    });

    if (!_isChangePasswordError) {
      setState(() {
        // currentAppUser!.password = _newPasswordController.text;

        _isChangePasswordSuccess = true;
        _changePasswordErrorText = 'Successfully Changed';
      });

      await _userDB.updateDocument(currentUser!.uid, currentAppUser!.toFirestore());
    }

    setState(() {
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

}