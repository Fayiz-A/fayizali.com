import 'package:fayizali/routes/parallax_card.dart';
import 'package:fayizali/widgets/arc_frame_painter.dart';
import 'package:flutter/material.dart';

class ComputerLanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: CustomPaint(
            size: Size.infinite,
            foregroundPainter: FramePainter(),
            child: Center(
              child: Placeholder()
            ),
          ),
    ));
  }
}
