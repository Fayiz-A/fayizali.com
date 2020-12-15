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
        providers: [ChangeNotifierProvider(create: (_) => LeverProvider())],
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
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

    dartScaleAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: dartAnimationController,
    );
  }

  void _onReleaseLeverDragged(DragUpdateDetails dragUpdateDetails) {
    double dy = dragUpdateDetails.localPosition.dy;
    leverProvider.dragPosition = dy;

  }

  var leverProvider;

  @override
  Widget build(BuildContext context) {

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
                          builder: (context, acceptedCandidates, rejectedCandidates) {
                            return Image.asset('dart_board.png', width: MediaQuery.of(context).size.width/2, height: MediaQuery.of(context).size.width/2,);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 100.0),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height*0.4,//40% of the screen height
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(400))
                        ),
                        child: Consumer<LeverProvider>(
                          child: GestureDetector(
                              onVerticalDragUpdate: _onReleaseLeverDragged,
                              child: CircleAvatar(backgroundColor: Colors.white,)
                          ),
                          builder: (context, provider, child) {
                            double leverPosition = provider.dragPosition;

                            return Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, leverPosition ),
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Draggable<String>(
                  data: 'dart',
                  child: Container(
                    padding: EdgeInsets.only(top: top, left: left),
                    child: ScaleTransition(
                      scale: Tween(begin: 5.0, end: 1.5).animate(dartAnimationController),
                      child: Dart(dartAnimationController: dartAnimationController),
                    ),
                  ),
                  feedback: Container(
                    padding: EdgeInsets.only(top: top, left: left),
                    child: ScaleTransition(
                      scale: Tween(begin: 5.0, end: 1.5).animate(dartAnimationController),
                      child: Dart(dartAnimationController: dartAnimationController),
                    ),
                  ),
                  childWhenDragging: Container(
                    padding: EdgeInsets.only(top: top, left: left),
                    child: ScaleTransition(
                      scale: Tween(begin: 5.0, end: 1.5).animate(dartAnimationController),
                      child: Dart(dartAnimationController: dartAnimationController),
                    ),
                  ),
                  onDraggableCanceled: (velocity, offset) {},
                  onDragEnd: (details) {
                    setState(() {
                      double dx = details.offset.dx;
                      double dy = details.offset.dy;

                      left = dx + left;
                      top = dy + top;
                      print('left: $left');
                      print('top: $top');
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Release'),
                  onPressed: () {
                    dartAnimationController.forward();
                  },
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
    double screenWidth =  MediaQuery.of(context).size.width;

    return Image.asset(
      'dart.png',
      width: screenWidth*0.05,
      height: screenWidth*0.05,
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
