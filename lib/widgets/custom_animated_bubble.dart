import 'dart:math' as math;
import 'dart:ui';

import 'package:fayizali/blocs/bubble_touch_bloc.dart';
import 'package:fayizali/blocs/random_path_bloc.dart';
import 'package:fayizali/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CustomAnimatedBubble extends StatefulWidget {
  final int index;

  CustomAnimatedBubble({@required this.index});

  @override
  _CustomAnimatedBubbleState createState() => _CustomAnimatedBubbleState();
}

class _CustomAnimatedBubbleState extends State<CustomAnimatedBubble>
    with SingleTickerProviderStateMixin {
  AnimationController _bubbleOffsetController;

  @override
  void initState() {
    super.initState();

    _bubbleOffsetController = AnimationController(
      vsync: this,
      duration: _generateRandomDurationInMS(),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // print('repeating the animation');
          _generateRandomPathForBubble(index: widget.index);
          _bubbleOffsetController.forward(from: 0.0);

          _bubbleOffsetController.duration = _generateRandomDurationInMS();
        }
      })
      ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateRandomPathForBubble(index: widget.index);
  }

  @override
  void dispose() {
    _bubbleOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BubbleTouchBloc, BubbleTouchState>(
      builder: (context, bubbleTouchState) {
        if(bubbleTouchState is BubbleClickedState) _bubbleOffsetController.stop(canceled: false);

        return BlocBuilder<RandomPathBloc, RandomPathState>(
            buildWhen: (previousState, state) {
              if (state is RandomPathGeneratedState && state.index == widget.index) {
                return true;
              } else {
                return false;
              }
            }, builder: (BuildContext context, RandomPathState state) {
          if (state is RandomPathGeneratedState) {
            if(bubbleTouchState is! BubbleClickedState) _bubbleOffsetController.forward();
            return AnimatedBuilder(
              animation: _bubbleOffsetController,
              child: GestureDetector(
                onTapUp: _onBubbleTapped,
                child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withOpacity(0.4),
                    ),
                    child: Center(
                      child: Text('${widget.index}'),
                    )),
              ),
              builder: (BuildContext context, Widget child) {
                Path path = state.path;
                double animValue = _bubbleOffsetController.value;
                return Stack(children: [
                  Positioned(
                      left: _getPathCurveDetails(
                        path: path,
                        animValue: animValue,
                      ).dx,
                      top: _getPathCurveDetails(
                        path: path,
                        animValue: animValue,
                      ).dy,
                      child: child)
                ]);
              },
            );
          } else {
            return Text('Unknown State');
          }
        });
      }
    );
  }

  Offset _getPathCurveDetails({
    @required Path path,
    @required double animValue,
  }) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    double valueToTranslateTo = pathMetric.length * animValue;
    Tangent positionDetailsForBubble =
    pathMetric.getTangentForOffset(valueToTranslateTo);
    return positionDetailsForBubble.position;
  }

  void _onBubbleTapped(TapUpDetails tapUpDetails) {
    _bubbleOffsetController.stop();
    print('Stopped');
    BubbleTouchBloc bubbleTouchBloc =
    Provider.of<BubbleTouchBloc>(context, listen: false);

    bubbleTouchBloc
        .add(BubbleClickedEvent(touchOffset: tapUpDetails.globalPosition));
  }

  void _generateRandomPathForBubble({@required int index}) {
    RandomPathBloc randomPathBloc =
    Provider.of<RandomPathBloc>(context, listen: false);

    randomPathBloc.add(RandomPathGeneratorEvent(
        windowSize: MediaQuery.of(context).size, index: index));
  }

  Duration _generateRandomDurationInMS() {
    math.Random random = math.Random();
    int minMilliSeconds = constants.bubbleAnimationMinDurationInMS;
    int maxMilliSeconds = constants.bubbleAnimationMaxDurationInMS;
    int randomMilliSeconds =
        random.nextInt(maxMilliSeconds - minMilliSeconds) + minMilliSeconds;
    return Duration(milliseconds: randomMilliSeconds);
  }
}