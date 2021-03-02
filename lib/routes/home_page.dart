import 'dart:html' as html;
import 'dart:ui';

import 'package:fayizali/constants.dart' as constants;

import 'package:fayizali/blocs/circle_sector_coordinates_bloc.dart';
import 'package:fayizali/blocs/math_bloc.dart';
import 'package:fayizali/providers/dart_provider.dart';
import 'package:fayizali/providers/lever_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  List<Offset> sectorEndCoordinatesList;

  bool alertDialogShown = false;

  @override
  void didChangeDependencies() async {
    await loadWallImage();

    callDartBoardSectorCoordinatesBloc();

    mathBloc = Provider.of<MathBloc>(context, listen: false);

    if(!alertDialogShown) {
      showWebsiteUnderConstructionAlertDialogBox();
      alertDialogShown = true;
    }

    super.didChangeDependencies();
  }

  void showWebsiteUnderConstructionAlertDialogBox() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Important Notice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Image.network('https://images.unsplash.com/photo-1590834367872-3297c46273ac?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=934&q=80', width: MediaQuery.of(context).size.width * 0.2, height: MediaQuery.of(context).size.width * 0.2,),
              ),
              Text('Something Great is under Construction.\nBe careful while walking else you might fall (-;',),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                showInstructionsDialogBoxAndInitializePage();// Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showInstructionsDialogBoxAndInitializePage() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.article_outlined, size: MediaQuery.of(context).size.width * 0.2,),
              Text('1. Drag the blue color dart to wherever you want to hit it.\n2. Drag the green color lever and then release it.\n3. The dart will get released.\n\n- The yellowish type colored sectors in the dart board are for General Info Page.\n- The black colored sectors are for Computer Languages Page.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                dartBoardAnimationController.forward();
              },
            ),
          ],
        );
      },
    );
  }

  void captureSectorIndexFromMathBlocAndNavigate() async {
    await for (MathBlocState state in mathBloc) {
      if(state is MathBlocCoordinateInSectorIdentifierState) {

        if(state.sectorContainingCoordinateIndex == -1) {
          //TODO: implement the logic for resetting everything

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.fast_rewind),
                    ),
                    Text('Please hit the dart inside the dartboard'),
                  ]
                )
            )
          ).closed.then((value) => html.window.location.reload());


        } else {
          var route = constants.routesListAccordingToDartBoard[state.sectorContainingCoordinateIndex];

          if (route == null) {
            throw Exception('Route name not found');
          } else {
            //everything is alright
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => route
                )
            );
          }
        }
      } else {
        print('Unknown state was emitted');
      }
    }
  }

  void callDartBoardSectorCoordinatesBloc() async {

    Size windowSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    CircleSectorCoordinatesBloc circleSectorCoordinatesBloc = BlocProvider.of<CircleSectorCoordinatesBloc>(context);


    circleSectorCoordinatesBloc.add(CircleSectorEndCoordinatesIdentifierEvent(
        radius: (windowSize.height - (windowSize.height * 0.02 * 2)) / 2,
        numberOfSectors: 20,
        center: Offset(windowSize.width / 2, windowSize.height / 2)));

    await for(CircleSectorCoordinatesState state in circleSectorCoordinatesBloc) {
      if (state is CircleSectorEndCoordinatesIdentifiedState) {
        sectorEndCoordinatesList = state.sectorEndCoordinatesList;

      }
    }
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
    AnimationController(vsync: this, duration: Duration(milliseconds: 6000));

    dartBoardSlideAnimation = Tween(begin: -5.0, end: 0.0).animate(
        CurvedAnimation(
            parent: dartBoardAnimationController,
            curve: Interval(0.25, 0.45, curve: Curves.bounceOut)));

    leverDartSlideAnimation =
        Tween<Offset>(begin: Offset(0.0, -5.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(
                parent: dartBoardAnimationController,
                curve: Interval(0.5, 0.7, curve: Curves.elasticOut)));

    dartAnimationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 400))
      ..addStatusListener((status) {
        print('Status is: $status');
        if (status == AnimationStatus.completed) {
          mathBloc.add(CoordinateInSectorIdentifierBlocEvent(
              sectorEndCoordinatesList: sectorEndCoordinatesList,
              coordinate: dartProvider.dragPosition,
              center: Offset(MediaQuery.of(context).size.width / 2,
                  MediaQuery.of(context).size.height / 2)));
          captureSectorIndexFromMathBlocAndNavigate();
        }
      });
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
        left: offset.dx - ((MediaQuery.of(context).size.width * 0.03) / 2),
        top: offset.dy - ((MediaQuery.of(context).size.height * 0.03) / 2),
        child: GestureDetector(
          onPanUpdate: _onDartDragged,
          child: ScaleTransition(
            scale: Tween(begin: scaleValue, end: 1.5)
                .animate(dartAnimationController),
            child: Dart(),
          ),
        ));
  }

  Widget _renderBoard({@required double screenWidth, @required double screenHeight}) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02), //TODO: Remove this hardcoding
      child: AnimatedBuilder(
        animation: dartBoardSlideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
                0,
                dartBoardSlideAnimation.value *
                    (screenHeight / 4)),
            child: child,
          );
        },
        child: Transform.rotate(//Just to make the sector ends configurable
          angle: 2.02,
          child: Image.asset(
            'assets/dart_board.png',
          ),
        ),
      ),
    );
  }

  Widget _renderLever({@required double screenWidth, @required double screenHeight}) {
    return SlideTransition(
      position: leverDartSlideAnimation,
      child: Container(
        key: leverKey,
        width: 50.0,
        //TODO: Remove this hardcoding
        height: screenHeight / 2.5,
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

  @override
  Widget build(BuildContext context) {

    dartProvider = Provider.of<DartProvider>(context);
    leverProvider = Provider.of<LeverProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {

        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        return Scaffold(
          body: Stack(children: <Widget>[
            wallImage,
            Align(alignment: Alignment.center, child: _renderBoard(screenWidth: screenWidth, screenHeight: screenHeight)),
            _renderDart(),
            Positioned(
              right: screenWidth * 0.04,
              bottom: screenHeight * 0.05,
              child: _renderLever(screenWidth: screenWidth, screenHeight: screenHeight),
            ),
            // TODO: Remove the widget below as it is only for testing
            // BlocBuilder<CircleSectorCoordinatesBloc, CircleSectorCoordinatesState>(
            //     builder: (context, state) {
            //       if (state is CircleSectorEndCoordinatesIdentifiedState) {
            //         return Stack(
            //             alignment: Alignment.center,
            //             children: state.sectorEndCoordinatesList
            //                 .map<Widget>((e) => Positioned(
            //               left: e.dx - 10,
            //               top: e.dy - 10,
            //               child: Container(
            //                 width: 20,
            //                 height: 20,
            //                 alignment: Alignment.center,
            //                 decoration: BoxDecoration(
            //                     shape: BoxShape.circle, color: Colors.yellow),
            //                 child: Text(state.sectorEndCoordinatesList
            //                     .indexOf(e)
            //                     .toString()),
            //               ),
            //             ))
            //                 .toList());
            //       } else {
            //         return Container();
            //       }
            //     })
          ]),
        );
      }
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
    double screenHeight = MediaQuery.of(context).size.height;

    return Image.asset(
      'assets/dart.png',
      width: screenHeight * 0.03,
      height: screenHeight * 0.03,
    );
  }
}