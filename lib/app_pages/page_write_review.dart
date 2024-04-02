import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs342_project/app_pages/mask_dorm_info.dart';
import 'package:cs342_project/constants.dart';
import 'package:cs342_project/database/firestore.dart';
import 'package:cs342_project/global.dart';
import 'package:cs342_project/models/review.dart';
import 'package:cs342_project/widgets/green_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/dorm.dart';

class WriteReviewPage extends StatefulWidget {
  final Dorm dorm;
  final bool isEdit;
  final Review? review;
  final String? reviewID;

  const WriteReviewPage({super.key, required this.dorm, this.isEdit = false, this.review, this.reviewID});

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final FirestoreDatabase _reviewDB = FirestoreDatabase('reviews');
  final FirestoreDatabase _userDB = FirestoreDatabase('users');
  final FirestoreDatabase _dormDB = FirestoreDatabase('dorms');
  
  final _reviewController = TextEditingController();

  int _priceRating = 0, _hygieneRating = 0,
    _serviceRating = 0, _travelingRating = 0;

  String _postErrorText = 'Post';

  bool _isPostError = false;

  void _onPostChange() {
    _isPostError = false;
    _postErrorText = 'Post';
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      Review r = widget.review!;
      _priceRating = r.priceRating;
      _hygieneRating = r.hygieneRating;
      _serviceRating = r.serviceRating;
      _travelingRating = r.serviceRating;
      _reviewController.text = r.review;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write a review"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) 
                    => DormInfoMask(dorm: widget.dorm, initialIndex: 1)
                )
              );
            }, 
            icon: const Icon(Icons.arrow_back)
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: <Widget>[
            Text('You are writing a review for ${widget.dorm.dormName}',
              style: const TextStyle(
                fontSize: 25, 
                fontWeight: FontWeight.bold
              ),
            ),
            
            const SizedBox(height: 10),
            
            _ratingBar('Price', _priceRating),
            _ratingBar('Hygiene', _hygieneRating),
            _ratingBar('Service', _serviceRating),
            _ratingBar('Traveling', _travelingRating),

            const SizedBox(height: 10),

            _review(),

            const SizedBox(height: 10),

            greenButton(_postErrorText, _postValidation,
              isDisabled: _isPostError
            )
          ],
        ),
      ),
    );
  }

  Widget _ratingBar(String label, int labelRating) {
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
            glow: false,
            allowHalfRating: false,
            updateOnDrag: true,
            direction: Axis.horizontal,
            initialRating: labelRating.toDouble(),
            minRating: 1,
            maxRating: 5,
            itemSize: 27.5,
            itemCount: 5,
            itemBuilder: (context, _) 
              => const Icon(Icons.star_rounded,
                color: AppPalette.gold
              ), 
            onRatingUpdate: (rating) {
              _onPostChange();
              setState(() {
                switch (label) {
                  case 'Price' : 
                    _priceRating = rating.toInt();
                    break;
                  case 'Hygiene' : 
                      _hygieneRating = rating.toInt();
                    break;
                  case 'Service' : 
                      _serviceRating = rating.toInt();
                    break;
                  case 'Traveling' : 
                    _travelingRating = rating.toInt();
                    break;
                }
              });
            },
          )
        ],
      ),
    );
  }

  Widget _review() {
    return SizedBox(
      height: 160,
      child: TextField(
        controller: _reviewController,
        keyboardType: TextInputType.text,
        textAlignVertical: TextAlignVertical.top,
        onChanged: (value) => _onPostChange,
        expands: true,
        maxLines: null,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          hintText: 'Write your review here...',
          hintStyle: TextStyle(fontSize: 15)
        ),
      ),
    );
  }

  void _postValidation() async {
    if (_isPostError) { return; }

    setState(() {
      primaryFocus!.unfocus();

      if (_priceRating == 0 || _hygieneRating == 0 ||
        _serviceRating == 0 || _travelingRating == 0) {
        _isPostError = true;
        _postErrorText = 'Rate all category';
      } else if (_reviewController.text.isEmpty) {
        _isPostError = true;
        _postErrorText = 'Write some review';
      }
    });

    if (!_isPostError) {
      Review newReview = Review(
        userID: _userDB.getDocumentReference(currentUser!.uid), 
        dormID: _dormDB.getDocumentReference(widget.dorm.dormID), 
        priceRating: _priceRating, 
        hygieneRating: _hygieneRating, 
        serviceRating: _serviceRating, 
        travelingRating: _travelingRating, 
        review: _reviewController.text,
        postTimestamp: Timestamp.now()
      );

      if (widget.isEdit) {
        await _reviewDB.updateDocument(widget.reviewID!, newReview.toFirestore());
      } else {
        await _reviewDB.addDocument(null, newReview.toFirestore());
      }

      setState(() {
        _reviewController.clear();
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => DormInfoMask(dorm: widget.dorm, initialIndex: 1))
        );
      });      
    }
  }
}