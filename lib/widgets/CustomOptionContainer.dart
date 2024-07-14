
import 'package:flutter/material.dart';
import 'package:superfan/utils/color.dart';
import 'package:superfan/utils/styles.dart';

class CustomOptionContainer extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const CustomOptionContainer({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  }) : super(key: key);

  @override
  _CustomOptionContainerState createState() => _CustomOptionContainerState();
}

class _CustomOptionContainerState extends State<CustomOptionContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isSelected ? null : widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected ? selectedClr : lightbgClr,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: Styles.navSelTextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: 0),
              ),
              if (widget.isSelected)
                Icon(
                  widget.isCorrect ? Icons.check : Icons.close,
                  color: widget.isCorrect ? Colors.green : Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
