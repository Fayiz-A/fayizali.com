import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:fayizali/blocs/math_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class CircleSectorCoordinatesEvent {}

class CircleSectorEndCoordinatesIdentifierEvent
    extends CircleSectorCoordinatesEvent {
  final double radius;
  final int numberOfSectors;
  final Offset center;

  CircleSectorEndCoordinatesIdentifierEvent(
      {@required this.radius,
        @required this.numberOfSectors,
        @required this.center});
}

class CircleSectorCoordinatesBloc
    extends Bloc<CircleSectorCoordinatesEvent, CircleSectorCoordinatesState> {
  CircleSectorCoordinatesBloc() : super(CircleSectorCoordinatesInitialState());

  CircleSectorCoordinatesState get initialState =>
      CircleSectorCoordinatesInitialState();

  @override
  Stream<CircleSectorCoordinatesState> mapEventToState(
      CircleSectorCoordinatesEvent event,
      ) async* {
    if (event is CircleSectorEndCoordinatesIdentifierEvent) {
      yield* calculateCoordinateEnds(event: event);
    }
  }

  Stream<CircleSectorCoordinatesState> calculateCoordinateEnds({@required event}) async* {
    int numberOfSectors = event.numberOfSectors;
    Offset center = event.center;
    double radius = event.radius;
    double angleInDegrees = 360 / numberOfSectors;

    MathBloc mathBloc = MathBloc();

    List<Offset> sectorEndCoordinatesList = [];

    mathBloc.add(AngleConversionEvent(
        angleInRadiansOrDegrees: angleInDegrees,
        conversionType: AngleConversionType.degreesToRadians));

    await for(MathBlocState state in mathBloc) {
      if (state is MathBlocAngleConversionState) {

        for (int side = 1; side <= numberOfSectors; side++) {
          double angleInRadians = state.angle;
          double angleOfSectorLocation = angleInRadians * side;
          print('ConvertedAngle in radians is: $angleInRadians');
          print('Angle Of Sector Location is: $angleOfSectorLocation');

          double corX = math.cos(angleOfSectorLocation) * radius + center.dx;
          double corY = math.sin(angleOfSectorLocation) * radius + center.dy;

          sectorEndCoordinatesList.add(Offset(corX, corY));
        }
      }
      yield CircleSectorEndCoordinatesIdentifiedState(
          sectorEndCoordinatesList: sectorEndCoordinatesList);
    }
  }
}

abstract class CircleSectorCoordinatesState {}

class CircleSectorCoordinatesInitialState extends CircleSectorCoordinatesState {
}

class CircleSectorEndCoordinatesIdentifiedState
    extends CircleSectorCoordinatesState {
  final List<Offset> sectorEndCoordinatesList;

  CircleSectorEndCoordinatesIdentifiedState(
      {@required this.sectorEndCoordinatesList});
}
