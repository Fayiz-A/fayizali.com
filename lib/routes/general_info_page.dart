import 'dart:async';

import 'package:fayizali/blocs/color_bloc.dart';
import 'package:fayizali/classes/information.dart';
import 'package:fayizali/constants.dart' as constants;
import 'package:fayizali/extensions/hex_color.dart';
import 'package:fayizali/widgets/custom_animated_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralInfoPage extends StatelessWidget {

  final List<Map<String, String>> informationList = [
      {'Name': 'Fayiz Ali'},
      {'Grade': '8'},
      {'Age': '12'},
      {'Father\'s Name': 'Arif Ali'},
      {'Mother\'s Name': 'Sana Maryam'},
      {'Hobbies': 'Computer Programming, Reading about geopolitics'},
      {'Favourite Color': 'white'},
      {'School': 'Ryan International School'},
      {'Address': 'K-76/A, Abul Fazal Enclave, Jamia Nagar, Okhla, New Delhi-110025, India'},
      {'Siblings': 'Isa Ali'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          Background(),
          for (int index = 0;
          index < informationList.length;
          index++)
            CustomAnimatedBubble(index: index, bubbleDisplayInformation: informationList[index])
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
