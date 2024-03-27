import 'package:cs342_project/constants.dart';
import 'package:flutter/material.dart';

Widget greenButton(String text, void Function()? function, {bool isDisabled = false}) {
  return Center(
    child: ElevatedButton(
      onPressed: function, 
      style: ButtonStyle(
        backgroundColor: isDisabled ? const MaterialStatePropertyAll(AppPalette.lightGray) :
          const MaterialStatePropertyAll(AppPalette.green),
        elevation: const MaterialStatePropertyAll(10),
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