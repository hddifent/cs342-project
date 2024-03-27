import 'package:flutter/material.dart';
import '../widgets/text_field_icon.dart';
import '../widgets/green_button.dart';
import '../widgets/text_button.dart';
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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _usernameText = '', _passwordText = '';

  String _loginErrorText = 'Log In';

  bool _isLogInError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _login()
        )
      )
    );
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
          controller: _usernameController, 
          prefixIcon: Icon(Icons.person, 
            size: 30, 
            color: _isLogInError ? AppPalette.red : Colors.black,
          ),
          onChanged: (text) {
            setState(() {
              if (_usernameController.text != _usernameText) {
                _isLogInError = false;
                _usernameText = _usernameController.text;
                _loginErrorText = 'Log In';
              }
              print(_usernameText);
            });
          },
          prompt: 'Username',
          promptColor: _isLogInError ? 
            AppPalette.red : null,
          sizedBoxHeight: 10,
        ),
    
        TextFieldWithIcon(
          controller: _passwordController, 
          prefixIcon: Icon(Icons.lock, 
            size: 30,
            color: _isLogInError ? AppPalette.red : Colors.black,
          ),
          isObsecured: true,
          onChanged: (text) {
            setState(() {
              if (_passwordController.text != _passwordText) {
                _isLogInError = false;
                _passwordText = _passwordController.text;
                _loginErrorText = 'Log In';
              }
              print(_passwordText);
            });
          },
          prompt: 'Password',
          promptColor: _isLogInError ? 
            AppPalette.red : null,
          sizedBoxHeight: 15,
        ),
    
        greenButton(_loginErrorText, _loginValidation,
          isDisabled: _isLogInError
        ),
    
        const SizedBox(height: 20),
    
        _dontHaveAnAccount()
      ],
    );
  }

  void _loginValidation() {
    setState(() {
      if (_usernameController.text.isEmpty || 
        _passwordController.text.isEmpty) {
        _isLogInError = true;
        _loginErrorText = 'Please fill the blank';
      }
    });
    
    if (!_isLogInError) { _pushPage(const MainMask()); }
  }

  void _pushPage(Widget page) {
    setState(() {
      if (_isLogInError) { _isLogInError = false; }
      if (_loginErrorText != 'Log In') { _loginErrorText = 'Log In'; }

      _usernameController.clear();
      _passwordController.clear();

      _usernameText = '';
      _passwordText = '';

      primaryFocus?.unfocus();
    });
    
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => page)
    );
  }

  Widget _dontHaveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Don\'t have an account?'),
        
        textButton('Sign Up', Alignment.center, 57.5,
          () => _pushPage(const SignUpPage())
        ),

        const Text('or'),
        
        textButton('browse as guest', Alignment.centerRight, 110,
          //TODO: Add Logic For Guest
          () => _pushPage(const MainMask())
        ),

        const Text('.'),
      ],
    );
  }

}