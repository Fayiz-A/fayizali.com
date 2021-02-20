import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fayizali/constants.dart' as constants;

abstract class TouchEvent {}

class BubbleTouchEvent extends TouchEvent {
  final Offset touchOffset;
  final int index;

  BubbleTouchEvent({@required this.touchOffset, @required this.index});
}

class TouchBloc extends Bloc<TouchEvent, TouchState> {
  TouchBloc() : super(BubbleTouchInitialState());

  @override
  Stream<TouchState> mapEventToState(
      TouchEvent event,
      ) async* {
    if(event is BubbleTouchEvent) {
      yield BubbleClickedState(bubbleClickOffset: event.touchOffset, index: event.index);

      yield* _yieldResumeBubbleAfterSomeTime();
    }
  }

  Stream<BubbleResumeState> _yieldResumeBubbleAfterSomeTime() async* {
    await Future.delayed(Duration(milliseconds: constants.bubbleStopDurationInMS));
    yield BubbleResumeState();
  }
}

abstract class TouchState {
  final int index;
  TouchState({@required this.index});

}

class BubbleTouchInitialState extends TouchState {}

class BubbleClickedState extends TouchState {
  final Offset bubbleClickOffset;

  BubbleClickedState({@required this.bubbleClickOffset, index }):super(index: index);
}

class BubbleResumeState extends TouchState {}