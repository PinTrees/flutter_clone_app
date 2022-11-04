import 'package:cloneapp/helper/style.dart';
import 'package:cloneapp/helper/transition.dart';
import 'package:cloneapp/dynamic_grid_view.dart';
import 'package:cloneapp/src/ui/test_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/pinterest/UserCreatePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var firebaseApp = await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '클론코드',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget with WidgetsBindingObserver {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this.widget);
    Brightness? _brightness = WidgetsBinding.instance?.window?.platformBrightness;
    setState(() {});

    if(_brightness != Brightness.dark) {
      SystemStyle.backgroundColor = new Color(0xFFffffff);
      SystemStyle.backgroundHighColor = new Color(0xFFe0e0e0);
      SystemStyle.backgroundLowColor = new Color(0xFF3c3c3c);

      SystemStyle.titleColor = new Color(0xFF222222);
      SystemStyle.textColor = new Color(0xFF555555);
    }
    else if(_brightness == Brightness.dark) {
      SystemStyle.backgroundColor = new Color(0xFF212226);
      SystemStyle.backgroundHighColor = new Color(0xFF161718);
      SystemStyle.backgroundLowColor = new Color(0xFFFFFFFF);

      SystemStyle.titleColor = new Color(0xFFe9eaee);
      SystemStyle.textColor = new Color(0xFF9c9fa4);
    }
  }

  void _incrementCounter() async {
    await Future.delayed(const Duration(milliseconds: 150), () {});
    var page = MainPage();
    Navigator.of(context).push(FadePageRoute(page, 300));

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 150), () {});
                var page = UserCreatePage();
                Navigator.of(context).push(FadePageRoute(page, 300));
              },
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                backgroundColor: SystemStyle.backgroundHighColor
              ),
              child: const Text(
                'Pinterest',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
