import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloneapp/app/pinterest/class/system.dart';
import 'package:cloneapp/helper/firestore_database.dart';
import 'package:cloneapp/helper/transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as debug;

class CreatePinPage extends StatefulWidget {
  CreatePinPage() {}
  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  TextEditingController emailInput = new TextEditingController();

  List<double> widgetHeight = [];
  List<Color> widgetColors = [];

  var selectIndex = 0;

  late List<Pin> pins = [];

  void initState() {
    super.initState();

    initAsync();
    setState(() {});
  }
  void initAsync() async {
    pins =  await FirestoreDatabase.getPinterestHome();
    pins.shuffle(Random.secure());
    setState(() {});
  }

  Widget _widgetPermissionText(String text, String num, bool active) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 28, width: 28,
                padding: EdgeInsets.all(2),
                color: active ? Colors.white : Colors.grey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 26, width: 26,
                    color: active ? Colors.transparent : Colors.black.withOpacity(0.7), alignment: Alignment.center,
                    child: active ? Icon(Icons.check_rounded, color: Colors.black, size: 20,) :
                    Text(num ?? '0', style: TextStyle( fontSize: 14, color: Colors.grey ),)
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12,),
          Text(
            text,
            style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 20, ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mainBorderRadius = 42.0;
    var iconSize = 36.0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mainBorderRadius),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          color: Colors.white.withOpacity(0.18),
                        ),
                        Positioned(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(26, 0, 26, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '카메라 사용하기',
                                  style: TextStyle(color: Colors.white, fontSize: 24, ),
                                ),
                                SizedBox(height: 12,),
                                Text(
                                  '동영상을 녹화하려면 카메라, 오디오, 갤러리 액세스를 허용하세요.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 18, ),
                                ),
                                SizedBox(height: 24,),
                                _widgetPermissionText('카메라 액세스', '1', false),
                                _widgetPermissionText('오디오 액세스', '2', false),
                                _widgetPermissionText('갤러리 액세스', '3', true),
                                SizedBox(height: 28,),
                                TextButton(
                                  onPressed: () async {
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                                    shape: StadiumBorder(),
                                  ),
                                  child: Text(
                                    '설정 업데이트',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 50, width: 50,
                                  padding: EdgeInsets.all(2),
                                  color: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Container(
                                  height: 64, width: 64,
                                  padding: EdgeInsets.all(4),
                                  color: Colors.grey,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      color: Colors.black,
                                      padding: EdgeInsets.all(5),
                                      child:ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Container(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 50, width: 50,
                                  padding: EdgeInsets.all(2),
                                  color: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 48, width: 48,
                                          color: Colors.black,
                                          child: Icon(
                                              Icons.folder, size: 36, color: Colors.white,
                                          ),
                                        ),
                                        Text('0', style: TextStyle( fontSize: 14, color: Colors.black ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18,),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                left: 0, right: 0, top: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        )
                    ),
                  ),
                )
            ),
            Positioned(
              top: 8, left: 8,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all(12),
                        shape: CircleBorder()
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                        padding: EdgeInsets.all(0),
                        shape: CircleBorder()
                    ),
                    child: Icon(
                      Icons.question_mark,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ), //
      ),
    );
  }
}