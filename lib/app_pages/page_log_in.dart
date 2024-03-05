import 'package:cs342_project/app_pages/mask_main.dart';
import 'package:cs342_project/constants.dart';
import 'package:flutter/material.dart';
import '../widgets/text_field_icon.dart';
import '../widgets/green_button.dart';
import '../widgets/text_button.dart';
import '../widgets/welcome_text.dart';
import 'page_sign_up.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _login()
      )
    );
  }

  Widget _login() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        welcomeText(),
    
        const SizedBox(height: 25),
    
        const Center(
          child: Text('Log In',
            style: TextStyle(
              color: AppPalette.darkGreen,
              fontSize: 32,
              fontWeight: FontWeight.w900
            ),
          ),
        ),
    
        const SizedBox(height: 20),
    
        TextFieldWithIcon(
          controller: _userController, 
          prefixIcon: const Icon(Icons.person, size: 30,),
          prompt: 'Username',
          sizedBoxHeight: 10,
        ),
    
        TextFieldWithIcon(
          controller: _passwordController, 
          isObsecured: true,
          prefixIcon: const Icon(Icons.lock, size: 30,),
          prompt: 'Password',
          sizedBoxHeight: 15,
        ),
    
        greenButton('Log In',
          //TODO: Add Validation Logic
          () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const MainMask())
          )
        ),
    
        const SizedBox(height: 20),
    
        _dontHaveAnAccount()
      ],
    );
  }

  Widget _dontHaveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Don\'t have an account?'),
        
        textButton('Sign Up', Alignment.center, 57.5,
          () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const SignUpPage())
          )
        ),

        const Text('or'),
        
        textButton('browse as guest', Alignment.centerRight, 110,
          //TODO: Add Logic For Guest
          () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const MainMask())
          )
        ),

        const Text('.'),
      ],
    );
  }

}