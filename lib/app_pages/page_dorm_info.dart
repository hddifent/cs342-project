import 'package:cs342_project/constants.dart';
import 'package:cs342_project/models/dorm.dart';
import 'package:flutter/material.dart';

class DormInfoPage extends StatelessWidget {
  final Dorm dorm;

  const DormInfoPage({super.key, required this.dorm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        
          children: <Widget>[
            Text(dorm.dormName, style: AppTextStyle.title),
            Row(children: <Widget>[const Icon(Icons.location_pin), const SizedBox(width: 5), Text(dorm.location)]),
            Row(children: <Widget>[const Icon(Icons.mail), const SizedBox(width: 5), Text(dorm.contactInfo["email"])]),
            Row(children: <Widget>[const Icon(Icons.phone), const SizedBox(width: 5), Text(dorm.contactInfo["phoneNumber"])]),
                    
            const SizedBox(height: 10),
                    
            Text("Information", style: AppTextStyle.heading1.merge(AppTextStyle.bold)),
            Text(dorm.dormDescription, style: AppTextStyle.body),
                    
            const SizedBox(height: 10),
                    
            Text("Pricing", style: AppTextStyle.heading1.merge(AppTextStyle.bold)),
            Text("฿${dorm.monthlyPrice} / month", style: AppTextStyle.body)
          ]
        )
      )
    );
  }
}