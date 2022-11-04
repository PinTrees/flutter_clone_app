import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MainPage extends StatefulWidget {
  MainPage() {}
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<double> widgetHeight = [];
  List<Color> widgetColors = [];

  void initState() {
    super.initState();

    Brightness? _brightness = WidgetsBinding.instance?.window?.platformBrightness;

    for(int i = 0; i < 100; i++) {
      widgetHeight.add((Random().nextInt(256) + 64).toDouble());
      widgetColors.add(Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ss'),
      ),
      body: MasonryGridView.count(
        padding: EdgeInsets.fromLTRB(12, 18, 12, 18),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: widgetHeight.length,
          itemBuilder: (context, index) {
            return  Container(
              height: widgetHeight[index],
              color: widgetColors[index],
            );
          },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
