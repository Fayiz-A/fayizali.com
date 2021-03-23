import 'dart:async';

import 'package:fayizali/blocs/color_bloc.dart';
import 'package:fayizali/constants.dart' as constants;
import 'package:fayizali/extensions/hex_color.dart';
import 'package:fayizali/widgets/custom_animated_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          Background(),
          for (int index = 0;
          index <= (MediaQuery.of(context).size.width / 80).round();
          index++)
            CustomAnimatedBubble(index: index)
        ]));
  }
}

class Background extends StatefulWidget {
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  void initState() {
    super.initState();

    // ignore: close_sinks
    ColorBloc colorBloc = BlocProvider.of<ColorBloc>(context);

    Timer.periodic(Duration(milliseconds: 1500), (timer) => colorBloc.add(RandomColorGeneratorEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorBloc, ColorState>(
      builder: (BuildContext context, ColorState colorState) {
        String color = colorState is RandomColorGeneratedState
            ? colorState.randomColor
            : constants.generalInfoPageFallbackColor;

        return AnimatedContainer(
          duration: Duration(milliseconds: 700),
          width: double.infinity,
          height: double.infinity,
          color: HexColor.fromHex(color),
        );
      },
    );
  }
}
