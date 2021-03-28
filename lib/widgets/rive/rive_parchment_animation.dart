import 'package:fayizali/blocs/rive_parchment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

class RiveParchmentAnimation extends StatefulWidget {
  final double width;
  final double height;

  RiveParchmentAnimation({@required this.width, @required this.height});

  @override
  _RiveParchmentAnimationState createState() => _RiveParchmentAnimationState();
}

class _RiveParchmentAnimationState extends State<RiveParchmentAnimation> {
  final riveFileName = 'parchment.riv';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    RiveParchmentBloc riveParchmentBloc = BlocProvider.of<RiveParchmentBloc>(context);
    riveParchmentBloc.add(RiveParchmentLoadEvent(fileName: 'parchment.riv'));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocBuilder<RiveParchmentBloc, RiveParchmentState>(
        builder: (BuildContext context, RiveParchmentState state) {

          if(state is RiveParchmentLoadedState || state is RiveParchmentUnfoldedState) {
            return SizedBox(
              width: widget.width ?? screenSize.width * 0.1,
              height: widget.height ?? screenSize.height * 0.5,
              child: Rive(
                artboard: state.artBoard,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return Container();
          }
        }
    );
  }
}
