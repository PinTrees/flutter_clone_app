import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloneapp/app/pinterest/MessagePage.dart';
import 'package:cloneapp/app/pinterest/class/system.dart';
import 'package:cloneapp/helper/firestore_database.dart';
import 'package:cloneapp/helper/transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as debug;

class MessageSafetyPage extends StatefulWidget {
  MessageSafetyPage() {}
  @override
  State<MessageSafetyPage> createState() => _MessageSafetyPageState();
}

class _MessageSafetyPageState extends State<MessageSafetyPage> {
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
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(38, 0, 38, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Stack(
                   alignment: Alignment.centerLeft,
                   children: [
                     Container(
                       height: 74,
                       width: 148,
                     ),
                     Positioned(
                       left: 74,
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(50),
                         child: Container(
                           width: 74, height: 74,
                           color: Colors.white,
                           child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,),
                         ),
                       ),
                     ),
                     Positioned(
                       left: 24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 74, height: 74,
                          color: Colors.white,
                          child: Container(
                            color: Colors.black87,
                            child: Icon(
                              Icons.priority_high_rounded,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                     ),

                   ],
                 ),
                  SizedBox(height: 20,),
                  Text(
                    'UserName ?????? ???????????? ?????? ?????? ?????? ????????????.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24, ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    '????????? 00???',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 18, ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    '????????? ????????? ?????? ?????? ??? ????????? ????????? ?????????. ??? ?????? ????????? ??????????????? ?????? ????????? ?????? ????????? ???????????? ?????????.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18, ),
                  ),
                  SizedBox(height: 128,),
                ],
              ),
            ),
            Positioned(
              bottom: 68, left: 28, right: 28,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 150), () {});
                      var page = MessagePage();
                      /// ddd change slide translator
                      Navigator.of(context).push(FadePageRoute(page, 300));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      '????????? ??????',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: 18,),
                  Text(
                    'Pinterest ???????????? ?????????????????? ????????? ???????????? ????????? Pinterest ????????? ???????????????.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14, ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8, left: 12,
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
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 24,
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