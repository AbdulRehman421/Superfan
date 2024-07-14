import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superfan/utils/styles.dart';

import '../utils/color.dart';

Widget customTextField({
  TextEditingController? controller,
  required String hintText,
  required Widget prefixIcon,
  required final ValueChanged<String> onChanged,
  TextStyle? hintStyle,
  TextInputType? keyboard,
  Color? borderColor,
  Color? containerColor,
  final List<TextInputFormatter>? inputFormatters,
  double? borderWidth,
  double? borderRadius,
  bool isCountry = false,
  bool enable = false,
  EdgeInsetsGeometry? contentPadding,
  final String? Function(String?)? validator,
}) {
  return Container(
    padding: EdgeInsets.only(top: 12 ,bottom: 6,),
    decoration: BoxDecoration(
      color: containerColor != null ? containerColor : Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: borderClr,
      ),
    ),
    child: TextFormField(
      enabled: enable ,
      inputFormatters: inputFormatters,
      validator: validator,
      keyboardType: keyboard,
      controller: controller,
      cursorColor: Colors.black,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 15.0,left: 16,bottom: 15,right: 12),
          child: prefixIcon,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
        suffixIcon: isCountry
            ? Icon(Icons.arrow_drop_down, color: Colors.black,size: 24,)
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.zero,
        ),
        contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      ),
    ),
  );
}
