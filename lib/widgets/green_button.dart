import 'package:cs342_project/constants.dart';
import 'package:flutter/material.dart';

Widget greenButton(String text, void Function()? function, {bool isDisabled = false, double width = 225, IconData? icon}) {
  return Center(
    child: ElevatedButton(
      onPressed: function, 
      style: ButtonStyle(
        backgroundColor: isDisabled ? const MaterialStatePropertyAll(AppPalette.lightGray) :
          const MaterialStatePropertyAll(AppPalette.green),
        elevation: const MaterialStatePropertyAll(10),
      ),
      child: Container(
        width: width,
        alignment: Alignment.center,
        child: icon == null ? _getText(text) : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Icon(icon, color: Colors.black), const SizedBox(width: 10), _getText(text)]
        )
      )
    )
  );
}

Text _getText(String text) {
  return Text(text,
    textAlign: TextAlign.center,
    style: AppTextStyle.heading1.merge(const TextStyle(color: Colors.black))
  );
}