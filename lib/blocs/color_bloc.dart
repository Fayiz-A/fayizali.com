import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

abstract class ColorEvent {}

class RandomColorGeneratorEvent extends ColorEvent {
  final bool lightColor;
  final String colorCode;

  RandomColorGeneratorEvent({this.lightColor, this.colorCode});
}

class ColorBloc extends Bloc<ColorEvent, ColorState> {
  ColorBloc() : super(ColorInitialState());

  @override
  Stream<ColorState> mapEventToState(
    ColorEvent event,
  ) async* {
    if(event is RandomColorGeneratorEvent) {
      String randomColor = event.colorCode == null ?
      _generateRandomColor(lightColor: event.lightColor ?? false,)
          :
      _generateRandomColor(lightColor: event.lightColor ?? false, customColorCodes: event.colorCode);

      yield RandomColorGeneratedState(randomColor: randomColor);
    } else {
      yield ColorInitialState();
    }
  }

  String _generateRandomColor({String customColorCodes = '0123456789ABCDEF', bool lightColor = false}) {

    if(lightColor) customColorCodes = 'BCDEF';

    List<String> colorHexValuesList = customColorCodes.split('');
    StringBuffer randomColorValuesList = StringBuffer();
    randomColorValuesList.write('#');

    math.Random random = math.Random();

    for(int codeIndex = 0; codeIndex < colorHexValuesList.length; codeIndex++) {
      int randomIndex = random.nextInt(colorHexValuesList.length - 1).abs();

      randomColorValuesList.write(colorHexValuesList[randomIndex]);
    }

    return randomColorValuesList.toString();
  }
}

abstract class ColorState {}

class ColorInitialState extends ColorState {}

class RandomColorGeneratedState extends ColorState {
  final String randomColor;

  RandomColorGeneratedState({@required this.randomColor});
}