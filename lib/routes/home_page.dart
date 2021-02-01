import 'dart:ui';

import 'package:fayizali/blocs/circle_sector_coordinates_bloc.dart';
import 'package:fayizali/blocs/math_bloc.dart';
import 'package:fayizali/providers/dart_provider.dart';
import 'package:fayizali/providers/lever_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Image wallImage;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    wallImage = Image.asset(
      'assets/wall.jpg',
      fit: BoxFit.fill,
      width: window.physicalSize.width,
      height: window.physicalSize.height,
    );
  }

  MathBloc mathBloc;
  CircleSectorCoordinatesBloc circleSectorCoordinatesBloc;

  @override
  void didChangeDependencies() async {
    await loadWallImage();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    dartAnimationController.dispose();
  }

  double top = 0.0;
  double left = 0.0;

  AnimationController dartAnimationController;

  AnimationController dartBoardAnimationController;
  Animation<double> dartBoardSlideAnimation;

  Animation<Offset> leverDartSlideAnimation;

  void prepareAnimations() {
    dartBoardAnimationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 6000))
      ..forward();

    dartBoardSlideAnimation = Tween(begin: -5.0, end: 0.0).animate(
        CurvedAnimation(
            parent: dartBoardAnimationController,
            curve: Interval(0.3, 0.5, curve: Curves.bounceOut)));

    leverDartSlideAnimation =
        Tween<Offset>(begin: Offset(0.0, -5.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(
                parent: dartBoardAnimationController,
                curve: Interval(0.55, 0.75, curve: Curves.elasticOut)));

    dartAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  void _onDartDragged(DragUpdateDetails details) {
    dartProvider.dragPosition = details.globalPosition;
  }

  double leverContainerHeight;

  void _onReleaseLeverDragged(DragUpdateDetails dragUpdateDetails) {
    double dy = dragUpdateDetails.localPosition.dy;
    leverProvider.dragPosition = dy;

    final keyContext = leverKey.currentContext;

    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      leverContainerHeight = box.size.height;

      dartProvider.scaleValue =
          leverProvider.dragPosition / leverContainerHeight;
    }
  }

  var leverProvider, dartProvider;

  GlobalKey leverKey = GlobalKey();

  Future<void> loadWallImage() async {
    await precacheImage(wallImage.image, context);
  }

  Widget _renderDart() {
    DartProvider dartProvider = Provider.of<DartProvider>(context);
    Offset offset = dartProvider.dragPosition;
    double scaleValue = dartProvider.scaleValue;
    return Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
          onPanUpdate: _onDartDragged,
          child: ScaleTransition(
            scale: Tween(begin: scaleValue, end: 1.5)
                .animate(dartAnimationController),
            child: Dart(),
          ),
        ));
  }

  Widget _renderBoard() {
    return Padding(
      padding: const EdgeInsets.all(40.0), //TODO: Remove this hardcoding
      child: AnimatedBuilder(
        animation: dartBoardSlideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
                0,
                dartBoardSlideAnimation.value *
                    (MediaQuery.of(context).size.height / 4)),
            child: child,
          );
        },
        child: Transform.rotate(
          angle: 1.97,
          child: Image.asset(
            'assets/dart_board.png',
          ),
        ),
      ),
    );
  }

  Widget _renderLever() {
    return SlideTransition(
      position: leverDartSlideAnimation,
      child: Container(
        key: leverKey,
        width: 50.0,
        //TODO: Remove this hardcoding
        height: MediaQuery.of(context).size.height / 2.5,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(400))),
        child: Consumer<LeverProvider>(
          child: GestureDetector(
              onVerticalDragUpdate: _onReleaseLeverDragged,
              onVerticalDragEnd: (DragEndDetails details) {
                leverProvider.leverDragged = true;

                dartAnimationController.forward();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
              )),
          builder: (context, provider, child) {
            double leverPosition = provider.dragPosition;
            bool leverDragged = provider.leverDragged;

            return AnimatedPadding(
              duration: leverDragged == true
                  ? dartAnimationController.duration
                  : Duration.zero,
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, leverPosition),
              child: child,
            );
          },
        ),
      ),
    );
  }

  List<Offset> sectorEndCoordinatesList;

  @override
  Widget build(BuildContext context) {
    Size windowSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    circleSectorCoordinatesBloc =
        Provider.of<CircleSectorCoordinatesBloc>(context, listen: false);
    mathBloc = Provider.of<MathBloc>(context, listen: false);

    circleSectorCoordinatesBloc.add(CircleSectorEndCoordinatesIdentifierEvent(
        radius: (windowSize.height - 250) /2,
        numberOfSectors: 20,
        center: Offset(windowSize.width / 2 - 10, windowSize.height / 2 - 10)));

    circleSectorCoordinatesBloc.listen((state) {
      if (state is CircleSectorEndCoordinatesIdentifiedState) {
        sectorEndCoordinatesList = state.sectorEndCoordinatesList;
        print('state yielded is: $sectorEndCoordinatesList');
      }
    });

    dartProvider = Provider.of<DartProvider>(context);
    leverProvider = Provider.of<LeverProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTapUp: (TapUpDetails tapUpDetails) {
          Offset tapPosition = tapUpDetails.globalPosition;
          print('tapped position is: $tapPosition');
          mathBloc.add(
              CoordinateInSectorIdentifierBlocEvent(
                sectorEndCoordinatesList: sectorEndCoordinatesList,
                coordinate: tapPosition,
                center: Offset(windowSize.width / 2, windowSize.height / 2)
              )
          );
        },
        child: Stack(children: <Widget>[
          wallImage,
          Align(alignment: Alignment.center, child: _renderBoard()),
          _renderDart(),
          Positioned(
            right: 40, //TODO: Remove this hardcoding
            bottom: 40, //TODO: Remove this hardcoding
            child: _renderLever(),
          ),
          BlocBuilder<CircleSectorCoordinatesBloc,
              CircleSectorCoordinatesState>(builder: (context, state) {
            if (state is CircleSectorEndCoordinatesIdentifiedState) {
              return Stack(
                alignment: Alignment.center,
                children:
              state.sectorEndCoordinatesList
                  .map<Widget>((e) => Positioned(
                left: e.dx - 10,
                top: e.dy - 10,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
                  child: Text(state.sectorEndCoordinatesList.indexOf(e).toString()),
                ),
              )).toList()
              );
            } else {
              return Text('Not found');
            }
          })
        ]),
      ),
    );
  }
}

class Dart extends StatefulWidget {
  @override
  _DartState createState() => _DartState();
}

class _DartState extends State<Dart> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Image.asset(
      'dart.png',
      width: screenWidth * 0.02,
      height: screenWidth * 0.02,
    );
  }
}

class DartBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(300, 300), 270, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
