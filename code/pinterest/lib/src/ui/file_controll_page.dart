
import 'dart:convert';

import 'package:cloneapp/file.dart';
import 'package:cloneapp/src/components/test_view.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage() {}
  @override
  State<TestPage> createState() => _MainPageState();
}

class _MainPageState extends State<TestPage> {

  var data =  {
    'data': 'aa',
  };

  void initState() {
    super.initState();
    saveJsonFile();
  }

  void saveJsonFile() async {
    var data =  {
      [
        {
          'id' : 0,
          'name' : 'A',
        },
        {
          'id' : 1,
          'name' : 'B',
        },
      ]
    };

    String jsonString = jsonEncode(data);
    await FileIO.writeFileAsString(data: jsonString, path: 'test.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc'),
      ),
      body: TestView(),
    );
  }
}
