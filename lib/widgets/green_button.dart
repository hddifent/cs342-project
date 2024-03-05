import 'package:cs342_project/constants.dart';
import 'package:flutter/material.dart';

Widget greenButton(String text, void Function() function) {
  return Center(
    child: ElevatedButton(
      onPressed: function, 
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(AppPalette.green),
        elevation: MaterialStatePropertyAll(10),
      ),
      child: Container(
        width: 225,
        alignment: Alignment.center,
        child: Text(text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400
          )
        ),
      )
    ),
  );
}