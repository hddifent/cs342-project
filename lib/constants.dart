import 'package:flutter/material.dart';

const String lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class AppPalette {
  static const Color green = Color(0xFF33E35A);
  static const Color darkGreen = Color(0xFF2E8C42);
  static const Color red = Color(0xFFB43A32);
  static const Color gold = Color(0xFFD6961A);
  static const Color lightGray = Color(0xFFDDDDDD);
}

class AppTextStyle {
  /// 32px Bold
  static const TextStyle title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 32
  );

  /// 20px Regular
  static const TextStyle heading1 = TextStyle(
    fontSize: 20
  );

  /// 16px Regular
  static const TextStyle heading2 = TextStyle(
    fontSize: 16
  );

  /// 12px Regular
  static const TextStyle body = TextStyle(
    fontSize: 12
  );

  /// Shorthand for bold TextStyle
  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold
  );
}
