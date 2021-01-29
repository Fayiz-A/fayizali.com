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
    }
  }
}

abstract class MathBlocState {}

class MathBlocInitialState extends MathBlocState {}

class MathBlocAngleConversionState extends MathBlocState {
  final double angle;

  MathBlocAngleConversionState({@required this.angle});
}