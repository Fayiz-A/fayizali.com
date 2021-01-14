import 'package:fayizali/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ParallaxCard extends StatefulWidget {
  @override
  _ParallaxCardState createState() => _ParallaxCardState();
}

class _ParallaxCardState extends State<ParallaxCard> {
  PageController pageController = PageController(viewportFraction: 0.8);

  double _pageIndex = 0;

  void initState() {
    super.initState();

    pageController.addListener(() {
      _pageIndex = pageController.page;
      setState(() {});
    });
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
        CustomCard(
          pageIndex: _pageIndex - 1,
        ),
        CustomCard(
          pageIndex: _pageIndex,
        )
      ],
    );
  }
}