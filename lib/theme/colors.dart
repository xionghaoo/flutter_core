import 'package:flutter/material.dart';

//final colorDivider = Colors.grey[200];
//
//const colorDividerConst = Color(0xFFEEEEEE);

final colorInputHint = createMaterialColor(Color(0xFFA5A5A5));

final colorInputHintConst = Color(0xFFA5A5A5);

final colorMainTextConst = Color(0xFF242424);

final colorWeekText = createMaterialColor(Color(0xFF666666));

const colorWeekTextConst = Color(0xFF666666);

final colorSignPanel = createMaterialColor(Color(0xFFF7F7F8));

final colorSignPanelConst = Color(0xFFF7F7F8);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}