import 'package:flutter/material.dart';
//COLOR THEME SRC: https://medium.com/@morgenroth/using-flutters-primary-swatch-with-a-custom-materialcolor-c5e0f18b95b0
import 'dart:math';

final ThemeData theme = ThemeData(
  primaryColorDark: Colors.black,
  primaryColor: Colors.white,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: AemnTheme.generateMaterialColor(Color(0xffffffff)), //PrimaryColor
);


class AemnTheme{
  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) =>
      Color.fromRGBO(
          tintValue(color.red, factor),
          tintValue(color.green, factor),
          tintValue(color.blue, factor),
          1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) =>
      Color.fromRGBO(
          shadeValue(color.red, factor),
          shadeValue(color.green, factor),
          shadeValue(color.blue, factor),
          1);
}