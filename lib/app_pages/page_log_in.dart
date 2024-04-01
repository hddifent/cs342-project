import 'package:cs342_project/database/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/green_button.dart';
import '../widgets/loading.dart';
import '../widgets/text_button.dart';
import '../widgets/text_field_icon.dart';
import '../widgets/welcome_text.dart';
import '../constants.dart';
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
          textInputType: TextInputType.emailAddress,
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
    
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      primaryFocus?.unfocus();

      if (email.isEmpty || password.isEmpty) {
        _isLogInError = true;
        _loginErrorText = 'Please fill the blanks';
      }
    });

    if (_isLogInError) { return; }
    final User? user = await AuthenticationDatabase.loginUser(email, password);
    setState(() {
      if (user == null) {
        _isLogInError = true;
        _passwordController.clear();
        _loginErrorText = 'Wrong email/password';
      }
    });
    
    if (!_isLogInError) { 
      _pushPage(const MainMask(), user); 
    }
  }

  void _pushPage(Widget page, User? user) async {
    primaryFocus!.unfocus();

    if (user != null) {
      setState(() => _isLoading = true);
      await AuthenticationDatabase.loggingIn(user);
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
          () => _pushPage(const MainMask(), null)
        ),

        const Text('.'),
      ],
    );
  }

}