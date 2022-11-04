import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloneapp/app/pinterest/class/system.dart';
import 'package:cloneapp/helper/firestore_database.dart';
import 'package:cloneapp/helper/style.dart';
import 'package:cloneapp/helper/transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as debug;

class Message {
  var type = 'pin';
}

class MessagePage extends StatefulWidget {
  MessagePage() {}
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController messageInput = new TextEditingController();

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
    pins.shuffle(math.Random.secure());
    setState(() {});
  }

  Widget _widgetMessage({ String type='pin' }) {
    if(pins.length < 1) return SizedBox();

    var p = (pins..shuffle()).first;
    if(type == 'pin') {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 18, 0, 18),
        child: Row(
          children: [
            SizedBox(width: 48,),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImage(imageUrl: p.thumbnail, fit: BoxFit.cover,)),
                    SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        p.title,
                        maxLines: 2,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 4,),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder()
                  ),
                  child: Icon(
                    Icons.push_pin,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
                SizedBox(height: 18,),
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder()
                  ),
                  child: Icon(
                    Icons.share,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(width: 48,),
          ],
        ),
      );
    }
    else if(type == 'text') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8,),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 38, height: 38,
              color: Colors.white,
              child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,),
            ),
          ),
          SizedBox(width: 8,),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ), //  POINT: BoxDecoration
              child: Text(
                "Message Text Message Text Message Text Message Text",
                style: TextStyle(fontSize: 17.0, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 118,),
        ],
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    var mainBorderRadius = 42.0;
    var userIconSize = 94.0;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 38, height: 38,
                color: Colors.white,
                child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: 18,),
            Text(
              'UserName',
              style: TextStyle(fontSize: 18, color: Colors.white),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
            },
            child: Icon(
              Icons.more_horiz,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: 100),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(38, 0, 38, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(
                          FontAwesomeIcons.solidCommentDots,
                          color: Colors.white,
                          size: 64,
                        )
                      ),
                      SizedBox(width: 168,),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.solidComment,
                            color: Colors.white,
                            size: 64,
                          ),
                          Text(
                            '👏',
                            style: TextStyle(fontSize: 34),
                          )
                        ],
                      )
                    ],
                  ),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: userIconSize,
                        width: userIconSize * 2,
                      ),
                      Positioned(
                        right: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: userIconSize, height: userIconSize,
                            color: Colors.white,
                            child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                      //
                      Positioned(
                        left: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: userIconSize, height: userIconSize,
                            color: Colors.white,
                            child: Container(
                              width: userIconSize, height: userIconSize,
                              color: Colors.black,
                              child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/pin/home/17.jpg', fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 24,),
                  Text(
                    'UserName',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold ),
                  ),
                  SizedBox(height: 12,),
                  Text(
                    '이렇게 좋은 일이 시작될지도 모릅니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 18, ),
                  ),
                  SizedBox(height: 128,),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _widgetMessage(),
                _widgetMessage(),
                _widgetMessage(type: 'text'),
              ],
            ),

            SizedBox(height: 128,),
          ],
        ), //
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black,
            height: 68,
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8,),
                TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.all(4),
                      shape: CircleBorder()
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 2),
                    height: 60,
                    child: TextFormField(
                      controller: messageInput,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        setState(() {});
                      },
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      minLines: 1,
                      style: TextStyle(fontSize: 17, color: Colors.white54),
                      decoration: InputDecoration(
                        hintText: '메시지 추가',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                        isDense: true,
                        filled: false,
                        fillColor: Colors.white12,
                        contentPadding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(24),
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
                      padding: EdgeInsets.all(0),
                      shape: CircleBorder()
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                SizedBox(width: 8,),
              ],
            ),
          ),
          SystemStyle.iosBottomHeight(context),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}