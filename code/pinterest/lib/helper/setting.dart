
import 'dart:async';
import 'dart:convert';
//import 'package:cp949/cp949.dart' as cp949;

import 'dart:developer' as debug;
import 'dart:io';

import 'dart:math';


import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:ui';

class Setting {
  static var debug = false;

  static var language = "kr";
  static var languageDefault = "kr";

  static var admobIosAppId = 'ca-app-pub-1271528849752693~2958901609';
  static var admobNativeIosUnitId = 'ca-app-pub-1271528849752693/8770234123';
  static var admobBannerIosUnitId = 'ca-app-pub-1271528849752693/1454248246';

  static var downloadState = 0;
  static double titleSpacing = 32;
  static bool appbarDivider = false;

  static var versionSafety = "1.0.0";

  static var screenSize;

  static var dateformat = new DateFormat('yyyy-MM-dd hh:mm:ss');

  static const simpleTaskKey = "simpleTask";
  static const captureTaskKey = "captureTaskKey";

  static Future<String> get randomKey async {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var key = List.generate(8, (index) => _chars[r.nextInt(_chars.length)]).join();
    return key;
  }
  static String randomString({int length=8}) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var key = List.generate(length, (index) => _chars[r.nextInt(_chars.length)]).join();
    return key;
  }
  static String randomStringNum(int length) {
    var r = Random();
    const _chars = '1234567890';
    var key = List.generate(length, (index) => _chars[r.nextInt(_chars.length)]).join();
    return key;
  }

  static String parsingXmlFirstAtLast(String str, { String? start, String? last,  List<String>? list}) {
    var tmp = str.split('$start').last;
    tmp = tmp.split('$last').first;

    if(list == null) list = [];

    for(var a in list) {
      tmp = tmp.replaceAll('$a', '');
    }

    return tmp;
  }
}
enum HttpError { None , Error , Null }