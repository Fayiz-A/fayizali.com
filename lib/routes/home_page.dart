import 'package:fayizali/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController pageController = PageController(viewportFraction: 0.8);

  double _pageIndex = 0;

  void initState() {
    super.initState();

    pageController.addListener(() {
      _pageIndex = pageController.page;
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Fayiz Ali'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageView(
            controller: pageController,
            children: [
              CustomCard(pageIndex: _pageIndex-1,),
              CustomCard(pageIndex: _pageIndex,)
            ],
          ),
        )
      ),
    );
  }
}