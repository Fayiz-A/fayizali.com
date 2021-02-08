import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

abstract class RandomPathEvent {}

class RandomPathGeneratorEvent extends RandomPathEvent {
  final Size windowSize;
  final int numberOfPaths;

  RandomPathGeneratorEvent({@required this.windowSize, @required this.numberOfPaths});
}

class RandomPathBloc extends Bloc<RandomPathEvent, RandomPathState> {
  RandomPathBloc() : super(RandomPathInitialState());

  RandomPathState get initialState => RandomPathInitialState();

  @override
  Stream<RandomPathState> mapEventToState(
      RandomPathEvent event,
      ) async* {
    if (event is RandomPathGeneratorEvent) {
      if(state is RandomPathInitialState) {
        Size windowSize = event.windowSize;

        List<Path> pathList = [];
        
        for(int pathIndex = 0; pathIndex<event.numberOfPaths; pathIndex++) {
          math.Random random = math.Random();

          double randomX = random.nextDouble();
          double randomXInReasonableRange = _mapValueFromOneRangeToAnother(value: randomX, range1Min: 0.0,  range1Max: 1.0, range2Min: 0.0, range2Max: windowSize.width );

          double randomY = random.nextDouble();
          double randomYInReasonableRange = _mapValueFromOneRangeToAnother(value: randomY, range1Min: 0.0,  range1Max: 1.0, range2Min: windowSize.height, range2Max: windowSize.height * 2 );

          double randomLineEndX = random.nextDouble();
          double randomLineEndXInReasonableRange = _mapValueFromOneRangeToAnother(value: randomLineEndX, range1Min: 0.0,  range1Max: 1.0, range2Min: 0.0, range2Max: windowSize.width );

          double randomLineEndY = random.nextDouble();
          double randomLineEndYInReasonableRange = _mapValueFromOneRangeToAnother(value: randomLineEndY, range1Min: 0.0,  range1Max: 1.0, range2Min: 0.0, range2Max: 200 );

          Path path = Path()
            ..moveTo(randomXInReasonableRange, randomYInReasonableRange)
            ..lineTo(randomLineEndXInReasonableRange, randomLineEndYInReasonableRange)
            ..close();
          pathList.add(path);
        }
        
        yield RandomPathGeneratedState(pathList: pathList);

      }
    } else {
      yield RandomPathInitialState();
    }
  }

  double _mapValueFromOneRangeToAnother({@required value, @required range1Min, @required range1Max, @required range2Min, @required range2Max}) {
    double oldRange = range1Max - range1Min;
    double newRange = range2Max - range2Min;
    double newValue = (((value - range1Min) / oldRange) * newRange) + range2Min;
    
    return newValue;
  }
}

abstract class RandomPathState {}

class RandomPathInitialState extends RandomPathState {}

class RandomPathGeneratedState extends RandomPathState {
  final List<Path> pathList;
  RandomPathGeneratedState({@required this.pathList});
}
