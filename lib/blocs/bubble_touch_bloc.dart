import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

abstract class BubbleTouchEvent {}

class BubbleClickedEvent extends BubbleTouchEvent {
  final Offset touchOffset;

  BubbleClickedEvent({@required this.touchOffset});
}

class BubbleTouchBloc extends Bloc<BubbleTouchEvent, BubbleTouchState> {
  BubbleTouchBloc() : super(BubbleTouchInitialState());

  @override
  Stream<BubbleTouchState> mapEventToState(
      BubbleTouchEvent event,
      ) async* {
    if(event is BubbleClickedEvent) {
      yield BubbleClickedState();
    }
  }
}

abstract class BubbleTouchState {}

class BubbleTouchInitialState extends BubbleTouchState {}

class BubbleClickedState extends BubbleTouchState{}