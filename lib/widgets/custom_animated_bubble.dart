import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:fayizali/blocs/bubble_touch_bloc.dart';
import 'package:fayizali/blocs/integrators/general_info_page/bubble_color_generator.dart';
import 'package:fayizali/blocs/random_path_bloc.dart';
import 'package:fayizali/classes/information.dart';
import 'package:fayizali/constants.dart' as constants;
import 'package:fayizali/extensions/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CustomAnimatedBubble extends StatefulWidget {
  final int index;
  final Map<String, String> bubbleDisplayInformation;

  CustomAnimatedBubble({@required this.index, @required this.bubbleDisplayInformation,});

  @override
  _CustomAnimatedBubbleState createState() => _CustomAnimatedBubbleState();
}

class _CustomAnimatedBubbleState extends State<CustomAnimatedBubble>
    with TickerProviderStateMixin {
  AnimationController _bubbleOffsetController;
  AnimationController _bubbleInformationTextController;

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
          _generateRandomColorForBubble(index: widget.index);
          _bubbleOffsetController.forward(from: 0.0);

          _bubbleOffsetController.duration = _generateRandomDurationInMS();
        }
      })
      ..forward();

    _bubbleInformationTextController = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: (constants.bubbleStopDurationInMS / 2).round()))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _bubbleOffsetController.forward(from: 0.0);
        }
      });
  }

  RandomPathBloc randomPathBloc;
  BubbleColorGeneratorBloc bubbleColorBloc;
  TouchBloc bubbleTouchBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    randomPathBloc = Provider.of<RandomPathBloc>(context, listen: false);
    bubbleColorBloc =
        BlocProvider.of<BubbleColorGeneratorBloc>(context);
    bubbleTouchBloc = Provider.of<TouchBloc>(context, listen: false);

    _generateRandomPathForBubble(index: widget.index);
    _generateRandomColorForBubble(index: widget.index);
  }

  @override
  void dispose() {
    _bubbleOffsetController.dispose();
    _bubbleInformationTextController.dispose();
    super.dispose();
  }

  String bubbleColor;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      double screenHeight = constraints.maxHeight;

      return BlocBuilder<TouchBloc, TouchState>(
          builder: (context, bubbleTouchState) {
            if (bubbleTouchState is BubbleClickedState) {
              _bubbleOffsetController.stop(canceled: false);
              int bubblePauseDuration = constants.bubbleStopDurationInMS;

              if (bubbleTouchState.index == widget.index) {
                // Timer(Duration(milliseconds: bubblePauseDuration), () {
                // });
                Timer(Duration(milliseconds: (bubblePauseDuration / 2).round()),
                        () {
                      _bubbleInformationTextController.forward(from: 0.0);
                    });
              }
            }
            // else if (bubbleTouchState is BubbleResumeState) print('');

            return BlocBuilder<RandomPathBloc, RandomPathState>(
                buildWhen: (previousState, state) {
                  if (state is RandomPathGeneratedState &&
                      state.index == widget.index) {
                    return true;
                  } else {
                    return false;
                  }
                }, builder: (BuildContext context, RandomPathState state) {
              if (state is RandomPathGeneratedState) {
                bool bubbleTouched = bubbleTouchState is BubbleClickedState;
                if (!bubbleTouched) _bubbleOffsetController.forward();
                return AnimatedBuilder(
                  animation: _bubbleOffsetController,
                  child: GestureDetector(
                    onTapUp: (TapUpDetails tapUpDetails) => !bubbleTouched
                        ? _onBubbleTapped(
                        tapUpDetails: tapUpDetails, index: widget.index)
                        : null,
                    child: !bubbleTouched || widget.index != bubbleTouchState.index
                        ? BlocBuilder<BubbleColorGeneratorBloc,
                        BubbleColorGeneratedState>(
                      // buildWhen: (previousState, bubbleColorState) {
                      //   if(bubbleColorState is BubbleColorGeneratedState && widget.index == bubbleColorState.index) {
                      //       return true;
                      //   } else {
                      //     return false;
                      //   }
                      //
                      // },
                        builder: (BuildContext context,
                            BubbleColorGeneratedState colorState) {

                          if (colorState.index == widget.index) {
                            bubbleColor = colorState.color;
                          }

                          if (bubbleColor != null) {
                            return Container(
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: HexColor.fromHex(bubbleColor)
                                          .withOpacity(0.4),
                                      width: 2.0),
                                  shape: BoxShape.circle,
                                  color: HexColor.fromHex(bubbleColor)
                                      .withOpacity(0.4),
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.bubbleDisplayInformation.keys.first}',//map of one key only
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ));
                          } else {
                            return Container();
                          }
                        })
                        : AnimatedBuilder(
                      animation: _bubbleInformationTextController,
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: SelectableText(
                            '${widget.bubbleDisplayInformation.values.first}',//map of one value only
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      builder: (context, child) {
                        return Transform.translate(
                            offset: Offset(
                                0,
                                _bubbleInformationTextController.value *
                                    MediaQuery.of(context).size.height),
                            child: child);
                      },
                    ),
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
          });
    });
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

  void _onBubbleTapped(
      {@required TapUpDetails tapUpDetails, @required int index}) {
    bubbleTouchBloc.add(BubbleTouchEvent(
        touchOffset: tapUpDetails.globalPosition, index: index));
  }

  void _generateRandomPathForBubble({@required int index}) {
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

  void _generateRandomColorForBubble({@required int index}) {
    // Timer(Duration(milliseconds: 2000), () {
      bubbleColorBloc.add(BubbleColorGeneratorEvent(index: index));

    // });
  }
}
