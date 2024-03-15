import '../constants.dart';
import 'package:flutter/material.dart';
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
          prefixIcon: const Icon(Icons.email), 
          prompt: 'Email',
          sizedBoxHeight: 10,
        ),
    
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
          sizedBoxHeight: 10,
        ),
    
        TextFieldWithIcon(
          controller: _passwordController, 
          prefixIcon: const Icon(Icons.lock), 
          prompt: 'Password',
          isObsecured: true,
          sizedBoxHeight: 10,
        ),
        
        TextFieldWithIcon(
          controller: _confirmPasswordController, 
          prefixIcon: const Icon(Icons.lock), 
          prompt: 'Confirm Password',
          isObsecured: true,
          sizedBoxHeight: 15,
        ),
    
        greenButton('Create User',
          //TODO: Add Logic And Create User Into Database (Firestore?)
          () => Navigator.pop(context)
        ),
          
        const SizedBox(height: 20),
    
        _alreadyHaveAnAccount()
      ],
    );
  }

  Widget _alreadyHaveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Already have an account?'),
        
        textButton('Log In', Alignment.centerRight, 40,
          () => Navigator.pop(context)
        ),

        const Text('.')
      ],
    );
  }

}