import 'dart:async';

import 'package:fayizali/blocs/color_bloc.dart';
import 'package:fayizali/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BubbleColorEvent {}

class BubbleColorGeneratorEvent extends BubbleColorEvent {
  final int index;

  BubbleColorGeneratorEvent({@required this.index});
}

class BubbleColorGeneratorBloc
    extends Bloc<BubbleColorEvent, BubbleColorGeneratedState> {
  ColorBloc colorBloc = ColorBloc();
  String color;

  BubbleColorGeneratorBloc()
      : super(BubbleColorGeneratedState(
      color: constants.generalInfoPageFallbackColor, index: 0)) {
    colorBloc.listen((ColorState colorState) {
      if (colorState is RandomColorGeneratedState)
        color = colorState.randomColor;

    });

    @override
    Future<void> close() async {
      colorBloc.close();
      await super.close();
    }
  }

  @override
  Stream<BubbleColorGeneratedState> mapEventToState(event) async* {
    if (event is BubbleColorGeneratorEvent) {
      int index = event.index;

      colorBloc.add(RandomColorGeneratorEvent());

      yield BubbleColorGeneratedState(color: color, index: index);
    }
  }
}

class BubbleColorGeneratedState {
  final String color;
  final int index;

  BubbleColorGeneratedState({@required this.color, @required this.index});
}
