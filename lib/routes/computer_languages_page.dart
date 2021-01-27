import 'package:fayizali/blocs/url_bloc.dart';
import 'package:fayizali/widgets/arc_frame_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ComputerLanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    UrlBloc urlBloc = Provider.of<UrlBloc>(context);

    List<Map<String, dynamic>> contentList = [
      {
        'text': 'React Native',
        'icon': Icon(Icons.edit, size: 40,),
        'programs': [
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
        ]
      },
      {
        'text': 'Flutter',
        'icon': Icon(Icons.star, size: 40,),
        'programs': [
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
        ]
      },
      {
        'text': 'Python',
        'icon': Icon(Icons.watch_later_outlined, size: 40,),
        'programs': [
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
            'link': 'http://oliventech.com'
          },
          {
            'name': 'Something',
            'image': Placeholder(fallbackHeight: 350),
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
            child: Center(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.18),
                shrinkWrap: true,
                itemCount: contentList.length,
                itemBuilder: (BuildContext context, int itemIndex) {
                  Map<String, dynamic> item = contentList[itemIndex];
                  return Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item['text'].toString(), style: TextStyle(fontSize: 40),),
                              item['icon'],
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/2,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
                              scrollDirection: Axis.horizontal,
                              itemCount: item['programs'].length,
                              itemBuilder: (BuildContext context, int programIndex) {
                                Map<String, dynamic> program = item['programs'][programIndex];
                                return Card(
                                  elevation: 10.0,
                                  shadowColor: Colors.black,
                                  child: Material(
                                    child: InkWell(
                                      onTap: () => urlBloc.add(UrlLaunchEvent(url: program['link'])),
                                      child: Column(
                                        children: [
                                          program['image'],
                                          Text(program['name'])
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      )
                  );
                },
              ),
            ),
          ),
        ));
  }
}
