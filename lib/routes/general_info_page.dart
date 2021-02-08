import 'dart:math' as math;
import 'dart:ui';

import 'package:fayizali/blocs/random_path_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class GeneralInfoPage extends StatefulWidget {
  @override
  _GeneralInfoPageState createState() => _GeneralInfoPageState();
}

class _GeneralInfoPageState extends State<GeneralInfoPage> with SingleTickerProviderStateMixin {
  AnimationController _bubbleOffsetController;

  @override
  void initState() {
    super.initState();
    _bubbleOffsetController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000)
    )..forward();
  }

  @override
  void didChangeDependencies() {
    getAllPathsFromBloc();

    super.didChangeDependencies();

  }

  @override
  void dispose() {
    _bubbleOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bubbleOffsetController,
      // child:
      builder: (BuildContext context, Widget child) {
        return BlocBuilder<RandomPathBloc, RandomPathState>(

            builder: (BuildContext context, RandomPathState state) {
              if(state is RandomPathGeneratedState) {
                List<Path> pathList = state.pathList;
                double animValue = _bubbleOffsetController.value;
                return Stack(
                  children: [
                    for(int index = 0; index<20; index++)
                      Positioned(
                        left: _getPathCurveDetails(path: pathList[index], animValue: animValue).dx,
                        top: _getPathCurveDetails(path: pathList[index], animValue: animValue).dy,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent.withOpacity(0.4),
                          ),
                        ),
                      )
                  ],
                );
              } else {
                return Text('Unknown State');
              }
            }
        );
      },
    );
  }

  void getAllPathsFromBloc() {
    RandomPathBloc randomPathBloc = Provider.of<RandomPathBloc>(context, listen: false);

    randomPathBloc.add(RandomPathGeneratorEvent(windowSize: MediaQuery.of(context).size, numberOfPaths: 20));

  }

  Offset _getPathCurveDetails({ @required Path path, @required double animValue}) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    double valueToTranslateTo = pathMetric.length * (animValue / 2);
    Tangent positionDetailsForBubble = pathMetric.getTangentForOffset(valueToTranslateTo);
    return positionDetailsForBubble.position;
  }
}
