import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fraction/fraction.dart';

abstract class RandomPathEvent {}

class RandomPathGeneratorEvent extends RandomPathEvent {
  final Size windowSize;
  final int numberOfPaths;

  RandomPathGeneratorEvent(
      {@required this.windowSize, @required this.numberOfPaths});
}

class PathRelatedToPreviousPathsGeneratorEvent extends RandomPathEvent {
  final Size windowSize;
  final int numberOfPaths;
  final List<Path> pathList;

  PathRelatedToPreviousPathsGeneratorEvent(
      {@required this.windowSize, @required this.numberOfPaths, @required this.pathList});
}

class RandomPathBloc extends Bloc<RandomPathEvent, RandomPathState> {
  RandomPathBloc() : super(RandomPathInitialState());

  @override
  Stream<RandomPathState> mapEventToState(RandomPathEvent event,) async* {
    if (event is RandomPathGeneratorEvent) {
      Size windowSize = event.windowSize;

      List<Path> pathList = [];

      for (int pathIndex = 0; pathIndex < event.numberOfPaths; pathIndex++) {
        math.Random random = math.Random();

        double randomX = random.nextDouble();
        double randomXInReasonableRange = _mapValueFromOneRangeToAnother(
            value: randomX,
            range1Min: 0.0,
            range1Max: 1.0,
            range2Min: 0.0,
            range2Max: windowSize.width
        );

        double randomY = random.nextDouble();
        double randomYInReasonableRange = _mapValueFromOneRangeToAnother(
            value: randomY,
            range1Min: 0.0,
            range1Max: 1.0,
            range2Min: windowSize.height,
            range2Max: windowSize.height * 2
        );

        double randomLineEndX = random.nextDouble();
        double randomLineEndXInReasonableRange = _mapValueFromOneRangeToAnother(
            value: randomLineEndX,
            range1Min: 0.0,
            range1Max: 1.0,
            range2Min: 0.0,
            range2Max: windowSize.width
        );

        double randomLineEndY = random.nextDouble();
        double randomLineEndYInReasonableRange = _mapValueFromOneRangeToAnother(
            value: randomLineEndY,
            range1Min: 0.0,
            range1Max: 1.0,
            range2Min: -(windowSize.height / 2),
            range2Max: windowSize.height / 2
        );

        Path path = Path()
          ..moveTo(randomXInReasonableRange, randomYInReasonableRange)
          ..lineTo(randomLineEndXInReasonableRange,
              randomLineEndYInReasonableRange);
          // ..close();
        pathList.add(path);
      }

      yield RandomPathGeneratedState(pathList: pathList);
    } else if (event is PathRelatedToPreviousPathsGeneratorEvent) {
      List<Path> previousPathList = event.pathList;
      Size windowSize = event.windowSize;
      List<Path> pathList = [];

      for (int pathIndex = 0; pathIndex <
          previousPathList.length; pathIndex++) {
        Path previousPath = previousPathList[pathIndex];

        Offset previousPathEndOffset = _getPathEndOffset(path: previousPath);
        bool previousPathInWindowBounds = _checkIfPathEndInScreenBounds(pathEndOffset: previousPathEndOffset, windowSize: windowSize);

        math.Random random = math.Random();

        double randomX = random.nextDouble();
        double randomY = random.nextDouble();

        double randomLineEndX = random.nextDouble();
        double randomLineEndY = random.nextDouble();

        Path path;

        if (previousPathInWindowBounds) {

          double randomLineEndXInReasonableRange = _mapValueFromOneRangeToAnother(
              value: randomLineEndX,
              range1Min: 0.0,
              range1Max: 1.0,
              range2Min: 0.0,
              range2Max: windowSize.width);

          double randomLineEndYInReasonableRange = _mapValueFromOneRangeToAnother(
              value: randomLineEndY,
              range1Min: 0.0,
              range1Max: 1.0,
              range2Min: -(windowSize.height / 10),
              range2Max: -(windowSize.height / 2));

          Fraction previousPathExtendedEndOffsetXInvertedFraction = Fraction.fromDouble((math.tan(previousPathEndOffset.direction)) / randomLineEndYInReasonableRange);
          previousPathExtendedEndOffsetXInvertedFraction.inverse();
          double previousPathExtendedEndOffsetXDouble = previousPathExtendedEndOffsetXInvertedFraction.toDouble().abs();

          path = Path()
              ..moveTo(previousPathEndOffset.dx, previousPathEndOffset.dy)
              ..lineTo(previousPathExtendedEndOffsetXDouble, randomLineEndYInReasonableRange);
              // ..close();
        } else {
          double randomYInReasonableRange = _mapValueFromOneRangeToAnother(
              value: randomY,
              range1Min: 0.0,
              range1Max: 1.0,
              range2Min: windowSize.height,
              range2Max: windowSize.height * 2);

          double randomXInReasonableRange = _mapValueFromOneRangeToAnother(
              value: randomX,
              range1Min: 0.0,
              range1Max: 1.0,
              range2Min: 0.0,
              range2Max: windowSize.width);


          double randomLineEndX = random.nextDouble();
          double randomLineEndXInReasonableRange = _mapValueFromOneRangeToAnother(
              value: randomLineEndX,
              range1Min: 0.0,
              range1Max: 1.0,
              range2Min: 0.0,
              range2Max: windowSize.width);

          double randomLineEndY = random.nextDouble();
          double randomLineEndYInReasonableRange = _mapValueFromOneRangeToAnother(
              value: randomLineEndY,
              range1Min: 0.0,
              range1Max: 1.0,
              range2Min: -(windowSize.height / 2),
              range2Max: windowSize.height / 2)
          ;

          path = Path()
            ..moveTo(randomXInReasonableRange, randomYInReasonableRange)
            ..lineTo(
                randomLineEndXInReasonableRange, randomLineEndYInReasonableRange);
            // ..close();
        }

        pathList.add(path);

      }

      yield RandomPathGeneratedState(pathList: pathList);
    } else {
      yield RandomPathInitialState();
    }
  }

  double _mapValueFromOneRangeToAnother(
      {@required value, @required range1Min, @required range1Max, @required range2Min, @required range2Max}) {
    double oldRange = range1Max - range1Min;
    double newRange = range2Max - range2Min;
    double newValue = (((value - range1Min) / oldRange) * newRange) + range2Min;
    
    return newValue;
  }

  Offset _getPathEndOffset({@required Path path}) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    double valueToTranslateTo = pathMetric.length;
    Tangent positionDetailsForBubble = pathMetric.getTangentForOffset(valueToTranslateTo);

    Offset position = positionDetailsForBubble.position;

    return position;
  }

  bool _checkIfPathEndInScreenBounds({@required Offset pathEndOffset, @required Size windowSize}) {
    return pathEndOffset.dx < windowSize.width && pathEndOffset.dx > 0.0 && pathEndOffset.dy < windowSize.height && pathEndOffset.dy > 0.0;
  }

}

abstract class RandomPathState {}

class RandomPathInitialState extends RandomPathState {}

class RandomPathGeneratedState extends RandomPathState {
  final List<Path> pathList;
  RandomPathGeneratedState({@required this.pathList});
}

class PathRelatedToPreviousPathsGeneratorState extends RandomPathState {
  final List<Path> pathList;
  PathRelatedToPreviousPathsGeneratorState({@required this.pathList});
}
