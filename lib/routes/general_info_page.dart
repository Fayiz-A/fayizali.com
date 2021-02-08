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

  List<Path> _pathList = [];
  RandomPathBloc randomPathBloc;

  @override
  void initState() {
    super.initState();
    _bubbleOffsetController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 5000),
    )
      ..forward()
      ..addListener(() {
        if(_bubbleOffsetController.value == 1.0 && _pathList.isNotEmpty && randomPathBloc != null) {

          randomPathBloc.add(PathRelatedToPreviousPathsGeneratorEvent(windowSize: MediaQuery.of(context).size, numberOfPaths: 20, pathList: _pathList));
          _bubbleOffsetController.forward(from: 0.0);

        }
      });
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
                _pathList = pathList;//for global access to this path list
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
    randomPathBloc = Provider.of<RandomPathBloc>(context, listen: false);

    randomPathBloc.add(RandomPathGeneratorEvent(windowSize: MediaQuery.of(context).size, numberOfPaths: 20));

  }

  Offset _getPathCurveDetails({ @required Path path, @required double animValue}) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    double valueToTranslateTo = pathMetric.length * animValue;
    Tangent positionDetailsForBubble = pathMetric.getTangentForOffset(valueToTranslateTo);
    return positionDetailsForBubble.position;
  }
}
