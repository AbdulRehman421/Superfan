import 'package:flutter/material.dart';

import '../utils/color.dart';

Widget buildBackgroundStructure() {
  return Stack(
    alignment: Alignment.center,
    children: [
      // Outer circle with border
      Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: bgimgClr.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      // Inner filled circle
      Container(
        width: 115.62,
        height: 115.62,
        decoration: BoxDecoration(
          color: bgimgClr.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
      ),
      // Small filled circle on the second circle
      Positioned(
        left: 0,
        bottom: 40,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgimgClr2,
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: 55,
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: bgimgClr2,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  );
}