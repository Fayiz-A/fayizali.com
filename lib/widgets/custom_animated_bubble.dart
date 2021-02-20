import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:fayizali/blocs/bubble_touch_bloc.dart';
import 'package:fayizali/blocs/color_bloc.dart';
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

          // _bubbleOffsetController.duration = _generateRandomDurationInMS();
        }
      })
      ..forward();

    _bubbleInformationTextController = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds: (constants.bubbleStopDurationInMS / 2).round()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateRandomPathForBubble(index: widget.index);
    _generateRandomColorForBubble(index: widget.index);
  }

  @override
  void dispose() {
    _bubbleOffsetController.dispose();
    _bubbleInformationTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TouchBloc, TouchState>(
        builder: (context, bubbleTouchState) {
          if (bubbleTouchState is BubbleClickedState) {
            _bubbleOffsetController.stop(canceled: false);
            int bubblePauseDuration = constants.bubbleStopDurationInMS;

            if (bubbleTouchState.index == widget.index) {
              Timer(Duration(milliseconds: bubblePauseDuration), () {
                _bubbleOffsetController.forward(from: 0.0);
              });
              Timer(Duration(
                  milliseconds: (bubblePauseDuration / 2).round()), () {
                _bubbleInformationTextController.forward(from: 0.0);
              });
            }
          }
          // else if (bubbleTouchState is BubbleResumeState) print('');

          return BlocBuilder<RandomPathBloc, RandomPathState>(
              buildWhen: (previousState, state) {
                if (state is RandomPathGeneratedState && state.index == widget.index) {
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
                      ? BlocBuilder<ColorBloc, ColorState>(
                      buildWhen: (previousState, bubbleColorState) {
                        if(bubbleColorState is RandomColorGeneratedState) {
                          // print('Color State with index: ${bubbleColorState.index} & with color: ${bubbleColorState.randomColor}');
                        }
                        if (widget.index == bubbleColorState.index) {
                          return true;
                        } else {
                          return false;
                        }
                      }, builder: (BuildContext context, ColorState state) {
                    if (state is RandomColorGeneratedState) {
                      return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: HexColor.fromHex(state.randomColor)
                                    .withOpacity(0.4),
                                width: 2.0),
                            shape: BoxShape.circle,
                            color: HexColor.fromHex(state.randomColor)
                                .withOpacity(0.4),
                          ),
                          child: Center(
                            child: Text('${state.index}'),
                          ));
                    } else {
                      return Text(
                          'Unknown State Generated for a Bubble Color');
                    }
                  })
                      : AnimatedBuilder(
                    animation: _bubbleInformationTextController,
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Text(
                          'I am a text',
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
    TouchBloc bubbleTouchBloc = Provider.of<TouchBloc>(context, listen: false);

    bubbleTouchBloc.add(BubbleTouchEvent(
        touchOffset: tapUpDetails.globalPosition, index: index));
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

  void _generateRandomColorForBubble({@required int index}) {
    ColorBloc colorBloc = Provider.of<ColorBloc>(context, listen: false);

    colorBloc.add(RandomColorGeneratorEvent(index: index));
    // String colorHexValues = 'abc123';
    //
    // List<String> colorHexValuesList = colorHexValues.split('');
    // List<String> randomColorValuesList = [];
    // randomColorValuesList.add('#');
    //
    // for(int codeIndex = 0; codeIndex < colorHexValuesList.length; codeIndex++) {
    //   math.Random random = math.Random();
    //   int randomIndex = random.nextInt(colorHexValuesList.length - 1).abs();
    //
    //   randomColorValuesList.add(colorHexValuesList[randomIndex]);
    // }
    //
    // String randomColor = randomColorValuesList.join();
    //
    // return randomColor;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
