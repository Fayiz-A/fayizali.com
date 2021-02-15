import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fayizali/constants.dart' as constants;

abstract class BubbleTouchEvent {}

class BubbleClickedEvent extends BubbleTouchEvent {
  final Offset touchOffset;
  final int index;

  BubbleClickedEvent({@required this.touchOffset, @required this.index});
}

class BubbleTouchBloc extends Bloc<BubbleTouchEvent, BubbleTouchState> {
  BubbleTouchBloc() : super(BubbleTouchInitialState());

  @override
  Stream<BubbleTouchState> mapEventToState(
      BubbleTouchEvent event,
      ) async* {
    if(event is BubbleClickedEvent) {
      yield BubbleClickedState(bubbleClickOffset: event.touchOffset, index: event.index);

      yield* _yieldResumeBubbleAfterSomeTime();
    }
  }

  Stream<BubbleResumeState> _yieldResumeBubbleAfterSomeTime() async* {
    await Future.delayed(Duration(milliseconds: constants.bubbleStopDurationInMS));
    yield BubbleResumeState();
  }
}

abstract class BubbleTouchState {
  final int index;
  BubbleTouchState({@required this.index});

}

class BubbleTouchInitialState extends BubbleTouchState {}

class BubbleClickedState extends BubbleTouchState {
  final Offset bubbleClickOffset;

  BubbleClickedState({@required this.bubbleClickOffset, index }):super(index: index);
}

class BubbleResumeState extends BubbleTouchState {}