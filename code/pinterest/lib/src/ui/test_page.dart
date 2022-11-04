
import 'package:cloneapp/src/bloc/test_bloc.dart';
import 'package:cloneapp/src/components/test_view.dart';
import 'package:flutter/material.dart';

late TestBloc testBloc;

class TestPage extends StatefulWidget {
  TestPage() {}
  @override
  State<TestPage> createState() => _MainPageState();
}

class _MainPageState extends State<TestPage> {

  void initState() {
    super.initState();
    testBloc = TestBloc();
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
