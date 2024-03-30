import 'package:flutter/material.dart';

Widget loading(bool isLoading) {
  if (isLoading) { 
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      color: Colors.white,
      child: const CircularProgressIndicator()
    ); 
  }
  return Container();
}