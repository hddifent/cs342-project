import 'package:flutter/material.dart';

Widget welcomeText() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Welcome To ',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Text('KU DORM',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      )
    ],
  );
}