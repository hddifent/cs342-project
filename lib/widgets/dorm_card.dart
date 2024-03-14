import "package:cs342_project/constants.dart";
import "package:cs342_project/models/dorm.dart";
import "package:flutter/material.dart";

// TODO: This is a placeholder. Don't forget to adjust this widget later.
class DormCard extends StatelessWidget {
  static const double _roundRadius = 10;
  static const double pictureRatio = 100.00/120.00;

  final Dorm? dorm;

  const DormCard({super.key, this.dorm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},

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
                  child: Image.asset("assets/dorm_placeholder.jpg", fit: BoxFit.cover)
                )
              ),
        
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                        
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(dorm?.dormName ?? "[Dorm Name]", style: AppTextStyle.heading1.merge(AppTextStyle.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _ratingDisplay(),
                          const Text("฿25,300 / mth.", style: AppTextStyle.heading2)
                        ]
                      ),
                      Expanded(
                        child: Text(
                          dorm?.dormDescription ?? lorem,
                          style: AppTextStyle.body,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
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
    return const Row(
      children: <Widget>[
        // TODO: Actually display the rating.
        Text("4.8", style: AppTextStyle.heading2),
        Icon(Icons.star_rounded, color: AppPalette.gold)
      ]
    );
  }
}