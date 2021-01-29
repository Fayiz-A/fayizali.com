import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fayizali/blocs/math_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class CircleSectorCoordinatesEvent {}

class CircleSectorEndCoordinatesIdentifierEvent extends CircleSectorCoordinatesEvent {
  final double radius;
  final int numberOfSectors;

  CircleSectorEndCoordinatesIdentifierEvent({@required this.radius, @required this.numberOfSectors});
}

class CircleSectorCoordinatesBloc extends Bloc<CircleSectorCoordinatesEvent, CircleSectorCoordinatesState> {
  CircleSectorCoordinatesBloc() : super(CircleSectorCoordinatesInitialState());

  CircleSectorCoordinatesState get initialState => CircleSectorCoordinatesInitialState();

  @override
  Stream<CircleSectorCoordinatesState> mapEventToState(CircleSectorCoordinatesEvent event,) async* {

    if(event is CircleSectorEndCoordinatesIdentifierEvent) {
      int numberOfSectors = event.numberOfSectors;
      double radius = event.radius;
      double angleInDegrees = 360 / numberOfSectors;

      MathBloc mathBloc = MathBloc();

      mathBloc.add(AngleConversionEvent(angleInRadiansOrDegrees: angleInDegrees, conversionType: AngleConversionType.degreesToRadians));

      await for(MathBlocState state in mathBloc) {
        if(state is MathBlocAngleConversionState) {
          print('ConvertedAngle is: ${state.angle}');
          yield CircleSectorEndCoordinatesIdentifiedState(sectorEndCoordinatesList: []);
        } else {
          yield CircleSectorCoordinatesInitialState();
        }
      }

    }
  }
}

abstract class CircleSectorCoordinatesState {}

class CircleSectorCoordinatesInitialState extends CircleSectorCoordinatesState {
}

class CircleSectorEndCoordinatesIdentifiedState extends CircleSectorCoordinatesState {
  final List<Offset> sectorEndCoordinatesList;

  CircleSectorEndCoordinatesIdentifiedState({@required this.sectorEndCoordinatesList});
}
