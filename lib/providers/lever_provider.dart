import 'package:flutter/widgets.dart';

class LeverProvider with ChangeNotifier {
  double _dragPosition = 8.0;

  get dragPosition => _dragPosition;

  set dragPosition(double dragPosition) {
    if(dragPosition.isNegative) {
      _dragPosition = dragPosition * -1;
    } else {
      _dragPosition = 8.0;
    }

    notifyListeners();

  }

  bool _leverDragged = false;

  get leverDragged => _leverDragged;

  set leverDragged(bool leverDragged) {
    _leverDragged = leverDragged;
    _dragPosition = 8.0;
    notifyListeners();
  }
}