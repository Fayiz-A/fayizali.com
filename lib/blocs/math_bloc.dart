import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:poly/poly.dart';

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
  final Offset center;

  CoordinateInSectorIdentifierBlocEvent({@required this.sectorEndCoordinatesList, @required this.coordinate, @required this.center});
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
      Offset center = event.center;

      List<math.Point<num>> polygonPointsList = [];
      List<bool> sectorContainsPointList = [];

      for (var index = 0; index < sectorEndCoordinatesList.length; index++) {
        Offset offset = sectorEndCoordinatesList[index];

        math.Point point = math.Point(offset.dx, offset.dy);
        polygonPointsList.add(point);

        if(index-1 != -1) {
          List<math.Point> allPointsForTriangleList = [polygonPointsList[index-1], polygonPointsList[index], math.Point(center.dx, center.dy)];
          Polygon triangle = Polygon(allPointsForTriangleList);
          bool sectorContainsPoint = triangle.isPointInside(Point(coordinate.dx, coordinate.dy));
          sectorContainsPointList.add(sectorContainsPoint);
        }
      }

      print(sectorContainsPointList);
      print(sectorContainsPointList.indexOf(true));
      yield MathBlocCoordinateInSectorIdentifierState(sectorContainingCoordinateIndex: sectorContainsPointList.indexOf(true));
      // List<Offset> offsetAndCoordinateGivenDifferenceList = [];
      //
      // for (Offset offset in sectorEndCoordinatesList) {
      //
      //   Offset difference = offset - coordinate;
      //
      //   offsetAndCoordinateGivenDifferenceList.add(difference);
      // }
      //
      // List<Offset> offsetAndCoordinateGivenDifferenceUnsortedList = offsetAndCoordinateGivenDifferenceList.toList();
      //
      // offsetAndCoordinateGivenDifferenceList.sort((Offset offset1, Offset offset2) {
      //   if(offset1.dx.abs() == offset2.dx.abs() && offset1.dy.abs() == offset2.dy.abs()) {
      //     return 0;
      //   } else if(offset1.dx.abs() > offset2.dx.abs() && offset1.dy.abs() > offset2.dy.abs()) {
      //     return 1;
      //   } else if(offset1.dx.abs() < offset2.dx.abs() && offset1.dy.abs() < offset2.dy.abs()) {
      //     return -1;
      //   } else if(offset1.dx.abs() > offset2.dx.abs() && offset1.dy.abs() < offset2.dy.abs()) {
      //     if((offset1.dx.abs() - offset2.dx.abs()) > (offset2.dy.abs() - offset1.dy.abs())) {
      //       return 1;
      //     } else {
      //       return -1;
      //     }
      //   } else if(offset1.dx.abs() < offset2.dx.abs() && offset1.dy.abs() > offset2.dy.abs()) {
      //     if((offset2.dx.abs() - offset1.dx.abs()) > (offset1.dy.abs() - offset2.dy.abs())) {
      //       return -1;
      //     } else {
      //       return 1;
      //     }
      //   } else {
      //     return 0;
      //   }
      // });
      // print('sorted list is : $offsetAndCoordinateGivenDifferenceList');
      // print('unsorted is: $offsetAndCoordinateGivenDifferenceUnsortedList');
      // List<Offset> offsetsNearestToCoordinateOffset = [offsetAndCoordinateGivenDifferenceList.first, offsetAndCoordinateGivenDifferenceList[2]];//the ones with the least differences
      //
      // int sectorContainingCoordinateIndex;
      //
      // if(offsetAndCoordinateGivenDifferenceUnsortedList.indexOf(offsetsNearestToCoordinateOffset[0]) < offsetAndCoordinateGivenDifferenceUnsortedList.indexOf(offsetsNearestToCoordinateOffset[1])) {
      //   sectorContainingCoordinateIndex = offsetAndCoordinateGivenDifferenceUnsortedList.indexOf(offsetsNearestToCoordinateOffset[0]);
      // } else {
      //   sectorContainingCoordinateIndex = offsetAndCoordinateGivenDifferenceUnsortedList.indexOf(offsetsNearestToCoordinateOffset[1]);
      // }
      //
      // sectorContainingCoordinateIndex = offsetAndCoordinateGivenDifferenceUnsortedList.indexOf(offsetsNearestToCoordinateOffset[0]);
      //
      // print('sectorContainingCoordinateIndex: $sectorContainingCoordinateIndex & second index is ${offsetAndCoordinateGivenDifferenceUnsortedList.indexOf(offsetsNearestToCoordinateOffset[1])}');

      // yield MathBlocCoordinateInSectorIdentifierState(sectorContainingCoordinateIndex: sectorContainingCoordinateIndex);
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