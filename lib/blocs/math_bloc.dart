import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

enum AngleConversionType { radiansToDegrees, degreesToRadians }

abstract class MathBlocEvent {}

class AngleConversionEvent extends MathBlocEvent {
  final double angleInRadiansOrDegrees;
  final AngleConversionType conversionType;

  AngleConversionEvent({ @required this.angleInRadiansOrDegrees, @required this.conversionType });

}

class CoordinateInSectorIdentifierBlocEvent extends MathBlocEvent {
  final List<Offset> sectorEndCoordinatesList;
  final Offset coordinate;

  CoordinateInSectorIdentifierBlocEvent({@required this.sectorEndCoordinatesList, @required this.coordinate});
}

class MathBloc extends Bloc<MathBlocEvent, MathBlocState> {
  MathBloc() : super(MathBlocInitialState());

  @override
  Stream<MathBlocState> mapEventToState(
    MathBlocEvent event,
  ) async* {
    if(event is AngleConversionEvent) {
      double angle = event.angleInRadiansOrDegrees;
      
      switch(event.conversionType) {
        case AngleConversionType.degreesToRadians:
          double angleInRadians = angle * math.pi / 180;
          yield MathBlocAngleConversionState(angle: angleInRadians);
        break;

        case AngleConversionType.radiansToDegrees:
          double angleInDegrees;//TODO: write the logic for this conversion
          throw UnimplementedError('The logic for this event has not been written yet!');
          yield MathBlocAngleConversionState(angle: angleInDegrees);
        break;

        default:
          yield MathBlocAngleConversionState(angle: angle);
      }
    } else if(event is CoordinateInSectorIdentifierBlocEvent) {
      List<Offset> sectorEndCoordinatesList = event.sectorEndCoordinatesList;
      Offset coordinate = event.coordinate;

      List<Offset> offsetAndCoordinateGivenDifferenceList = [];

      for (Offset offset in sectorEndCoordinatesList) {

        Offset difference = offset - coordinate;

        offsetAndCoordinateGivenDifferenceList.add(difference);
      }

      List<Offset> offsetAndCoordinateGivenDifferenceUnsortedList = offsetAndCoordinateGivenDifferenceList.toList();

      offsetAndCoordinateGivenDifferenceList.sort((Offset offset1, Offset offset2) {
        if(offset1.dx.abs() == offset2.dx.abs() && offset1.dy.abs() == offset2.dy.abs()) {
          return 0;
        } else if(offset1.dx.abs() > offset2.dx.abs() && offset1.dy.abs() > offset2.dy.abs()) {
          return 1;
        } else if(offset1.dx.abs() < offset2.dx.abs() && offset1.dy.abs() < offset2.dy.abs()) {
          return -1;
        } else if(offset1.dx.abs() > offset2.dx.abs() && offset1.dy.abs() < offset2.dy.abs()) {
          if((offset1.dx.abs() - offset2.dx.abs()) > (offset2.dy.abs() - offset1.dy.abs())) {
            return 1;
          } else {
            return -1;
          }
        } else if(offset1.dx.abs() < offset2.dx.abs() && offset1.dy.abs() > offset2.dy.abs()) {
          if((offset2.dx.abs() - offset1.dx.abs()) > (offset1.dy.abs() - offset2.dy.abs())) {
            return -1;
          } else {
            return 1;
          }
        } else {
          return 0;
        }
      });
      print('sorted list is : $offsetAndCoordinateGivenDifferenceList');
      print('unsorted is: $offsetAndCoordinateGivenDifferenceUnsortedList');
      Offset sectorContainingCoordinateOffset = offsetAndCoordinateGivenDifferenceList.first;//the one with the least difference

      int sectorContainingCoordinateIndex = offsetAndCoordinateGivenDifferenceUnsortedList.indexOf(sectorContainingCoordinateOffset);
      print('sectorContainingCoordinateIndex: $sectorContainingCoordinateIndex');

      yield MathBlocCoordinateInSectorIdentifierState(sectorContainingCoordinateIndex: sectorContainingCoordinateIndex);
    }
  }
}

abstract class MathBlocState {}

class MathBlocInitialState extends MathBlocState {}

class MathBlocAngleConversionState extends MathBlocState {
  final double angle;

  MathBlocAngleConversionState({@required this.angle});
}

class MathBlocCoordinateInSectorIdentifierState extends MathBlocState {
  final int sectorContainingCoordinateIndex;
  MathBlocCoordinateInSectorIdentifierState({@required this.sectorContainingCoordinateIndex});

}