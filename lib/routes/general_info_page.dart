import 'dart:async';
import 'dart:math' as math;
import 'package:fayizali/widgets/custom_animated_bubble.dart';
import 'package:flutter/material.dart';

class GeneralInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          Background(),
      for (int index = 0; index <= 15; index++)
        CustomAnimatedBubble(index: index)
    ]));
  }
}

class Background extends StatefulWidget {
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {

  Color _color = Colors.red;

  @override
  void initState() {
    super.initState();

    // Timer.periodic(Duration(milliseconds: 1500), (timer) {
    //   setState(() {
    //     List<Color> colorList = [Colors.yellow, Colors.orange, Colors.pink, Colors.indigo, Colors.red, Colors.green, Colors.blue];
    //
    //     _color = colorList[math.Random().nextInt(colorList.length - 1).abs()];
    //   });
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // duration: Duration(milliseconds: 700),
      width: double.infinity,
      height: double.infinity,
      color: _color,
    );
  }
}
