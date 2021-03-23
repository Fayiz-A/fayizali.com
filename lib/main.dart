import 'package:fayizali/blocs/bubble_touch_bloc.dart';
import 'package:fayizali/blocs/circle_sector_coordinates_bloc.dart';
import 'package:fayizali/blocs/color_bloc.dart';
import 'package:fayizali/blocs/integrators/general_info_page/bubble_color_generator.dart';
import 'package:fayizali/blocs/math_bloc.dart';
import 'package:fayizali/blocs/random_path_bloc.dart';
import 'package:fayizali/blocs/url_bloc.dart';
import 'package:fayizali/providers/dart_provider.dart';
import 'package:fayizali/providers/lever_provider.dart';
import 'package:fayizali/routes/general_info_page.dart';
import 'package:fayizali/routes/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  // setPathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LeverProvider()),
        ChangeNotifierProvider(create: (_) => DartProvider()),
        BlocProvider(create: (_) => RandomPathBloc()),
        BlocProvider(create: (_) => UrlBloc()),
        BlocProvider(create: (_) => MathBloc()),
        BlocProvider(create: (_) => CircleSectorCoordinatesBloc()),
        BlocProvider(create: (_) => TouchBloc()),
        BlocProvider(create: (_) => ColorBloc()),
        BlocProvider(create: (_) => BubbleColorGeneratorBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fayiz Ali',
        theme:
            ThemeData(
                primarySwatch: Colors.red,
                splashFactory: InkRipple.splashFactory,
            ),
        home: GeneralInfoPage(),
      ),
    );
  }
}
