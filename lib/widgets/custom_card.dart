import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomCard extends StatelessWidget {

  final double pageIndex;

  CustomCard({@required this.pageIndex});

  @override
  Widget build(BuildContext context) {

    double gauss = math.exp(-(math.pow(pageIndex.abs() - 0.5, 2) / 0.08));

    return Transform.translate(
      offset: Offset(100 * gauss*pageIndex.sign, 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
        child: Placeholder(),

        elevation: 8.0,
      ),
    );
  }
}
