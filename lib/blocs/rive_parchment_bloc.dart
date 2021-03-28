import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

abstract class RiveParchmentEvent {}

class RiveParchmentLoadEvent extends RiveParchmentEvent {
  final fileName;

  RiveParchmentLoadEvent({@required this.fileName});
}

class RiveParchmentUnfoldEvent extends RiveParchmentEvent {}

class RiveParchmentBloc extends Bloc<RiveParchmentEvent, RiveParchmentState> {

  Artboard _artBoard;

  RiveParchmentBloc() : super(RiveParchmentInitialState());

  @override
  Stream<RiveParchmentState> mapEventToState(
    RiveParchmentEvent event,
  ) async* {
    if(event is RiveParchmentLoadEvent) {
      yield* loadParchment(riveFileName: event.fileName);
    } else if(event is RiveParchmentUnfoldEvent) {
     yield* unfoldParchment();
    }
  }

  Stream<RiveParchmentState> loadParchment({@required String riveFileName}) async* {
    final bytes = await rootBundle.load('parchment.riv');
    final file = RiveFile();

    if (file.import(bytes)) {
      _artBoard = file.mainArtboard;
      yield RiveParchmentLoadedState(artBoard: _artBoard);
    } else {
      yield RiveParchmentInitialState();
    }
  }

  Stream<RiveParchmentState> unfoldParchment() async* {
    if(_artBoard != null) {
      _artBoard.addController(SimpleAnimation('RollingAnimation'));
      yield RiveParchmentUnfoldedState(artBoard: _artBoard);
    } else {
      yield RiveParchmentInitialState();
    }
  }
}

abstract class RiveParchmentState {
  final Artboard artBoard;

  RiveParchmentState({@required this.artBoard});
}

class RiveParchmentInitialState extends RiveParchmentState {}

class RiveParchmentLoadedState extends RiveParchmentState {
  final Artboard artBoard;

  RiveParchmentLoadedState({@required this.artBoard}):super(artBoard: artBoard);
}

class RiveParchmentUnfoldedState extends RiveParchmentState {
  final Artboard artBoard;

  RiveParchmentUnfoldedState({@required this.artBoard}):super(artBoard: artBoard);
}
