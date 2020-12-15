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

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Dart App')),
        body: Row(
          children: [
            Stack(
              children: [
                DragTarget<String>(
                  builder: (context, acceptedCandidates, rejectedCandidates) {
                    return Image.asset('dart_board.png', width: 700, height: 700,);
                  },
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
    return Image.asset(
      'dart.png',
      width: 90,
      height: 90,
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
