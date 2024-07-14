
import 'package:flutter/cupertino.dart';

import '../utils/color.dart';

class AppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = primaryClr;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.lineTo(8, size.height);
    final firstStratPoint = Offset(8, size.height-30);
    final firstEndPoint = Offset(30, size.height-30);
    path.quadraticBezierTo(firstStratPoint.dx, firstStratPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width*0.35, size.height-30);
    //2nd curve
    final secondStartPoint = Offset(size.width*0.4, size.height-30);
    final secondEndPoint = Offset(size.width*0.45, size.height-45);
    path.quadraticBezierTo(secondStartPoint.dx, secondStartPoint.dy, secondEndPoint.dx, secondEndPoint.dy);


    //3rd curve
    final thirdStartPoint = Offset(size.width*0.475, size.height-50);
    final thirdEndPoint = Offset(size.width*0.5, size.height-50);
    path.quadraticBezierTo(thirdStartPoint.dx, thirdStartPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);

    //4th curve
    final fourStartPoint = Offset(size.width*0.525, size.height-50);
    final fourEndPoint = Offset(size.width*0.55, size.height-45);
    path.quadraticBezierTo(fourStartPoint.dx, fourStartPoint.dy, fourEndPoint.dx, fourEndPoint.dy);

    final fiveStartPoint = Offset(size.width*0.6, size.height-30);
    final fiveEndPoint = Offset(size.width*0.7, size.height-30);
    path.quadraticBezierTo(fiveStartPoint.dx, fiveStartPoint.dy, fiveEndPoint.dx, fiveEndPoint.dy);

    path.lineTo(size.width-30, size.height-30);

    // final sixStartPoint = Offset(size.width*0.7, size.height-30);
    // final sizEndPoint = Offset(size.width-22, size.height-30);
    // path.quadraticBezierTo(sixStartPoint.dx, sixStartPoint.dy, sizEndPoint.dx, sizEndPoint.dy);

    final sevenStartPoint = Offset(size.width-8, size.height-30);
    final sevenEndPoint = Offset(size.width-8, size.height);
    path.quadraticBezierTo(sevenStartPoint.dx, sevenStartPoint.dy, sevenEndPoint.dx, sevenEndPoint.dy);

    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
