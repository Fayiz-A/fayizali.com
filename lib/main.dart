// // //custom packages
// // import 'package:fayizali/routes/home_page.dart';
// //
// // //other packages
// // import 'package:flutter/material.dart';
// //
// // void main() => runApp(MyApp());
// //
// // class MyApp extends StatelessWidget {
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Fayiz Ali',
// //       home: HomePage(),
// //     );
// //   }
// //
// // }

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fayizali/providers/dart_provider.dart';
import 'package:fayizali/providers/lever_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => ThemeData(
        primarySwatch: Colors.indigo,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LeverProvider()),
          ChangeNotifierProvider(create: (_) => DartProvider())
        ],
        child: MaterialApp(
          title: 'Fayiz Ali',
          theme: theme,
          home: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

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
        AnimationController(vsync: this, duration: Duration(milliseconds: 3000))
          ..forward();

    dartBoardSlideAnimation = Tween(begin: -5.0, end: 0.0).animate(
        CurvedAnimation(
            parent: dartBoardAnimationController, curve: Interval(0.0, 0.5, curve: Curves.bounceOut)));

    leverDartSlideAnimation =
        Tween<Offset>(begin: Offset(0.0, -5.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(
                parent: dartBoardAnimationController, curve: Interval(0.4, 0.8, curve: Curves.elasticOut)));

    dartAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  void _onDartDragged(DragUpdateDetails details) {
    dartProvider.dragPosition = details.localPosition;
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

  @override
  Widget build(BuildContext context) {
    dartProvider = Provider.of<DartProvider>(context);
    leverProvider = Provider.of<LeverProvider>(context);

    return Scaffold(
        body: Row(
      children: [
        Stack(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: AnimatedBuilder(
                      animation: dartBoardSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              0,
                              dartBoardSlideAnimation.value *
                                  ((MediaQuery.of(context).size.height / 4))),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'dart_board.png',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 40, 100),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: SlideTransition(
                      position: leverDartSlideAnimation,
                      child: Container(
                        key: leverKey,
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
                                // leverAnimationController.reverse(from: 1.0);
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
                              padding: EdgeInsets.fromLTRB(
                                  8.0, 8.0, 8.0, leverPosition),
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Consumer<DartProvider>(
              child: Dart(),
              builder: (context, provider, child) {
                Offset offset = provider.dragPosition;
                double scaleValue = provider.scaleValue;

                return GestureDetector(
                  onPanUpdate: _onDartDragged,
                  child: Container(
                    padding: EdgeInsets.only(top: offset.dy, left: offset.dx),
                    child: ScaleTransition(
                      scale: Tween(begin: scaleValue, end: 1.5)
                          .animate(dartAnimationController),
                      child: child,
                    ),
                  ),
                );
              },
            ),
            //TODO: Remove the widget below as it is only for ease of testing
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Release'),
                onPressed: () {
                  dartAnimationController.forward();
                },
              ),
            )
          ],
        ),
      ],
    ));
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
