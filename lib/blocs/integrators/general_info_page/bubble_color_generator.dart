import 'dart:async';

import 'package:fayizali/blocs/color_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fayizali/constants.dart' as constants;

abstract class BubbleColorEvent {}

class BubbleColorGeneratorEvent extends BubbleColorEvent {

  final int index;
  BubbleColorGeneratorEvent({@required this.index});
}

class BubbleColorGeneratorBloc extends Bloc<BubbleColorEvent, BubbleColorGeneratedState> {
  ColorBloc colorBloc = ColorBloc();

  BubbleColorGeneratorBloc() : super(BubbleColorGeneratedState(color: constants.generalInfoPageFallbackColor, index: 0)) {

    @override
    Future<void> close() async {
      colorBloc.close();
      await super.close();
    }
  }

  @override
  Stream<BubbleColorGeneratedState> mapEventToState(event) async* {


    if(event is BubbleColorGeneratorEvent) {

      int index = event.index;
      // colorBloc.add(RandomColorGeneratorEvent());

      yield BubbleColorGeneratedState(color: '#12f342', index: index);

      // await for (ColorState colorState in colorBloc) {
      //   if(colorState is RandomColorGeneratedState) {
      //     print(colorState.randomColor);
      //     yield BubbleColorGeneratedState(color: colorState.randomColor, index: index);
      //   }
      // }

    }

  }

}

class BubbleColorGeneratedState {
  final String color;
  final int index;
  BubbleColorGeneratedState({@required this.color, @required this.index});
}