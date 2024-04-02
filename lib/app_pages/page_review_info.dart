import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';
import '../models/app_user.dart';
import '../models/review.dart';

class ReviewInfoPage extends StatelessWidget {
  final Review review;
  final AppUser appUser;

  const ReviewInfoPage({super.key, required this.review, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${appUser.username} wrote'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: <Widget>[
            _overallInfo(),

            _categoryRatingBar('Price', review.priceRating),
            _categoryRatingBar('Hygiene', review.hygieneRating),
            _categoryRatingBar('Service', review.serviceRating),
            _categoryRatingBar('Travel', review.travelingRating),

            const SizedBox(height: 10),

            Text(review.review,
              textAlign: TextAlign.left, 
              style: AppTextStyle.heading1
            )
          ],
        ),
      ),
    );
  }

  Widget _overallInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircleAvatar(
            maxRadius: 50,
            backgroundImage: appUser.getProfileImage(),
          ),
          RatingBar.builder( 
            allowHalfRating: true,
            ignoreGestures: true,
            glow: false,
            tapOnlyMode: true,
            updateOnDrag: false,
            direction: Axis.horizontal,
            minRating: 1,
            maxRating: 5,
            initialRating: review.getOverallRating(),
            itemSize: 50,
            itemCount: 5,
            itemBuilder: (context, _) 
              => const Icon(Icons.star_rounded,
                color: AppPalette.gold
              ), 
            onRatingUpdate: (rating) {
              rating = review.getOverallRating();
            },
          )
        ],
      ),
    );
  }

  Widget _categoryRatingBar(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, 
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          RatingBar.builder( 
            allowHalfRating: true,
            ignoreGestures: true,
            glow: false,
            tapOnlyMode: true,
            updateOnDrag: false,
            direction: Axis.horizontal,
            minRating: 1,
            maxRating: 5,
            initialRating: rating.toDouble(),
            itemSize: 27.5,
            itemCount: 5,
            itemBuilder: (context, _) 
              => const Icon(Icons.star_rounded,
                color: AppPalette.gold,
              ), 
            onRatingUpdate: (rating) {
              rating = review.getOverallRating();
            },
          )
        ],
      ),
    );
  }



}