import "package:cs342_project/app_pages/mask_dorm_info.dart";
import "package:cs342_project/app_pages/page_review_info.dart";
import "package:cs342_project/constants.dart";
import "package:cs342_project/models/dorm.dart";
import "package:cs342_project/models/review.dart";
import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";

import "../models/app_user.dart";

class DormCard extends StatelessWidget {
  static const double _roundRadius = 10;
  static const double pictureRatio = 100.00/120.00;

  final Dorm dorm;
  final bool isReview;
  final Review? review;
  final AppUser? appUser;

  const DormCard({
    super.key, required this.dorm, this.isReview = false, this.review, this.appUser
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isReview ? Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewInfoPage(review: review!, appUser: appUser!))) :
        Navigator.push(context, MaterialPageRoute(builder: (context) => DormInfoMask(dorm: dorm))),

      child: SizedBox(
        height: 140,

        child: Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(_roundRadius))),
        
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
        
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(_roundRadius), bottomLeft: Radius.circular(_roundRadius)),
                child: AspectRatio(
                  aspectRatio: pictureRatio,
                  child: dorm.imagePath.isNotEmpty ? Image.network(dorm.imagePath[0], fit: BoxFit.cover)
                                                   : Image.asset("assets/dorm_placeholder.png", fit: BoxFit.cover)
                )
              ),
        
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                        
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dorm.dormName,
                        style: AppTextStyle.heading1.merge(AppTextStyle.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: isReview ? 
                        // Specify
                        <Widget>[
                          _userRatingDisplay()
                        ]
                        // Overview
                        : <Widget>[
                          _ratingDisplay(),
                          Text("฿${dorm.monthlyPrice} / mth.", style: AppTextStyle.heading2)
                        ]
                      ),

                      Expanded(
                        child: Text(
                          isReview ? review!.review : dorm.dormDescription,
                          style: AppTextStyle.body,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3
                        )
                      )
                    ]
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  Widget _ratingDisplay() {
    return Row(
      children: <Widget>[
        Text(dorm.rating.toStringAsFixed(1), style: AppTextStyle.heading2),
        const Icon(Icons.star_rounded, color: AppPalette.gold)
      ]
    );
  }

  Widget _userRatingDisplay() {
    return RatingBar.builder( 
      allowHalfRating: true,
      ignoreGestures: true,
      glow: false,
      tapOnlyMode: true,
      updateOnDrag: false,
      direction: Axis.horizontal,
      minRating: 1,
      maxRating: 5,
      initialRating: review!.getOverallRating(),
      itemSize: 24,
      itemCount: 5,
      itemBuilder: (context, _)
        => const Icon(Icons.star_rounded, color: AppPalette.gold), 
      onRatingUpdate: (rating) {
        rating = review!.getOverallRating();
      }
    );
  }
}