import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as Math;

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
          Offset(0, 0),
          Offset(mainCoordinatesMap['bottomLeft'].dx,
              mainCoordinatesMap['bottomLeft'].dy),
          [Colors.orange, Colors.deepOrange]);

    Path topCurvePath = Path()
      ..moveTo(
          mainCoordinatesMap['topLeft'].dx,
          mainCoordinatesMap['topLeft']
              .dy) //just to be safe else this is the default value
      ..lineTo(
          mainCoordinatesMap['topLeft'].dx,
          size.height > 850
              ? mainCoordinatesMap['topLeft'].dy + size.height * 0.33
              : mainCoordinatesMap['topLeft'].dy +
                  size.height *
                      0.35) //this is done for the starting point of the curve
      //these hardcoded values do not effect app responsiveness
      ..quadraticBezierTo(90, 240, 90, 200)
      ..quadraticBezierTo(110, 40, 250, 30)
      ..quadraticBezierTo(280, 25, 290, 0)
      ..close();

    canvas.drawPath(topCurvePath, topCurvePaint);

    double bottomCenterArcRadius = size.height * 0.18;
    Offset bottomCenterArcCenter = Offset(
        mainCoordinatesMap['bottomLeft'].dx + bottomCenterArcRadius * 1.7,
        mainCoordinatesMap['bottomLeft'].dy + (bottomCenterArcRadius * 0.25));

    drawHalfCircleWithOutlineCircle(canvas: canvas, innerCircleRadius: bottomCenterArcRadius, radiusDifference: 50, innerCircleColor: Colors.red, outerCircleColor: Colors.blue, center: bottomCenterArcCenter, mainCoordinatesMap: mainCoordinatesMap);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void drawHalfCircle(
      {@required Canvas canvas,
      @required double radius,
      Color color,
      @required Offset center,
      @required Map<String, Offset> mainCoordinatesMap}) {
    Paint halfCirclePaint = Paint()..color = color ?? Colors.white;

    Rect halfCircleRect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(halfCircleRect, 0, -Math.pi, true, halfCirclePaint);
  }

  void drawHalfCircleWithOutlineCircle(
    {@required Canvas canvas,
      @required double innerCircleRadius,
      @required double radiusDifference,
      @required Color innerCircleColor,
      @required Color outerCircleColor,
      @required Offset center,
      @required Map<String, Offset> mainCoordinatesMap}
  ) {
    drawHalfCircle(canvas: canvas, radius: innerCircleRadius + radiusDifference, center: center, mainCoordinatesMap: mainCoordinatesMap, color: outerCircleColor);
    drawHalfCircle(canvas: canvas, radius: innerCircleRadius, center: center, mainCoordinatesMap: mainCoordinatesMap, color: innerCircleColor);

  }
}
