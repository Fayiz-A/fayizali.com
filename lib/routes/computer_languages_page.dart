import 'dart:ui';

import 'package:fayizali/blocs/circle_sector_coordinates_bloc.dart';
import 'package:fayizali/blocs/url_bloc.dart';
import 'package:fayizali/routes/parallax_card.dart';
import 'package:fayizali/widgets/arc_frame_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComputerLanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UrlBloc urlBloc = Provider.of<UrlBloc>(context);
    CircleSectorCoordinatesBloc circleSectorCoordinatesBloc = Provider.of<CircleSectorCoordinatesBloc>(context);

    circleSectorCoordinatesBloc.add(CircleSectorEndCoordinatesIdentifierEvent(radius: 50, numberOfSectors: 10, center: Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2)));
    circleSectorCoordinatesBloc.listen((state) => {
          if (state is CircleSectorEndCoordinatesIdentifiedState)
            print('state yielded is: ${state.sectorEndCoordinatesList}')
        });
    Size windowSize = MediaQuery.of(context).size;

    double contentCardHeight = windowSize.height * 0.6;//width is decided by the page view in parallax card
    double contentCardImageWidth = contentCardHeight * 0.7;

    double languageNameFontSize = windowSize.height * 0.06;
    List<Map<String, dynamic>> contentList = [
      {
        'text': 'React Native',
        'icon': Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/React-icon.svg/1280px-React-icon.svg.png', height: languageNameFontSize,),
        'programs': [
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
        ]
      },
      {
        'text': 'Flutter',
        'icon': FlutterLogo(size: languageNameFontSize,),
        'programs': [
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
        ]
      },
      {
        'text': 'Python',
        'icon': Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Python-logo-notext.svg/768px-Python-logo-notext.svg.png', height: languageNameFontSize,),
        'programs': [
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: contentCardImageWidth),
            'link': 'http://oliventech.com'
          },
        ]
      },
    ];

    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: CustomPaint(
            size: Size.infinite,
            foregroundPainter: FramePainter(),
            child: ListView.builder(
              padding: EdgeInsets.only(
                  top: windowSize.height * 0.05, bottom: windowSize.height * 0.2),
              shrinkWrap: true,
              itemCount: contentList.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                Map<String, dynamic> item = contentList[itemIndex];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          item['icon'],
                          Text(
                            item['text'].toString(),
                            style: TextStyle(fontSize: languageNameFontSize),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: contentCardHeight,
                      child: ParallaxWidget(
                        itemCount: item['programs'].length,
                        viewPortFraction: 0.7,
                        renderChildInPageView: (int programIndex) {
                          Map<String, dynamic> program =
                          item['programs'][programIndex];
                          return Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                              child: Card(
                                elevation: 80.0,
                                child: Material(
                                  child: InkWell(
                                    onTap: () => urlBloc
                                        .add(UrlLaunchEvent(url: program['link'])),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        program['image'],
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(program['name'], style: TextStyle(fontSize: windowSize.height*0.03),),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                              child: ElevatedButton(
                                                onPressed: () => urlBloc
                                                    .add(UrlLaunchEvent(url: program['link'])),
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0)),
                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(40.0), right: Radius.circular(40.0))))
                                                ),
                                                child: Text('View', style: TextStyle(fontSize: windowSize.height*0.03),),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        )
    );
  }
}
