import 'package:cs342_project/database/firebase_auth.dart';
import 'package:cs342_project/models/app_user.dart';
import 'package:cs342_project/utils/string_extension.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/loading.dart';
import '../widgets/text_field_icon.dart';
import '../widgets/green_button.dart';
import '../widgets/welcome_text.dart';
import '../widgets/text_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _signUpErrorText = 'Create User';

  bool _isSignUpError = false, _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _signup()
            ),
          ),
          loading(_isLoading)
        ],
      ),
    );
  }

  void _checkTextFieldChange() {
    setState(() {
      _isSignUpError = false;
      _signUpErrorText = 'Create User';
    });
  }

  Widget _signup() {
    return Column(
      children: <Widget>[
        welcomeText(),
    
        const SizedBox(height: 25),
    
        const Center(
          child: Text('Sign Up',
            style: TextStyle(
              color: AppPalette.darkGreen,
              fontSize: 32,
              fontWeight: FontWeight.w900
            ),
          ),
        ),
    
        const SizedBox(height: 20),
    
        TextFieldWithIcon(
          controller: _emailController, 
          prefixIcon: const Icon(Icons.email, size: 30),
          textInputType: TextInputType.emailAddress, 
          onChanged: (text) => 
            _checkTextFieldChange(),
          prompt: 'Email',
          sizedBoxHeight: 10,
          isErrorLogic: _isSignUpError,
        ),
    
        TextFieldWithIcon(
          controller: _firstNameController, 
          prefixIcon: const Icon(Icons.edit, size: 30), 
          onChanged: (text) =>
            _checkTextFieldChange(),
          prompt: 'First Name',
          sizedBoxHeight: 10,
          isErrorLogic: _isSignUpError,
        ),
    
        TextFieldWithIcon(
          controller: _lastNameController, 
          prefixIcon: const Icon(Icons.edit, size: 30), 
          onChanged: (text) =>
            _checkTextFieldChange(),
          prompt: 'Last Name',
          sizedBoxHeight: 10,
          isErrorLogic: _isSignUpError,
        ),
    
        TextFieldWithIcon(
          controller: _usernameController, 
          prefixIcon: const Icon(Icons.person, size: 30),
          onChanged: (text) =>
            _checkTextFieldChange(), 
          prompt: 'Username',
          sizedBoxHeight: 10,
          isErrorLogic: _isSignUpError,
        ),
    
        TextFieldWithIcon(
          controller: _passwordController, 
          prefixIcon: const Icon(Icons.lock, size: 30), 
          isObsecured: true,
          onChanged: (text) =>
            _checkTextFieldChange(),
          prompt: 'Password',
          sizedBoxHeight: 10,
          isErrorLogic: _isSignUpError,
        ),
        
        TextFieldWithIcon(
          controller: _confirmPasswordController, 
          prefixIcon: const Icon(Icons.lock, size: 30), 
          isObsecured: true,
          onChanged: (text) =>
            _checkTextFieldChange(),
          prompt: 'Confirm Password',
          sizedBoxHeight: 15,
          isErrorLogic: _isSignUpError,
        ),
    
        greenButton(_signUpErrorText,
          _signUpValidation,
          isDisabled: _isSignUpError
        ),
          
        const SizedBox(height: 20),
    
        _alreadyHaveAnAccount()
      ],
    );
  }

  void _signUpValidation() async {
    if (_isSignUpError) { return; }

    String email = _emailController.text,
      firstName = _firstNameController.text,
      lastName = _lastNameController.text,
      username = _usernameController.text,
      password = _passwordController.text,
      confirm = _confirmPasswordController.text;

    setState(() {
      primaryFocus?.unfocus();

      if (email.isEmpty || firstName.isEmpty ||
        lastName.isEmpty || username.isEmpty || 
        password.isEmpty || confirm.isEmpty) {
        _isSignUpError = true;
        _signUpErrorText = 'Please fill the blanks';
      } else if (password != confirm) {
        _isSignUpError = true;
        _signUpErrorText = 'Wrong confirmation';
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    });

    if (_isSignUpError) { return; }
    final String? uid = await AuthenticationDatabase.signUpUser(email, password);
    setState(() {
      if (uid == 'invalid-email') {
        _isSignUpError = true;
        _signUpErrorText = 'Invalid email';
      } else if (uid == 'email-already-in-use') {
        _isSignUpError = true;
        _signUpErrorText = 'Email already exists';
        _emailController.clear();
      } else if (uid == 'weak-password') {
        _isSignUpError = true;
        //FIXME
        _signUpErrorText = 'Password should be \nat least 6 letters';
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    });

    if (!_isSignUpError) { _popPage(uid); }
  }

  void _popPage(String? uid) async {
    if (uid != null) {
      setState(() => _isLoading = true);
      await AuthenticationDatabase.signingUp(
        AppUser(
          uid,
          email: _emailController.text, 
          firstName: _firstNameController.text.capitalize(), 
          lastName: _lastNameController.text.capitalize(), 
          username: _usernameController.text.toLowerCase(),
        )
      );
    }

    setState(() {
      _emailController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      Navigator.pop(context);
    });
  }

  Widget _alreadyHaveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Already have an account?'),
        
        textButton('Log In', Alignment.centerRight, 40,
          () => _popPage(null)
        ),

        const Text('.')
      ],
    );
  }

}