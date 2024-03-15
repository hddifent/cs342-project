import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryButton extends StatelessWidget {
  final String category;
  final Color backgroundColor;
  final Color textColor;

  const CategoryButton({super.key, 
    required this.category,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black,
            spreadRadius: 1,
            blurStyle: BlurStyle.inner,
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Center(
        child: Text(
          category,
          style: TextStyle(
            fontSize: 18,
            color: textColor
          ),
        ),
      ),
    );
  }
}