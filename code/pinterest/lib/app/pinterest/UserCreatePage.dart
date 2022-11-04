import 'dart:math';

import 'package:cloneapp/app/pinterest/PeedPage.dart';
import 'package:cloneapp/helper/transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserCreatePage extends StatefulWidget {
  UserCreatePage() {}
  @override
  State<UserCreatePage> createState() => _UserCreatePageState();
}

class _UserCreatePageState extends State<UserCreatePage> {
  TextEditingController emailInput = new TextEditingController();

  List<double> widgetHeight = [];
  List<Color> widgetColors = [];

  void initState() {
    super.initState();

    Brightness? _brightness = WidgetsBinding.instance?.window?.platformBrightness;

    for(int i = 0; i < 20; i++) {
      widgetHeight.add((Random().nextInt(128) + 100).toDouble());
      widgetColors.add(Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(height: 380,),
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: 300,
                  child: MasonryGridView.count(
                    padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount: widgetHeight.length,
                    itemBuilder: (context, index) {
                      return  Container(
                        height: widgetHeight[index],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image(
                            image: AssetImage('assets/pinterest/pin/home_pin_${index + 1}.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                  left: 0, right: 0, bottom: 80,
                  child: IgnorePointer(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                          )
                      ),
                    ),
                  )
              ),
              Positioned(
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: Container(
                    width: 110,
                    height: 110,
                    color: Colors.white,
                    child: Image(
                      image: AssetImage('assets/pinterest/icon.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 18,),
              Container(
                width: 380,
                child: Text(
                  'Pinterest에 오신 것을 환영합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, fontSize: 32,
                  ),
                ),
              ),
              SizedBox(height: 24,),

              Container(
                padding: EdgeInsets.only(left: 45, right: 45),
                height: 55,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailInput,
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        minLines: 1,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '이메일 주소',
                          hintStyle: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.4),
                          contentPadding: const EdgeInsets.fromLTRB(28, 18, 8, 18),
                          isDense: true,
                          border: const OutlineInputBorder(
                            gapPadding: 0,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28,),
              Container(
                padding: EdgeInsets.only(left: 45, right: 45),
                child: TextButton(
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 150), () {});
                      var page = MainPage();
                      Navigator.of(context).push(FadePageRoute(page, 300));
                    },
                    style: TextButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                        backgroundColor: Colors.red,
                        shape: StadiumBorder()
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '계속하기',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: 28,),
              Container(
                padding: EdgeInsets.only(left: 45, right: 45),
                child: TextButton(
                    onPressed: () {

                    },
                    style: TextButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.fromLTRB(14, 10, 18, 10),
                        backgroundColor: Colors.blue,
                        shape: StadiumBorder()
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          FontAwesomeIcons.facebook,
                          color: Colors.white,
                          size: 28,
                        ),
                        Text(
                          'Facebook으로 계속하기',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                      ],
                    )
                ),
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.only(left: 45, right: 45),
                child: TextButton(
                    onPressed: () {

                    },
                    style: TextButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.fromLTRB(14, 12, 16, 12),
                        backgroundColor: Colors.grey.withOpacity(0.8),
                        shape: StadiumBorder()
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 24,
                            height: 24,
                            child: Image(
                              image: AssetImage('assets/google_icon.png'),
                              fit: BoxFit.fill,
                            ),
                        ),
                        Text(
                          'Google로 계속하기',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(width: 12,)
                      ],
                    )
                ),
              ),
              SizedBox(height: 28,),
              Container(
                width: 330,
                child: Text(
                  '계속 진행하면 Pinterest 서비스 약관에 동의하고 개인정보 보호정책을 읽었음을 인정하는 것으로 간주됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}