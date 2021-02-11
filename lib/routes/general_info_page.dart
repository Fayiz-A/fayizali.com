import 'package:fayizali/widgets/custom_animated_bubble.dart';
import 'package:flutter/material.dart';

class GeneralInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      for (int index = 0; index < 15; index++)
        CustomAnimatedBubble(index: index)
    ]));
  }
}
