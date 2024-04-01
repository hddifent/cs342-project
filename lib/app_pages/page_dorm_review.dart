import 'package:cs342_project/constants.dart';
import 'package:cs342_project/models/dorm.dart';
import 'package:cs342_project/widgets/green_button.dart';
import 'package:flutter/material.dart';

class DormReviewPage extends StatefulWidget {
  final Dorm dorm;

  const DormReviewPage({super.key, required this.dorm});

  @override
  State<DormReviewPage> createState() => _DormReviewPageState();
}

class _DormReviewPageState extends State<DormReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            // TODO: Check for user review...
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Your Review", style: AppTextStyle.heading1.merge(AppTextStyle.bold)), greenButton("Write", () { }, width: 100, icon: Icons.edit)]
            ),

            const SizedBox(height: 10),

            Text("Reviews (???)", style: AppTextStyle.heading1.merge(AppTextStyle.bold))

            // TODO: Check for all reviews...
          ]
        )
      )
    );
  }
}