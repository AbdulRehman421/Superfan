import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart'; // Assuming color.dart contains your color definitions

class Styles {
  // Default text styles
  static final TextStyle _defaultTitleTextStyle = GoogleFonts.rubik(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 1.5, // Line height: 36 / 24 = 1.5
    color: titleClr,
  );

  static final TextStyle _defaultSubtitleTextStyle = GoogleFonts.rubik(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 1.4, // Line height: 14 / 10 = 1.4
    color: subTxtClr,
  );

  static TextStyle navSelTextStyle({
    double fontSize = 12,
    double height = 16/12,
    Color color = navSelTextClr,
    double letterSpacing = 0.4,
    FontWeight fontWeight = FontWeight.w500,
}) {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            height: height,
            letterSpacing: letterSpacing,
            color: color));
  }

  static final TextStyle navUnSelTextStyle = GoogleFonts.roboto(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 16 / 12,
          letterSpacing: 0.4,
          color: navUnSelTextClr));

  // Methods to get text styles with customizable values
  static TextStyle titleTextStyle({
    double fontSize = 24,
    double height = 1.5,
    Color color = titleClr,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return _defaultTitleTextStyle.copyWith(
      fontSize: fontSize,
      height: height,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle subtitleTextStyle({
    double fontSize = 10,
    double height = 1.4,
    Color color = subTxtClr,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return _defaultSubtitleTextStyle.copyWith(
      fontSize: fontSize,
      height: height,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle buttonTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    double height = 16 / 14,
    Color color = Colors.black,
  }) {
    return GoogleFonts.roboto(
      textStyle: TextStyle(
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  static heading1(
      {double fontSize = 32,
      double height = 48 / 32,
      Color color = Colors.white,
      FontWeight fontWeight = FontWeight.w700}) {
    return titleTextStyle(
        fontSize: fontSize,
        color: color,
        height: height,
        fontWeight: fontWeight);
  }

  static poppinsTitle({double fontSize = 20,
    double height = 24/20,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w600,
  double letterSpacing= 0.2}){
    return GoogleFonts.poppins(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height
    );
  }

  static poppinsSubTxtStyle({
    fontSize= 14.0,
    fontWeight= FontWeight.w600,
    height= 16.8/14,
    color= blackClr,
}){
    return poppinsTitle(fontSize: fontSize,fontWeight: fontWeight,height: height,color: color);
  }
}

