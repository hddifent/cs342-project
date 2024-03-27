import 'package:flutter/material.dart';

class TextFieldWithIcon extends StatelessWidget {
  final TextEditingController controller;
  final Icon prefixIcon;
  final bool? isObsecured;
  final Function(String)? onChanged;
  final String prompt;
  final Color? promptColor;
  final double? sizedBoxHeight;

  const TextFieldWithIcon({super.key, 
    required this.controller, 
    required this.prefixIcon,
    this.isObsecured = false, 
    this.onChanged,
    required this.prompt,
    this.promptColor = Colors.black,
    this.sizedBoxHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                elevation: MaterialStatePropertyAll(10),
              ),
              child: SizedBox(height: 60, width: 500)
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: Container(
                height: 60,
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: onChanged,
                  controller: controller,
                  obscureText: isObsecured!,
                  decoration: InputDecoration(
                    prefixIcon: prefixIcon,
                    hintText: prompt,
                    hintStyle: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w400,
                      color: promptColor,
                    ),
                    fillColor: Colors.white,
                    border: InputBorder.none
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: sizedBoxHeight),
      ],
    );
  }
}