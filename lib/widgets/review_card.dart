import 'package:cs342_project/app_pages/page_review_info.dart';
import 'package:cs342_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/app_user.dart';
import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  
  final Review review;
  final AppUser appUser;

  const ReviewCard({super.key, required this.review, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewInfoPage(review: review))),

      child: SizedBox(
        height: 140,

        child: Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _infoOverall(),

                const SizedBox(height: 10),
            
                Text(review.review,
                  textAlign: TextAlign.left, 
                  style: AppTextStyle.body
                )
              ],
            ),
          ),
        )
      )
    );
  }

  Widget _infoOverall() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _reviewerInfo(),
        RatingBar.builder( 
            allowHalfRating: true,
            glow: false,
            tapOnlyMode: false,
            updateOnDrag: false,
            ignoreGestures: false,
            direction: Axis.horizontal,
            minRating: 1,
            maxRating: 5,
            initialRating: review.getOverallRating(),
            itemSize: 27.5,
            itemCount: 5,
            itemBuilder: (context, _) 
              => const Icon(Icons.star,
                color: AppPalette.gold
              ), 
            onRatingUpdate: (rating) {
              rating = review.getOverallRating();
            },
          )
      ],
    );
  }

  Widget _reviewerInfo() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          maxRadius: 15,
          backgroundImage: appUser.getProfileImage(),
        ),

        const SizedBox(width: 10),

        Text(appUser.username, 
          style: TextStyle(
            fontSize: AppTextStyle.heading2.fontSize,
            fontWeight: FontWeight.bold
          )
        ),
      ],
    );
  }

}