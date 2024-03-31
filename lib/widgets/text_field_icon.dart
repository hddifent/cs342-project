import 'package:flutter/material.dart';
import '../constants.dart';

class TextFieldWithIcon extends StatelessWidget {
  final TextEditingController controller;
  final Icon prefixIcon;
  final bool? isObsecured;
  final TextInputType? textInputType;
  final Function(String)? onChanged;
  final String prompt;
  final double? sizedBoxHeight;
  final bool? isErrorLogic;
  final bool? isSuccessLogic;

  const TextFieldWithIcon({super.key, 
    required this.controller, 
    required this.prefixIcon,
    this.isObsecured = false,
    this.textInputType =  TextInputType.text,
    this.onChanged,
    required this.prompt,
    this.sizedBoxHeight = 0,
    this.isErrorLogic = false,
    this.isSuccessLogic = false
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
                  keyboardType: textInputType,
                  style: _textStyle(),
                  decoration: InputDecoration(
                    prefixIcon: prefixIcon,
                    prefixIconColor: _colorLogic(),
                    hintText: prompt,
                    hintStyle: _textStyle(),
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

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: 20, 
      fontWeight: FontWeight.w400,
      color: _colorLogic(),
    );
  }

  Color? _colorLogic() {
    return isErrorLogic! ? 
      AppPalette.red : 
      isSuccessLogic! ? AppPalette.darkGreen : null;
  }
}