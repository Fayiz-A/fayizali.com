
import 'package:flutter/widgets.dart';

class DartProvider with ChangeNotifier {

  Offset _dragPosition = Offset(WidgetsBinding.instance.window.physicalSize.width * 0.1, WidgetsBinding.instance.window.physicalSize.height * 0.1);

  Offset _dartLocalPosition = Offset(0.0, 0.0);

  get dragPosition => _dragPosition;

  set dragPosition(Offset dragPosition) {
    dragPosition = Offset(dragPosition.dx - _dartLocalPosition.dx,
        dragPosition.dy - _dartLocalPosition.dy);

    if (dragPosition.dx.isNegative || dragPosition.dy.isNegative) {
    } else {
      _dragPosition = dragPosition;
    }

    notifyListeners();
  }

  set dartLocalPosition(dartLocalPosition) =>
      _dartLocalPosition = dartLocalPosition;

  double initialScaleValue = 5.0;

  double _scaleValue = 5.0;

  get scaleValue => _scaleValue;

  set scaleValue(double scaleValue) {
    _scaleValue = initialScaleValue + (scaleValue * initialScaleValue);
    notifyListeners();
  }
}
