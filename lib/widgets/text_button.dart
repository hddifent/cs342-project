import 'package:cs342_project/constants.dart';
import 'package:flutter/material.dart';

Widget textButton(String text, Alignment alignment, 
  double width, void Function() function) {
  return Stack(
    alignment: alignment,
    children: <Widget>[
      Text(text,
        style: const TextStyle(
          color: AppPalette.green,
          decoration: TextDecoration.underline,
        )
      ),
      MaterialButton(
        onPressed: function,
        height: 20,
        minWidth: width,
      )
    ],
  );
}