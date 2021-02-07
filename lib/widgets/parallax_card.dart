import 'package:fayizali/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class ParallaxWidget extends StatefulWidget {
  
  final int itemCount;
  final double viewPortFraction;
  final Widget Function(int index) renderChildInPageView;

  ParallaxWidget({
    @required this.itemCount,
    @required this.viewPortFraction,
    @required this.renderChildInPageView,
  });
  
  @override
  _ParallaxWidgetState createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget> {
  PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(viewportFraction: widget.viewPortFraction);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        for(int index = 0; index<widget.itemCount; index++)
          widget.renderChildInPageView(index),
      ],
    );
  }
}