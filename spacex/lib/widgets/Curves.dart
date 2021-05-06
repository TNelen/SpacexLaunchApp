import 'package:flutter/material.dart';

import '../Constants.dart';

class InforCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Constants.tile;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.20);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.15,
        size.width * 0.5, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.15,
        size.width * 1.0, size.height * 0.20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class MainscreenCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Constants.tile;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.28);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.25,
        size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.25,
        size.width * 1.0, size.height * 0.28);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

