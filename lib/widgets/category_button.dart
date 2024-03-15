import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryButton extends StatelessWidget {
  final String category;
  final Color backgroundColor;

  const CategoryButton({super.key, 
    required this.category,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 30,
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
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}