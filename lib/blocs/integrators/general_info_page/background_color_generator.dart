import 'dart:async';

import 'package:fayizali/blocs/color_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fayizali/constants.dart' as constants;

abstract class BackgroundColorEvent {}

class BackgroundColorGeneratorEvent extends BackgroundColorEvent {}

class ColorEventFromColorBloc extends BackgroundColorEvent {
  final String color;
  ColorEventFromColorBloc({@required this.color});
}

class BackgroundColorGeneratorBloc extends Bloc<BackgroundColorEvent, BackgroundColorGeneratedState> {
  ColorBloc colorBloc = ColorBloc();

  BackgroundColorGeneratorBloc() : super(BackgroundColorGeneratedState(color: constants.generalInfoPageFallbackColor)) {
    
    colorBloc.listen((state) async* {
      if(state is RandomColorGeneratedState) {
        add(ColorEventFromColorBloc(color: state.randomColor));
      }
    });

    @override
    Future<void> close() async {
      colorBloc.close();
      await super.close();
    }
  }

  @override
  Stream<BackgroundColorGeneratedState> mapEventToState(event) async* {

    if(event is BackgroundColorGeneratorEvent) {
      colorBloc.add(RandomColorGeneratorEvent());
    }

    if(event is ColorEventFromColorBloc) {
      yield BackgroundColorGeneratedState(color: event.color);
    }

  }

}

class BackgroundColorGeneratedState {
  final String color;
  BackgroundColorGeneratedState({@required this.color});
}