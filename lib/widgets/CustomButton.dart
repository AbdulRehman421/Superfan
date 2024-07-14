
import 'package:flutter/material.dart';
import '../utils/color.dart';
import '../utils/styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 53),
          decoration: BoxDecoration(
            color: buttonBgClr,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: textStyle ?? Styles.buttonTextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
