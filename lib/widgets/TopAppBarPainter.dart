import 'package:flutter/cupertino.dart';

import '../utils/color.dart';

class TopAppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = bgColor;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 60);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 60);
    path.quadraticBezierTo(size.width, 30, size.width-30, 30);
    path.quadraticBezierTo(size.width*0.60, 30,size.width*0.55, 15);
    path.quadraticBezierTo(size.width*0.525, 7.5,size.width*0.5, 7.5);
    path.quadraticBezierTo(size.width*0.475, 7.5,size.width*0.45, 15);
    path.quadraticBezierTo(size.width*0.4, 30,30, 30);
    path.quadraticBezierTo(0, 30,0, 60);

    // path.lineTo(8, 0);
    // final firstStratPoint = Offset(8, 30);
    // final firstEndPoint = Offset(30, 30);
    // path.quadraticBezierTo(firstStratPoint.dx, firstStratPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    //
    // path.lineTo(size.width * 0.35, 30);
    // //2nd curve
    // final secondStartPoint = Offset(size.width * 0.4, 30);
    // final secondEndPoint = Offset(size.width * 0.45, 45);
    // path.quadraticBezierTo(secondStartPoint.dx, secondStartPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    //
    // //3rd curve
    // final thirdStartPoint = Offset(size.width * 0.475, 50);
    // final thirdEndPoint = Offset(size.width * 0.5, 50);
    // path.quadraticBezierTo(thirdStartPoint.dx, thirdStartPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);
    //
    // //4th curve
    // final fourStartPoint = Offset(size.width * 0.525, 50);
    // final fourEndPoint = Offset(size.width * 0.55, 45);
    // path.quadraticBezierTo(fourStartPoint.dx, fourStartPoint.dy, fourEndPoint.dx, fourEndPoint.dy);
    //
    // final fiveStartPoint = Offset(size.width * 0.6, 30);
    // final fiveEndPoint = Offset(size.width * 0.7, 30);
    // path.quadraticBezierTo(fiveStartPoint.dx, fiveStartPoint.dy, fiveEndPoint.dx, fiveEndPoint.dy);
    //
    // path.lineTo(size.width - 30, 30);
    //
    // final sevenStartPoint = Offset(size.width - 8, 30);
    // final sevenEndPoint = Offset(size.width - 8, 0);
    // path.quadraticBezierTo(sevenStartPoint.dx, sevenStartPoint.dy, sevenEndPoint.dx, sevenEndPoint.dy);

    // path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
