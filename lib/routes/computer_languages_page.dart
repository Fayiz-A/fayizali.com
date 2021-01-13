import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ComputerLanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: CustomPaint(
        painter: FramePainter(),
      ),
    ));
  }
}

class FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset centerLeft = Offset(0, center.dy);
    Offset topCenter = Offset(center.dx, 0);
    Offset topRightCorner = Offset(size.width, 0.0);
    Offset topLeftCorner = Offset(0, 0);

    Map<String, Offset> mainCoordinatesMap = {
      'topLeft': Offset(0, 0),
      'topCenter': Offset(size.width / 2, 0),
      'topRight': Offset(size.width, 0),
      'centerLeft': Offset(0, size.height / 2),
      'center': Offset(size.width / 2, size.height / 2),
      'centerRight': Offset(size.width, size.height / 2),
      'bottomLeft': Offset(0, size.height),
      'bottomCenter': Offset(size.width / 2, size.height),
      'bottomRight': Offset(size.width, size.height)
    };

    Paint topCurvePaint = Paint()
      ..shader = ui.Gradient.linear(
          Offset(0, 0), Offset(200, 200), [Colors.orange, Colors.deepOrange]);

    Path topCurvePath = Path()
      ..moveTo(mainCoordinatesMap['topLeft'].dx, mainCoordinatesMap['topLeft'].dy) //just to be safe else this is the default value
      ..lineTo(mainCoordinatesMap['topLeft'].dx, mainCoordinatesMap['topLeft'].dy + size.height*0.33) //this is done for the starting point of the curve
      ..quadraticBezierTo(90, 240, 90, 200)
      ..quadraticBezierTo(110, 40, 250, 30)
      ..quadraticBezierTo(280, 25, 290, 0)
      ..close();

    canvas.drawPath(topCurvePath, topCurvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
