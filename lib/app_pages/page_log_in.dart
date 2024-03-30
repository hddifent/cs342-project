import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/green_button.dart';
import '../widgets/loading.dart';
import '../widgets/text_button.dart';
import '../widgets/text_field_icon.dart';
import '../widgets/welcome_text.dart';
import '../database/firestore.dart';
import '../global.dart';
import '../constants.dart';
import '../models/app_user.dart';
import 'mask_main.dart';
import 'page_sign_up.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _loginErrorText = 'Log In';

  bool _isLogInError = false, _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _login()     
            )
          ),
          loading(_isLoading)
        ],
      )
    );
  }

  void _checkTextFieldChange() {
    setState(() {
      _isLogInError = false;
      _loginErrorText = 'Log In';
    });
  }

  Widget _login() {
    return Column(
      children: <Widget>[
        welcomeText(),
    
        const SizedBox(height: 25),
    
        const Center(
          child: Text("Log In",
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
          prefixIcon: const Icon(Icons.mail, size: 30,),
          onChanged: (text) =>
            _checkTextFieldChange(),
          prompt: 'Email',
          sizedBoxHeight: 10,
          isErrorLogic: _isLogInError,
        ),
    
        TextFieldWithIcon(
          controller: _passwordController, 
          prefixIcon: const Icon(Icons.lock, size: 30),
          isObsecured: true,
          onChanged: (text) => 
            _checkTextFieldChange(),
          prompt: 'Password',
          sizedBoxHeight: 15,
          isErrorLogic: _isLogInError,
        ),
    
        greenButton(_loginErrorText, _loginValidation,
          isDisabled: _isLogInError
        ),
    
        const SizedBox(height: 20),
    
        _dontHaveAnAccount()
      ],
    );
  }

  void _loginValidation() async {
    if (_isLogInError) { return; }
    
    String _email = _emailController.text;
    String _password = _passwordController.text;

    setState(() {
      primaryFocus?.unfocus();

      if (_email.isEmpty || _password.isEmpty) {
        _isLogInError = true;
        _loginErrorText = 'Please fill the blanks';
      }
    });

    String? uid = await login(_email, _password);
    setState(() {
      if (!_isLogInError && uid == null) {
        _isLogInError = true;
        _passwordController.clear();
        _loginErrorText = 'Wrong email/password';
      }
    });
    
    if (!_isLogInError) { 
      _pushPage(const MainMask(), uid!); 
    }
  }

  Future<String?>? login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      print(credential.user?.uid);
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  void _pushPage(Widget page, String? uid) async {
    if (uid != null) {
      setState(() => _isLoading = true);
      final FirestoreDatabase userDB = FirestoreDatabase('user');
      final userRef = userDB.getDocumentReference(uid);

      await userRef.get().then(
        (DocumentSnapshot doc) {
          final userData = doc.data() as Map<String, dynamic>;
          print(userData['email']);

          setState(() {
            currentUser = AppUser.fromJson(userData);
          });
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }

    setState(() {
      if (_isLogInError) { _isLogInError = false; }
      if (_loginErrorText != 'Log In') { _loginErrorText = 'Log In'; }
      if (_isLoading) { _isLoading = false; }

      _emailController.clear();
      _passwordController.clear();

      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => page)
      );
    });
  }

  Widget _dontHaveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Don\'t have an account?'),
        
        textButton('Sign Up', Alignment.center, 57.5,
          () => _pushPage(const SignUpPage(), null)
        ),

        const Text('or'),
        
        textButton('browse as guest', Alignment.centerRight, 110,
          //TODO: Add Logic For Guest
          () => _pushPage(const MainMask(), null)
        ),

        const Text('.'),
      ],
    );
  }

}