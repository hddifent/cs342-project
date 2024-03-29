import "dart:io";
import "package:cs342_project/app_pages/mask_main.dart";
import "package:cs342_project/global.dart";
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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //TODO: Change Initialized Value, This Is Just An Example
  String _firstNameText = 'Rick', _lastNameText = 'Ashley', 
    _usernameText = 'RickRoll', _oldPasswordText = 'NeverGonnaGiveYouUp';

  String _saveChangesErrorText = 'Save Changes', 
    _changePasswordErrorText = 'Change Password';

  bool _isSaveChangesError = false, _isChangePasswordError = false;

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
        _saveChangesErrorText = 'Save Changes';
      } else {
        _isChangePasswordError = false;
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
        ),
    
        TextFieldWithIcon(
          controller: _lastNameController, 
          prefixIcon: const Icon(Icons.edit, size: 30),
          onChanged: (text) => _checkTextFieldChange(true), 
          prompt: 'Last Name',
          sizedBoxHeight: 10,
          isErrorLogic: _isSaveChangesError,
        ),
    
        TextFieldWithIcon(
          controller: _usernameController, 
          prefixIcon: const Icon(Icons.person, size: 30),
          onChanged: (text) => _checkTextFieldChange(true), 
          prompt: 'Username',
          sizedBoxHeight: 15,
          isErrorLogic: _isSaveChangesError,
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
        ),

        TextFieldWithIcon(
          controller: _newPasswordController, 
          prefixIcon: const Icon(Icons.lock, size: 30),
          isObsecured: true,
          onChanged: (text) => _checkTextFieldChange(false), 
          prompt: 'New Password',
          sizedBoxHeight: 10,
          isErrorLogic: _isChangePasswordError,
        ),
        
        TextFieldWithIcon(
          controller: _confirmPasswordController, 
          prefixIcon: const Icon(Icons.lock, size: 30), 
          isObsecured: true,
          onChanged: (text) => _checkTextFieldChange(true),
          prompt: 'Confirm New Password',
          sizedBoxHeight: 15,
          isErrorLogic: _isChangePasswordError,
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
    } on PlatformException catch (e) {
      if (fromCamera) {
        print('Failed to take picture from camera: $e');
      } else {
        print('Failed to take picture from gallery: $e');
      }
    } 
  }
  

  void _saveChangesValidation() {
    if (_isSaveChangesError || 
      (_firstNameController.text == _firstNameText &&
      _lastNameController.text == _lastNameText &&
      _usernameController.text == _usernameText)) { return; }

    setState(() {
      primaryFocus!.unfocus();

      if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty) {
        _firstNameController.text = _firstNameText;
        _lastNameController.text = _lastNameText;
        _usernameController.text = _usernameText;
        
        _isSaveChangesError = true;
        _saveChangesErrorText = 'Please fill the blanks';
      }

      if (!_isSaveChangesError) { 
        _firstNameText = _firstNameController.text;
        _lastNameText = _lastNameController.text;
        _usernameText = _usernameController.text;
      }
    });
  }

  void _changePasswordValidation() {
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

      if (!_isChangePasswordError) {
        _oldPasswordText = _newPasswordController.text;
      }

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    });
  }

}