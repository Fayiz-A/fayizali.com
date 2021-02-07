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

        List<Path> pathList;
        
        for(int pathIndex = 0; pathIndex<event.numberOfPaths; pathIndex++) {
          math.Random random = math.Random(0);

          double randomX = random.nextDouble();
          double randomXInReasonableRange = _mapValueFromOneRangeToAnother(value: randomX, range1Min: 0.0,  range1Max: 1.0, range2Min: 0.0, range2Max: windowSize.width );

          double randomY = random.nextDouble();
          double randomYInReasonableRange = _mapValueFromOneRangeToAnother(value: randomY, range1Min: 0.0,  range1Max: 1.0, range2Min: windowSize.height, range2Max: windowSize.height * 2 );

          Path path = Path()
            ..moveTo(randomXInReasonableRange, randomYInReasonableRange)
            ..lineTo(0, 0);
          pathList.add(path);
        }
        
        yield RandomPathGeneratedState(pathList: pathList);

      } else {
        print('second time');
      }
    } else {
      yield RandomPathInitialState();
    }
  }

  double _mapValueFromOneRangeToAnother({@required value, @required range1Min, @required range1Max, @required range2Min, @required range2Max}) {
    double oldRange = range1Max - range1Min;
    double newRange = range2Min - range2Max;
    double newValue = (((value - range1Min) * newRange) / oldRange) + range2Min;
    
    return newValue;
  }
}

abstract class RandomPathState {}

class RandomPathInitialState extends RandomPathState {}

class RandomPathGeneratedState extends RandomPathState {
  final List<Path> pathList;
  RandomPathGeneratedState({@required this.pathList});
}
