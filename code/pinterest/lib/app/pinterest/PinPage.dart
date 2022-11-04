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

class PinPage extends StatefulWidget {
  Pin pin;
  PinPage({required this.pin}) {}
  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
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

  @override
  Widget build(BuildContext context) {
    var mainBorderRadius = 38.0;
    var iconSize = 36.0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(mainBorderRadius), topLeft: Radius.circular(mainBorderRadius)),
                  child: Stack(
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          imageUrl: widget.pin.thumbnail,
                        ),
                      ),
                      Positioned(
                        top: 12, right: 12,
                        child: TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(12),
                              shape: CircleBorder()
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12, right: 12,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black38,
                              padding: EdgeInsets.all(12),
                              shape: CircleBorder()
                          ),
                          child: Icon(
                            Icons.center_focus_strong_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(mainBorderRadius), bottomRight: Radius.circular(mainBorderRadius)),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    color: Colors.white12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24,),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(width: 48, height: 48, child: CachedNetworkImage(imageUrl: widget.pin.user['photoURL'] ?? '', fit: BoxFit.cover,)),
                            ),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.pin.user['displayName'] ?? '',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '팔로워 1.1만명',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                            onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                                  backgroundColor: Colors.white24,
                                  shape: StadiumBorder(),
                                ),
                                child: Text(
                                  '팔로우',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                )),
                          ],
                        ),
                        SizedBox(height: 32,),
                        Text(
                          widget.pin.title,
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 18,),
                        Text(
                          widget.pin.desc,
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                                  shape: StadiumBorder(),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.solidComment,
                                  color: Colors.white,
                                  size: 28,
                                )
                            ),

                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                                      backgroundColor: Colors.white24,
                                      shape: StadiumBorder(),
                                    ),
                                    child: Text(
                                      '방문하기',
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    )
                                ),
                                SizedBox(width: 12,),
                                TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                                      backgroundColor: Colors.red,
                                      shape: StadiumBorder(),
                                    ),
                                    child: Text(
                                      '저장',
                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                    )
                                ),
                              ],
                            ),

                            TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 18, 18, 18),
                                  shape: StadiumBorder(),
                                ),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 32,
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 18,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mainBorderRadius),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    color: Colors.white12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 24,),
                        Text(
                          '댓글',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 18,),
                        Text(
                          '이 핀이 마음에 드시나요? ${widget.pin.user['displayName']} 님에게 알려 주세요!',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(width: 48, height: 48, child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,)),
                            ),
                            SizedBox(width: 18,),
                            Text(
                                '댓글을 추가하세요',
                              style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(height: 18,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mainBorderRadius),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    color: Colors.white12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 24,),
                        Text(
                          '유사한 핀 더 보기',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 24,),
                        MasonryGridView.count(
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pins.length,
                          itemBuilder: (context, index) {
                            var p = pins[index];
                            return  TextButton(
                              onPressed: () async {
                                await Future.delayed(const Duration(milliseconds: 150), () {});
                                var page = PinPage(pin: p);
                                /// ddd change slide translator
                                Navigator.of(context).push(FadePageRoute(page, 300));
                              },
                              style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: p.thumbnail,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 8,),
                                      Expanded(
                                        child: Text(
                                          p.title,
                                          maxLines: 1,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 34,
                                        child: TextButton(
                                            onPressed: () {

                                            },
                                            style: TextButton.styleFrom(
                                              minimumSize: Size.zero,
                                            ),
                                            child: Icon(
                                              Icons.more_horiz,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 4,),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 100,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 18, left: 12,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black38,
                  padding: EdgeInsets.all(12),
                  shape: CircleBorder()
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ), //
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black,
            height: 52,
            child: Row(
              children: [
                SizedBox(width: 45,),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      selectIndex = 0;
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      child: selectIndex == 0 ?
                      Icon(Icons.home_filled, color: Colors.white,  size: iconSize,):
                      Icon(Icons.home_filled, color: Colors.grey,  size: iconSize,),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      selectIndex = 1;
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      child: selectIndex == 1 ?
                      Icon(Icons.search, color: Colors.white,  size: iconSize,):
                      Icon(Icons.search, color: Colors.grey,  size: iconSize,),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      selectIndex = 2;
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      child: selectIndex == 2 ?
                      Icon(Icons.add, color: Colors.white,  size: iconSize,):
                      Icon(Icons.add, color: Colors.grey,  size: iconSize,),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      selectIndex = 3;
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      child: selectIndex == 3 ?
                      Icon(FontAwesomeIcons.commentDots, color: Colors.white,  size: iconSize - 5,):
                      Icon(FontAwesomeIcons.commentDots, color: Colors.grey,  size: iconSize - 5,),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      selectIndex = 4;
                      setState(() {});
                    },
                    child: Container(
                      child: selectIndex == 4 ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: 32, width: 32,
                          padding: EdgeInsets.all(2),
                          color: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              color: Colors.black,
                              padding: EdgeInsets.all(1),
                              child:ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  color: Colors.black,
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) :
                      SizedBox(
                        width: 30, height: 30,
                        child: ClipRRect(borderRadius: BorderRadius.circular(50), child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg',                                     fit: BoxFit.cover,)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 45,),
              ],
            ),
          ),
          if(Platform.isIOS)
            Container(color: Colors.black,
              height: MediaQuery?.of(context)?.viewPadding?.bottom ?? 0,),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}