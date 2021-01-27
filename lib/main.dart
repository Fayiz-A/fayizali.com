import 'package:fayizali/blocs/url_bloc.dart';
import 'package:fayizali/providers/dart_provider.dart';
import 'package:fayizali/providers/lever_provider.dart';
import 'package:fayizali/routes/computer_languages_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LeverProvider()),
        ChangeNotifierProvider(create: (_) => DartProvider()),
        BlocProvider(create: (_) => UrlBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fayiz Ali',
        theme:
            ThemeData(
                primarySwatch: Colors.red,
                splashFactory: InkRipple.splashFactory,
            ),
        home: ComputerLanguagesPage(),
      ),
    );
  }
}
