import 'package:cs342_project/database/firestore.dart';
import 'package:cs342_project/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../constants.dart';
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

  bool _isSignUpError = false, _isEmailAlreadyExist = false, 
    _isWeakPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _signup()
        ),
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
      } else if (!EmailValidator.validate(email, true)) {
        _isSignUpError = true;
        _signUpErrorText = 'Wrong email format';
      } else if (password != confirm) {
        _isSignUpError = true;
        _signUpErrorText = 'Wrong confirmation';
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    });

    if (_isSignUpError) { return; }
    _isEmailAlreadyExist = false;
    _isSignUpError = false;
    final String? uid = await _signUpUser(email, password);
    setState(() {
      if (_isEmailAlreadyExist) {
        _isSignUpError = true;
        _signUpErrorText = 'Email already exists';
      } else if (_isWeakPassword) {
        _isSignUpError = true;
        _signUpErrorText = 'Weak password';
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    });

    if (!_isSignUpError) { _popPage(uid); }
  }

  Future<String?>? _signUpUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _isWeakPassword = true;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        _isEmailAlreadyExist = true;
      }
    } return null;
  }

  void _popPage(String? uid) async {
    if (uid != null) {
      final FirestoreDatabase userDB = FirestoreDatabase('users');
      await userDB.addDocument(
        uid,
        AppUser(
          email: _emailController.text, 
          firstName: _firstNameController.text, 
          lastName: _lastNameController.text, 
          username: _usernameController.text, 
          password: _passwordController.text, 
          profileImageURL: ''
        ).toFirestore()
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