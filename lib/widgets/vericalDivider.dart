import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget verticalDivider(){
  return Container(
    width: 1,
    height: 68,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 0.1),
          Color.fromRGBO(255, 255, 255, 0.5),
          Color.fromRGBO(255, 255, 255, 0.1),
        ],
        stops: [0, 0.4663, 1],
      ),
    ),
  );
}