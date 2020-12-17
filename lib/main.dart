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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
  Animation<double> dartScaleAnimation;

  void prepareAnimations() {
    dartAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  void _onDartTapped(TapDownDetails tapDownDetails) {
    dartProvider.dartLocalPosition = tapDownDetails.localPosition;
  }

  void _onDartDragged(DragUpdateDetails details) {
    dartProvider.dragPosition = details.localPosition;
  }

  void _onReleaseLeverDragged(DragUpdateDetails dragUpdateDetails) {
    double dy = dragUpdateDetails.localPosition.dy;
    leverProvider.dragPosition = dy;

    final keyContext = leverKey.currentContext;

    if(keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      final height = box.size.height;

      // dartAnimationController.value = (leverProvider.dragPosition/height);

      dartProvider.scaleValue = leverProvider.dragPosition/height;
    }
  }

  var leverProvider, dartProvider;

  GlobalKey leverKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    dartProvider = Provider.of<DartProvider>(context);
    leverProvider = Provider.of<LeverProvider>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Dart App')),
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
                      child: Center(
                        child: DragTarget<String>(
                          builder: (context, acceptedCandidates,
                              rejectedCandidates) {
                            return Image.asset(
                              'dart_board.png',
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 100.0),
                      child: Container(
                        key: leverKey,
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height *
                            0.4, //40% of the screen height
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(400))),
                        child: Consumer<LeverProvider>(
                          child: GestureDetector(
                              onVerticalDragUpdate: _onReleaseLeverDragged,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                              )),
                          builder: (context, provider, child) {
                            double leverPosition = provider.dragPosition;

                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                  8.0, 8.0, 8.0, leverPosition),
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Consumer<DartProvider>(
                  child: GestureDetector(
                      onTapDown: _onDartTapped,
                      child: Dart(
                          dartAnimationController: dartAnimationController)),
                  builder: (context, provider, child) {
                    Offset offset = provider.dragPosition;
                    double scaleValue = provider.scaleValue;

                    return GestureDetector(
                      onPanUpdate: _onDartDragged,
                      child: Container(
                        padding:
                            EdgeInsets.only(top: offset.dy, left: offset.dx),
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
  final AnimationController dartAnimationController;

  Dart({@required this.dartAnimationController});

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
