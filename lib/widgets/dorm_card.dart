import "package:cs342_project/app_pages/mask_dorm_info.dart";
import "package:cs342_project/constants.dart";
import "package:cs342_project/models/dorm.dart";
import "package:flutter/material.dart";

// TODO: This is a placeholder. Don't forget to adjust this widget later.
class DormCard extends StatelessWidget {
  static const double _roundRadius = 10;
  static const double pictureRatio = 100.00/120.00;

  final Dorm dorm;
  final bool isSpecify;

  const DormCard({super.key, required this.dorm, this.isSpecify = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DormInfoMask(dorm: dorm))),

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
                      Text(dorm.dormName, style: AppTextStyle.heading1.merge(AppTextStyle.bold)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: isSpecify ? 
                        // Specify
                        <Widget>[
                          _ratingDisplay(isSpecify),
                          _helpfulDisplay()
                        ]
                        // Overview
                        : <Widget>[
                          _ratingDisplay(isSpecify),
                          Text("฿${dorm.monthlyPrice} / mth.", style: AppTextStyle.heading2)
                        ]
                      ),

                      Expanded(
                        child: Text(
                          dorm.dormDescription,
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

  Widget _ratingDisplay(bool isSpecify) {
    // TODO: Actually display the rating.
    List<Icon> starIcon = [];
    for (int i = 0; i < (4.8).ceil(); i++) {
      starIcon.add(
        const Icon(
          Icons.star_rounded, 
          color: AppPalette.gold,
        )
      );
    } 
    if (isSpecify) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: starIcon
      );
    }
    return FutureBuilder(
      future: dorm.getRating(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: <Widget>[
              Text(snapshot.data!.toStringAsFixed(1), style: AppTextStyle.heading2),
              const Icon(Icons.star_rounded, color: AppPalette.gold)
            ]
          );
        }
        else {
          return const Row(
            children: <Widget>[
              Text("???", style: AppTextStyle.heading2),
              Icon(Icons.star_rounded, color: AppPalette.gold)
            ]
          );
        }
      },
    );
  }

  Widget _helpfulDisplay() {
    // TODO: Actually display the helpful.
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('91.2% ', style: AppTextStyle.heading2),
        Text('(498) ', style: AppTextStyle.heading2),
        Icon(Icons.thumb_up, color: AppPalette.darkGreen)
      ]
    );
  }
}