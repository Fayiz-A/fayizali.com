import 'package:fayizali/blocs/bubble_touch_bloc.dart';
import 'package:fayizali/blocs/circle_sector_coordinates_bloc.dart';
import 'package:fayizali/blocs/color_bloc.dart';
import 'package:fayizali/blocs/integrators/general_info_page/bubble_color_generator.dart';
import 'package:fayizali/blocs/math_bloc.dart';
import 'package:fayizali/blocs/random_path_bloc.dart';
import 'package:fayizali/blocs/rive_parchment_bloc.dart';
import 'package:fayizali/blocs/url_bloc.dart';
import 'package:fayizali/controllers/firebase_controllers/firebase_controller.dart';
import 'package:fayizali/controllers/firebase_controllers/firestore_controller.dart';
import 'package:fayizali/providers/dart_provider.dart';
import 'package:fayizali/providers/lever_provider.dart';
import 'package:fayizali/routes/blogs/article_page.dart';
import 'package:fayizali/routes/blogs/blogs_page.dart';
import 'package:fayizali/routes/computer_languages_page.dart';
import 'package:fayizali/routes/general_info_page.dart';
import 'package:fayizali/routes/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models/blog.dart';

void main() {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Get.put(FirebaseController());
    Get.put(FirestoreController());

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
        BlocProvider(create: (_) => RiveParchmentBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fayiz Ali',
        initialRoute: '/blogs',
        onGenerateRoute: (settings) {
          String name = settings.name;

          print(settings.name);
          print('/computerLanguages');
          print(settings.name);

          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => HomePage(),);
          } else if(settings.name == '/computerLanguages') {
            return MaterialPageRoute(builder: (context) => ComputerLanguagesPage(), settings: RouteSettings(name: 'computerLanguages'));
          } else if(settings.name == '/generalInfo') {
            return MaterialPageRoute(builder: (context) => GeneralInfoPage(), settings: RouteSettings(name: 'generalInfo'));
          } else if(settings.name == '/blogs') {
            return MaterialPageRoute(builder: (context) => BlogsPage(), settings: RouteSettings(name: 'blogs'));
          }

          Uri uri = Uri.parse(settings.name);
          if (uri.pathSegments.length == 2 &&
              uri.pathSegments.first == 'blogs') {
            String docId = uri.pathSegments[1];

            Blog article;

            Map args = settings.arguments as Map;

            if(args != null) {
              article = args['article'];
            }
            return MaterialPageRoute(builder: (context) => ArticlePage(docId: docId, blog: article,), settings: RouteSettings(name: 'blogs/$docId'));
          }

          return MaterialPageRoute(builder: (context) => HomePage());//Fixme: replace this with 404 page.
        },
        theme:
            ThemeData(
                primarySwatch: Colors.red,
                splashFactory: InkRipple.splashFactory,
            ),
        home: HomePage(),
      ),
    );
  }
}
