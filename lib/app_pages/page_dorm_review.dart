import 'package:cs342_project/app_pages/page_write_review.dart';
import 'package:cs342_project/constants.dart';
import 'package:cs342_project/global.dart';
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
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
          
            children: <Widget>[
              // TODO: Check for user review...
              currentUser == null ? const SizedBox(height: 0) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Review",
                    style: AppTextStyle.heading1.merge(AppTextStyle.bold)
                  ),
                  greenButton("Write", _writeReview, width: 100, icon: Icons.edit)
                ]
              ),
          
              currentUser == null ? const SizedBox(height: 0) : const SizedBox(height: 10),
          
              Text("Reviews (???)", style: AppTextStyle.heading1.merge(AppTextStyle.bold))
          
              // TODO: Check for all reviews...
            ]
          ),
        )
      )
    );
  }

  void _writeReview() {
    Navigator.push(context, 
      MaterialPageRoute(
        builder: (context) 
          => WriteReviewPage(
            dormName: widget.dorm.dormName,
            dormID: widget.dorm.dormID,
          )
      )
    );
  }

}