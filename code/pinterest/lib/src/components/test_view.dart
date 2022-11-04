
import 'package:cloneapp/src/bloc/test_bloc.dart';
import 'package:cloneapp/src/ui/test_page.dart';
import 'package:flutter/material.dart';

class TestView extends StatelessWidget {
  TestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            testBloc.click();
          },
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
          ),
          child: const Text(
            'Click',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),
          ),
        ),
        Container(
          child: StreamBuilder(
            stream: testBloc.testResult,
            initialData: 'start',
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData) {
                return Text(snapshot.data.toString());
              }
              return Container();
            }
          ),
        ),
      ],
    );
  }
}