import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloneapp/app/pinterest/CreatePinPage.dart';
import 'package:cloneapp/app/pinterest/MessageSafetyPage.dart';
import 'package:cloneapp/app/pinterest/PinPage.dart';
import 'package:cloneapp/app/pinterest/class/system.dart';
import 'package:cloneapp/helper/firestore_database.dart';
import 'package:cloneapp/helper/style.dart';
import 'package:cloneapp/helper/transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as debug;

class MainPage extends StatefulWidget {
  MainPage() {}
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with SingleTickerProviderStateMixin {
  TextEditingController searchInput = new TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  var _controller = ScrollController();
  late TabController _tabController;
  StreamController<double> userAppbarHeightStream  = new StreamController<double>.broadcast();

  List<double> widgetHeight = [];
  List<Color> widgetColors = [];

  var isLoad = false;
  var selectIndex = 0;
  var menu = [ '전체', '풍경', '배경화면', '짱구' ];
  var selectMenu = '';

  var userMenu = [ '생성됨', '저장됨' ];
  var selectUserMenu = '';

  var commentMenu = [ '업데이트', 'Inbox' ];
  var commentAlertCount = [ 7, 14];
  var selectCommentMenu = '';

  late List<Pin> pins = [];

  var searchHotBackURL = [
    'https://i.pinimg.com/474x/06/9f/d5/069fd503b10068c30c1d11886a9aa2f5.jpg',
    'https://i.pinimg.com/474x/07/54/a2/0754a20e9ba1ab4cff63e4900c566c8e.jpg',
    'https://i.pinimg.com/474x/bd/16/8b/bd168bd9db574b31831ba96c65fd415c.jpg',
    'https://i.pinimg.com/474x/ce/b7/fe/ceb7fe9ff0bf2b367af7c26799004fa9.jpg',
    'https://i.pinimg.com/474x/ef/2f/62/ef2f6287bcf6af64231914261f1ec321.jpg',
    'https://i.pinimg.com/474x/ca/fe/c0/cafec018bf3d52cdd3e7d6ba3f8f9428.jpg',
    'https://i.pinimg.com/474x/35/0a/50/350a5084978b4e119aa9d3f821db8e9c.jpg',
    'https://i.pinimg.com/474x/84/45/b6/8445b6d5826c98b0862ffe87378d4555.jpg',
  ];

  var searchHotBackTitle = [
    '밤 바다',
    '명언',
    '아름다운 동물',
    '그림같은',
    '천사',
    '사랑',
    '가을 풍경',
    '우주',
  ];

  var searchBestBackURL = [
    'https://i.pinimg.com/474x/19/8a/98/198a98f1a1240dd25e0030c32620875c.jpg',
    'https://i.pinimg.com/474x/49/ec/1c/49ec1c057395e25aeb252481c49976df.jpg',
    'https://i.pinimg.com/474x/59/60/77/596077b1e8f35cd9632c331c2f1420c1.jpg',
    'https://i.pinimg.com/474x/e2/7b/3c/e27b3c0a4e8ff687d6060814c46273d2.jpg',
    'https://i.pinimg.com/474x/44/67/5f/44675f14c4cf75cc7d4df57c6b204598.jpg',
    'https://i.pinimg.com/474x/88/51/6b/88516b11c1f4bc72b29998cc829ea8c8.jpg',
  ];
  var searchBestTitle = [
    '환상의 풍경',
    '짝사랑',
    '이별',
    '몽환적 풍경',
    '감성 사진',
    '예술 사진',
  ];

  void initState() {
    super.initState();

    selectMenu = menu.first;
    selectUserMenu = userMenu.first;
    selectCommentMenu = commentMenu.first;
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this, animationDuration: Duration.zero);
    _tabController.addListener(() {
      var index = _tabController.index;
      selectUserMenu = userMenu[index];
      setState(() {});
    });
    userAppbarHeightStream.add(0.0);

    initAsync();
    setState(() {});
  }
  void initAsync() async {
    pins =  await FirestoreDatabase.getPinterestHome();
    pins.shuffle(Random.secure());
    setState(() {});
  }
  void updatePin() async {
    //loadingBottomSheet();
    setState(() {});

    await FirestoreDatabase.setPinterestPin({
      'user': {
        'uid': '',
        'displayName': 'Pintree',
        //'photoURL': 'https://i.pinimg.com/75x75_RS/25/f1/29/25f129e48d083e610d2de16503387ade.jpg',
        'photoURL': 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg',
      },
      'title': 'Little stories - Ashraful Arefin on Fstoppers',
      'desc': 'Photographed with Nikon D850, NIKKOR 85mm f/1.8 G. Post-processed and edited in Photoshop',
      'thumbnail': 'https://i.pinimg.com/564x/88/09/2a/88092ae287a4d2c36dcd1beb815fab6f.jpg',
      'link': 'https://www.pinterest.co.kr/pin/851884085767444034/',
      'tag': 'home',
      'createAt': FieldValue.serverTimestamp(),
    });

    debug.log('add pin');

    //Navigator.pop(context);
    setState(() {});
  }
  Future<Null> refreshList() async {
    isLoad = true;
    setState(() {});

    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    pins.shuffle(Random.secure());

    isLoad = false;
    setState(() {});
    return null;
  }

  _bottomSheetCreatePin(BuildContext context, String text) {
    showModalBottomSheet<void>(
        context: context,
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
        backgroundColor: Colors.transparent, /// 기본 바텀시트의 배경을 투명하게 해야 세로길이를 새롭게 설정한 위젯의 라운드 형태가 표시되기 때문
        builder: (BuildContext context) {
          return  StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateItem) {
                var heightPaddingBtn = 8.0;

                return Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 18, 0),
                    decoration: new BoxDecoration(
                      color: Color(0xFF282828),
                      borderRadius: BorderRadius.only(topLeft: const Radius.circular(28), topRight: const Radius.circular(28)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 32,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            '만들기',
                            style: TextStyle(color: Colors.white, fontSize: 18 ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '아이디어 핀',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '핀',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '보드',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                                  backgroundColor: Colors.white24,
                                  shape: StadiumBorder()
                              ),
                              child: Text(
                                '닫기',
                                style: TextStyle(color: Colors.white, fontSize: 18 ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        SystemStyle.iosBottomHeight(context),
                      ],
                    )
                );
              }
          );
        }
    );
  }
  _bottomSheetUserSetting(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
        backgroundColor: Colors.transparent, /// 기본 바텀시트의 배경을 투명하게 해야 세로길이를 새롭게 설정한 위젯의 라운드 형태가 표시되기 때문
        builder: (BuildContext context) {
          return  StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateItem) {
                var heightPaddingBtn = 8.0;

                return Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 18, 0),
                    decoration: new BoxDecoration(
                      color: Color(0xFF282828),
                      borderRadius: BorderRadius.only(topLeft: const Radius.circular(28), topRight: const Radius.circular(28)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 32,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            '프로필',
                            style: TextStyle(color: Colors.white, fontSize: 18 ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '설정',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '커버 이미지 추가',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '공개 프로필 수정',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '프로필 링크 복사',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '공유',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                                  backgroundColor: Colors.white24,
                                  shape: StadiumBorder()
                              ),
                              child: Text(
                                '닫기',
                                style: TextStyle(color: Colors.white, fontSize: 18 ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        SystemStyle.iosBottomHeight(context),
                      ],
                    )
                );
              }
          );
        }
    );
  }
  _bottomSheetUserBSOptionSetting(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
        backgroundColor: Colors.transparent, /// 기본 바텀시트의 배경을 투명하게 해야 세로길이를 새롭게 설정한 위젯의 라운드 형태가 표시되기 때문
        builder: (BuildContext context) {
          return  StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateItem) {
                var heightPaddingBtn = 8.0;

                return Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 18, 0),
                    decoration: new BoxDecoration(
                      color: Color(0xFF282828),
                      borderRadius: BorderRadius.only(topLeft: const Radius.circular(28), topRight: const Radius.circular(28)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 32,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            '비지니스 옵션',
                            style: TextStyle(color: Colors.white, fontSize: 18 ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '분석',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '독자 인사이트',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                                  backgroundColor: Colors.white24,
                                  shape: StadiumBorder()
                              ),
                              child: Text(
                                '닫기',
                                style: TextStyle(color: Colors.white, fontSize: 18 ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        SystemStyle.iosBottomHeight(context),
                      ],
                    )
                );
              }
          );
        }
    );
  }
  _bottomSheetUserPinSortSetting(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
        backgroundColor: Colors.transparent, /// 기본 바텀시트의 배경을 투명하게 해야 세로길이를 새롭게 설정한 위젯의 라운드 형태가 표시되기 때문
        builder: (BuildContext context) {
          return  StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateItem) {
                var heightPaddingBtn = 8.0;
                return Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF282828),
                      borderRadius: BorderRadius.only(topLeft: const Radius.circular(28), topRight: const Radius.circular(28)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 32,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            '정렬 기준',
                            style: TextStyle(color: Colors.white, fontSize: 18 ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '알파벳순',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '사용자 지정',
                                      style: TextStyle(color: Colors.white, fontSize: 22 ),
                                    ),
                                    Text(
                                      '사용자 지정 주문을 수정하려면 누르세요.',
                                      style: TextStyle(color: Colors.white, fontSize: 18 ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.all(12),
                                ),
                                child: Icon(
                                  Icons.check_rounded, color: Colors.white, size: 34,
                                )
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '마지막으로 저장',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),

                        SizedBox(height: 32,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            '프로필 정리하기',
                            style: TextStyle(color: Colors.white, fontSize: 18 ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 28, heightPaddingBtn),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '보드 자동 정렬',
                                style: TextStyle(color: Colors.white, fontSize: 22 ),
                              ),
                              Text(
                                'Pinterest에서 회원님의 보드를 어떻게 표시하면 좋을지 선택하세요.',
                                style: TextStyle(color: Colors.white, fontSize: 18 ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32,),
                        const Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            '레이아웃',
                            style: TextStyle(color: Colors.white, fontSize: 18 ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: const Text(
                            '공개 범위 관리',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                                  backgroundColor: Colors.white24,
                                  shape: StadiumBorder()
                              ),
                              child: Text(
                                '닫기',
                                style: TextStyle(color: Colors.white, fontSize: 18 ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        SystemStyle.iosBottomHeight(context),
                      ],
                    )
                );
              }
          );
        }
    );
  }
  _bottomSheetUserCreateOption(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
        backgroundColor: Colors.transparent, /// 기본 바텀시트의 배경을 투명하게 해야 세로길이를 새롭게 설정한 위젯의 라운드 형태가 표시되기 때문
        builder: (BuildContext context) {
          return  StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateItem) {
                var heightPaddingBtn = 8.0;

                return Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 18, 0),
                    decoration: new BoxDecoration(
                      color: Color(0xFF282828),
                      borderRadius: BorderRadius.only(topLeft: const Radius.circular(28), topRight: const Radius.circular(28)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 32,),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            '만들기',
                            style: TextStyle(color: Colors.white, fontSize: 18 ),
                          ),
                        ),
                        SizedBox(height: 12,),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '아이디어 핀',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '핀',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(18, heightPaddingBtn, 18, heightPaddingBtn),
                          ),
                          child: Text(
                            '보드',
                            style: TextStyle(color: Colors.white, fontSize: 22 ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                                  backgroundColor: Colors.white24,
                                  shape: StadiumBorder()
                              ),
                              child: Text(
                                '닫기',
                                style: TextStyle(color: Colors.white, fontSize: 18 ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        SystemStyle.iosBottomHeight(context),
                      ],
                    )
                );
              }
          );
        }
    );
  }

  Widget _widgetUserMessegeItem({ String? thumb, String? title, bool isNew=false, bool isRead=true, }) {
    if(isNew)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 150), () {});
              var page = MessageSafetyPage();
              /// ddd change slide translator
              Navigator.of(context).push(FadePageRoute(page, 300));
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(18, 14, 18, 14)
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox(height: 50, width: 50, child: CachedNetworkImage(imageUrl: thumb ?? '', fit: BoxFit.cover,)),
                ),
                SizedBox(width: 18,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title ?? 'UserName',
                              style: TextStyle(color: Colors.white, fontSize: 18 ),
                            ),
                          ),
                          Text(
                            title ?? '0000년 00월 00일',
                            style: TextStyle(color: Colors.grey, fontSize: 14 ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '님이 회원님에게 메시지를 보내고 싶어 합니다.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 18 ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 88,),
              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                    backgroundColor: Colors.white38,
                    shape: StadiumBorder()
                ),
                child: Text(
                  '미리 보기',
                  style: TextStyle(color: Colors.white, fontSize: 18 ),
                ),
              ),
              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                    shape: StadiumBorder()
                ),
                child: Text(
                  '거절',
                  style: TextStyle(color: Colors.white, fontSize: 18 ),
                ),
              ),
            ],
          ),
        ],
      );
    return TextButton(
      onPressed: () {

      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(18, 14, 18, 14)
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(height: 50, width: 50, child: CachedNetworkImage(imageUrl: thumb ?? '', fit: BoxFit.cover,)),
          ),
          SizedBox(width: 18,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title ?? 'UserName',
                        style: TextStyle(color: Colors.white, fontSize: 18 ),
                      ),
                    ),
                    Text(
                      title ?? '0000년 00월 00일',
                      style: TextStyle(color:  isRead ? Colors.grey : Colors.white, fontSize: 14 ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title ?? '회원님에게 핀(메세지)을 보냈습니다.',
                        style: TextStyle(color: isRead ? Colors.grey : Colors.white, fontSize: 18 ),
                      ),
                    ),
                    if(!isRead)
                      Icon(Icons.circle, color: Colors.red, size: 16,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _widgetPinUpdateItem({ String? thumb, String? title, bool isNew=false, bool isRead=true, }) {
    return TextButton(
      onPressed: () {

      },
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
          padding: EdgeInsets.fromLTRB(8, 12, 4, 12)
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(height: 50, width: 38, child: CachedNetworkImage(imageUrl: thumb ?? '', fit: BoxFit.cover,)),
          ),
          SizedBox(width: 18,),
          Expanded(
            child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(text: '00 님 외 00명이 회원님의 핀을 저장 했습니다',
                        style: TextStyle(color: Colors.white, fontSize: 18 ),),
                      TextSpan(text: '  00시간 전',
                        style: TextStyle(color: Colors.grey, fontSize: 14 ),),
                    ])
            ),
          ),
          TextButton(
            onPressed: () {

            },
            style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.fromLTRB(8, 8, 4, 8)
            ),
            child: Icon(Icons.more_horiz, color: Colors.grey, size: 18,)
          )
        ],
      ),
    );
  }

  AppBar? buildAppbar() {
    if(selectIndex == 0)
      return AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 18,),
              for(var m in menu)
                TextButton(
                  onPressed: () {
                    selectMenu = m;
                    refreshList();
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(18, 8, 18, 8)
                  ),
                  child: Column(
                    children: [
                      Text(
                        m,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 5,),
                      if(selectMenu == m)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 5,
                            width: 15.5 * m.length,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
      );
    else if(selectIndex == 1)
      return AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 8,),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 2),
                height: 60,
                child: TextFormField(
                  controller: searchInput,
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
                    hintText: '아이디어 검색',
                    hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white12,
                    suffixIcon: GestureDetector(
                      child: Icon(Icons.camera_alt_rounded, size: 24, color: Colors.grey,),
                      onTap: () {
                      },
                    ),
                    prefixIcon: Icon(Icons.search,  size: 24, color: Colors.grey,),
                    contentPadding: const EdgeInsets.fromLTRB(18, 4, 0, 4),
                    border: const OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8,),
          ],
        ),
      );
    else if(selectIndex == 3) {
      var size = [60.0, 44.0];

      List<Widget> menuW = [];
      for(int i = 0; i < commentMenu.length; i++) {
        var m = commentMenu[i];
        Widget alertW = SizedBox();
        if(commentAlertCount[i] != 0)
          alertW = Row(
            children: [
              SizedBox(width: 8,),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
                  child: Text(
                    commentAlertCount[i].toString(), style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              )
            ],
          );

        var w =  TextButton(
          onPressed: () {
            selectCommentMenu = m;
            setState(() {});
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 8)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  alertW,
                ],
              ),
              SizedBox(height: 5,),
              if(selectCommentMenu == m)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 4,
                    width: size[i] + ((commentAlertCount[i] != 0) ? 30 : 0),
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        );
        menuW.add(w);
      }

      return AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 80,),
              Row(
                children: [
                  for(var m in menuW) m,
                ],
              ),
              SizedBox(width: 8,),
              if(selectCommentMenu == '업데이트')
                TextButton(
                onPressed: () {

                },
                child: Icon(
                  Icons.more_horiz,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              if(selectCommentMenu != '업데이트')
                SizedBox(width: 64,),
            ],
          ),
        ),
      );
    }
    else if(selectIndex == 4)
      return null;
    return AppBar();
  }
  Widget buildBody() {
    if(selectIndex == 0) {
      return  Stack(
        children: [
          Positioned(
            top: 0, bottom: 0, left: 0, right: 0,
            child: RefreshIndicator(
              onRefresh: refreshList,
              key: refreshKey,
              backgroundColor: Colors.grey,
              color: Colors.black,
              displacement: 0,
              strokeWidth: 4,
              child: MasonryGridView.count(
                padding: EdgeInsets.fromLTRB(18, isLoad ? 70 : 18, 18, 18),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
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
            ),
          ),
        ],
      );
    }
    else if(selectIndex == 1) {
      return  ListView(
        padding: EdgeInsets.fromLTRB(8, 18, 8, 18),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '추천 아이디어',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              MasonryGridView.count(
                padding: EdgeInsets.only(top: 8),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                itemCount: searchHotBackURL.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.maxFinite,
                          height: 100,
                          child:ColorFiltered(
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.multiply),
                              child: CachedNetworkImage(imageUrl: searchHotBackURL[index], fit: BoxFit.cover,)),),
                      ),
                      Text(
                        searchHotBackTitle[index],
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  );
                },),
              SizedBox(height: 24,),
              Text(
                'Pinterest에서 인기 있는 검색어',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              MasonryGridView.count(
                padding: EdgeInsets.only(top: 8),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                itemCount: searchBestBackURL.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.maxFinite,
                          height: 100,
                          child:ColorFiltered(
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.multiply),
                              child: CachedNetworkImage(imageUrl: searchBestBackURL[index], fit: BoxFit.cover,)),),
                      ),
                      Text(
                        searchBestTitle[index],
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  );
                },),
            ],
          ),
        ],
      );
    }
    else if(selectIndex == 3) {
      if (selectCommentMenu == 'Inbox') {
        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 8),
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(18, 14, 18, 14)
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                            height: 50, width: 50, color: Colors.red,
                            child: Icon(
                              Icons.mark_chat_read_rounded, color: Colors
                                .white,)),
                      ),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Text(
                          '새 메시지',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    for(int i = 0; i < 2; i++)
                      _widgetUserMessegeItem(isNew: true,
                          thumb: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg'),
                    SizedBox(height: 18,),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                          backgroundColor: Colors.white38,
                          shape: StadiumBorder()
                      ),
                      child: Text(
                        '모두 보기',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 24,),
                  ],
                ),

                for(int i = 0; i < 4; i++)
                  _widgetUserMessegeItem(isRead: false,
                      thumb: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg'),

                for(int i = 0; i < 10; i++)
                  _widgetUserMessegeItem(
                      thumb: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg'),
              ],
            ),
            Positioned(
              child: Container(
                color: Colors.black,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 12,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 2),
                        height: 60,
                        child: TextFormField(
                          controller: searchInput,
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
                            hintText: '이름 또는 이메일로 검색',
                            hintStyle: TextStyle(
                                fontSize: 18, color: Colors.grey),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white12,
                            prefixIcon: Icon(
                              Icons.search, size: 24, color: Colors.grey,),
                            contentPadding: const EdgeInsets.fromLTRB(
                                18, 4, 0, 4),
                            border: const OutlineInputBorder(
                              gapPadding: 0,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(24)),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12,),
                  ],
                ),
              ),
            ),
          ],
        );
      }
      if (selectCommentMenu == '업데이트') {
        return ListView(
          padding: EdgeInsets.all(0),
          children: [
            for(int i = 0; i < 50; i++)
              _widgetPinUpdateItem(thumb: 'https://i.pinimg.com/474x/50/a0/e0/50a0e0d6fc71dcb1e1c2b68f1e7a9b5c.jpg'),
          ],
        );
      }
    }
    else if(selectIndex == 4) {

      var view1 = ListView(
          children: [
            Column(
              children: [
                SizedBox(height: 48,),
                Text(
                  '아이디어 핀으로 영감을 전하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 8,),
                TextButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 150), () {});
                    var page = CreatePinPage();
                    /// ddd change slide translator
                    Navigator.of(context).push(FadePageRoute(page, 300));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    '만들기',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 28,),
              ],
            ),

            MasonryGridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
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
                    ],
                  ),
                );
              },
            ),
          ],
        );
      var view2 = ListView(
          children: [
            SizedBox(height: 8,),

            MasonryGridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: pins.length,
              itemBuilder: (context, index) {
                var p = pins[index];
                if(index == 0) {
                  var spacing = 26.0;

                  return  TextButton(
                    onPressed: () async {},
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 142,
                          child: Stack(
                            children: [
                              for(int i = 0; i < 4; i++)
                                Positioned(
                                  right: spacing * i,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(21), bottomRight:Radius.circular(21)),
                                    child: Container(
                                      color: Colors.black,
                                      padding: EdgeInsets.all(1),
                                      child:ClipRRect(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight:Radius.circular(20)),
                                        child: Container(
                                          color: Colors.black,
                                          width: 64, height: 142,
                                          child: CachedNetworkImage(imageUrl: (pins..shuffle()).first.thumbnail, fit: BoxFit.cover,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                right: spacing * 4, left: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(21),
                                  child: Container(
                                    color: Colors.black,
                                    padding: EdgeInsets.all(1),
                                    child:ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        color: Colors.black,
                                        height: 142, width: double.maxFinite,
                                        child: CachedNetworkImage(imageUrl: p.thumbnail, fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '모든 핀',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '핀 6980개',
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      '3시간 전',
                                      style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 12,),
                      ],
                    ),
                  );
                }

                var pin1 = (pins..shuffle()).first;
                var pin2 = (pins..shuffle()).first;
                var pin3 = (pins..shuffle()).first;


                return  TextButton(
                  onPressed: () async {},
                  style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft:Radius.circular(20)),
                            child: Container(
                              height: 141,
                              child: CachedNetworkImage(
                                imageUrl: pin1.thumbnail, fit: BoxFit.cover,
                              ),
                            ),
                            ),
                          ),
                          SizedBox(width: 1.2,),
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: CachedNetworkImage(imageUrl: pin2.thumbnail, fit: BoxFit.cover,),
                                ),
                              ),
                              SizedBox(height: 1.2,),
                              ClipRRect(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: CachedNetworkImage(imageUrl: pin3.thumbnail, fit: BoxFit.cover,),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8,),
                      Text(
                        'Board Name',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '핀 6980개  섹션 8개',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 12,),
                    ],
                  ),
                );
              },
            ),
          ],
        );

      List<Widget> menuW = [];
      for(int i = 0; i < userMenu.length; i++) {
        var m = userMenu[i];
        var w = TextButton(
          onPressed: () async {
            selectUserMenu = m;
            _tabController.animateTo(i);
            setState(() {});
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(18, 8, 18, 8)
          ),
          child: Column(
            children: [
              Text(
                m,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 5,),
              if(selectUserMenu == m)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 5,
                    width: 15.5 * m.length,
                    color: Colors.white,
                  ),
                ),
              if(selectUserMenu != m)
                Container(
                  height: 5,
                ),
            ],
          ),
        );
        menuW.add(w);
      }

      return SafeArea(
        top: true, bottom: false,
        child: NestedScrollView(
          controller: _controller,
          floatHeaderSlivers: false,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget> [
              StreamBuilder(
                stream: userAppbarHeightStream.stream,
                builder: (BuildContext context, AsyncSnapshot<double> stream) {
                  var flag = false;
                  if(selectUserMenu == '저장됨') flag = true;

                  return  SliverAppBar(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.black,
                    ),
                    floating: true,
                    pinned: true,
                    centerTitle: true,
                    titleSpacing: 0,
                    elevation: 0,
                    expandedHeight: 480 + (flag ? 72 : 0),
                    collapsedHeight: 50 + (flag ? 72 : 0),
                    toolbarHeight: 50 + (flag ? 72 : 0),
                    backgroundColor: Colors.black,
                    automaticallyImplyLeading: false,
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        var appbarHeight = 0.0;
                        if(flag) {
                          if(constraints.maxHeight < 172) {
                            appbarHeight = constraints.maxHeight - 50 - 50 - 72;
                            userAppbarHeightStream.add(appbarHeight);
                          }
                        } else {
                          if(constraints.maxHeight < 100) {
                            appbarHeight = constraints.maxHeight - 50 - 50;
                            userAppbarHeightStream.add(appbarHeight);
                          }
                        }
                        //print(constraints.maxHeight);
                        var appbarChange = appbarHeight < - 40.0 ? true : false;

                        return SizedBox(
                          width: double.maxFinite, height: 480 + (flag ? 72 : 0),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                bottom: 0, left: 0, right: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 28,),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(128),
                                      child: SizedBox(
                                        height: 128, width: 128,
                                        child: CachedNetworkImage(imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,),
                                      ),
                                    ),
                                    SizedBox(height: 12,),
                                    Text(
                                      'UserNickName',
                                      style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4,),
                                    Text(
                                      '@UserCode',
                                      style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                      'User Description\nUser Description  User Description',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 12,),
                                    Text(
                                      '8.3만 팔로워   290 팔로잉',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 12,),
                                    Text(
                                      '월별 보기 14만건',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(height: 36,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        for(var w in menuW)
                                          w,
                                      ],
                                    ),
                                    if(selectUserMenu == '저장됨')
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(top: 2),
                                                height: 60,
                                                child: TextFormField(
                                                  controller: searchInput,
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
                                                    hintText: '내 핀 검색',
                                                    hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                                                    isDense: true,
                                                    filled: true,
                                                    fillColor: Colors.white12,
                                                    prefixIcon: Icon(Icons.search,  size: 24, color: Colors.grey,),
                                                    contentPadding: const EdgeInsets.fromLTRB(18, 4, 0, 4),
                                                    border: const OutlineInputBorder(
                                                      gapPadding: 0,
                                                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                                                      borderSide: BorderSide(
                                                        width: 0,
                                                        style: BorderStyle.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _bottomSheetUserPinSortSetting(context);
                                              },
                                              style: TextButton.styleFrom(
                                                  minimumSize: Size.zero
                                              ),
                                              child: Icon(
                                                Icons.all_inclusive,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _bottomSheetUserCreateOption(context);
                                              },
                                              style: TextButton.styleFrom(
                                                  minimumSize: Size.zero
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: appbarHeight, left: 0, right: 0,
                                child: Container(
                                    height: 50, color: Colors.black, alignment: Alignment.bottomCenter,
                                    child: !appbarChange ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              _bottomSheetUserBSOptionSetting(context);
                                            },
                                            child: Icon(
                                              Icons.bar_chart,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {

                                                },
                                                child: Icon(
                                                  Icons.share,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _bottomSheetUserSetting(context);
                                                },
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ]
                                    ) : SizedBox()),
                              ),
                              if(appbarChange)
                                Positioned(
                                    top: 0, left: 0, right: 0,
                                    child: IgnorePointer(
                                      child: Container(
                                        height: 50, color: Colors.transparent, alignment: Alignment.bottomCenter,
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(left: 8, bottom: 6),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(24),
                                                  child: SizedBox(
                                                    height: 42, width: 42,
                                                    child: TextButton(
                                                      onPressed: () {

                                                      },
                                                      style: TextButton.styleFrom(
                                                          minimumSize: Size.zero,
                                                          padding: EdgeInsets.zero
                                                      ),
                                                      child: SizedBox(height: 42, width: 42, child: CachedNetworkImage( imageUrl: 'https://raw.githubusercontent.com/PinTrees/flutter_clone_app/main/pinterest/assets/user_icon_test.jpg', fit: BoxFit.cover,),),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {

                                                },
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    )
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            //physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: view1
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: view2)
            ],
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var iconSize = 36.0;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppbar(),
      body: buildBody(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black,
            height: 52,
            child: Row(
              children: [
                SizedBox(width: 42,),
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
                      _bottomSheetCreatePin(context, '');
                    },
                    child: Container(
                      height: 50,
                      child: Icon(Icons.add, color: Colors.grey,  size: iconSize,),
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
                      Icon(FontAwesomeIcons.solidCommentDots, color: Colors.white,  size: iconSize - 7,):
                      Icon(FontAwesomeIcons.solidCommentDots, color: Colors.grey,  size: iconSize - 7,),
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
                SizedBox(width: 42,),
              ],
            ),
          ),
          SystemStyle.iosBottomHeight(context),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}