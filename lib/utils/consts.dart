import 'package:flutter/material.dart';

//TextStyles
class TextStyles {
  static const TextStyle title = TextStyle(fontSize: 20);

  static const TextStyle title2 = TextStyle(fontSize: 18);

  static const TextStyle headings = TextStyle(fontSize: 16);

  static const TextStyle bodytext = TextStyle(fontSize: 14);

  static const TextStyle bodytext2 = TextStyle(fontSize: 12);
}

//device height and width
double deviceHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

double deviceWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}

SizedBox buildHeight(double height) => SizedBox(height: height);
SizedBox buildWidth(double width) => SizedBox(width: width);
