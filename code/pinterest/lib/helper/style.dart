
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SystemStyle {
  static final formatCurrency = new NumberFormat.simpleCurrency(locale: "ko_KR", decimalDigits: 0);
  static var appbarLineHeight = 1.0;

  static var titleMainTextSize = 18.0;
  static var titleTextSize = 16.0;
  static var subTitleTextSize = 14.0;
  static var subTextSize = 13.0;
  static var subMoreTextSize = 12.0;

  static var color = Map<String, Color>();
  static var backgroundColor = new Color(0xFF212226);
  static var backgroundHighColor = new Color(0xFF161718);
  static var backgroundLowColor = new Color(0xFFFFFFFF);

  static var titleColor = new Color(0xFFe9eaee);
  static var accentColor = Colors.redAccent;
  static var textColor = new Color(0xFF9c9fa4);

  static Brightness brightness = Brightness.dark;

  static void setColorStyle(String code, String value){
    color[code] = new Color(int.parse(value, radix: 16));
  }
  static Color getColorStyle(String code){
    code = code.replaceAll('#', '');

    if(color[code] == null){
      if(code.length == 6)
        code = 'ff' + code;
      //log(code);
      color[code] = new Color(int.parse(code, radix: 16));
    }
    return color[code] ?? titleColor;
  }
  static Duration getDateTimeDuration(DateTime target) {
    var _toDay = DateTime.now();
    return _toDay.difference(target);
  }

  static Map<String, dynamic> styleParser(String str) {
    var a = new Map<String, dynamic>();

    if(str == null) return a;

    //str = str.replaceAll(' ', '');
    var sp = str.split(RegExp(';'));
    log(str + '  ' +  sp.length.toString());

    for(int i = 0; i < sp.length; i++) {
      var cur = sp[i].trim().split('=');
      a[cur.first] = cur.last;
    }

    return a;
  }
  static Widget iosBottomHeight(BuildContext context,) {
    if(Platform.isIOS)
      return Container(color: Colors.transparent,
        height: MediaQuery?.of(context)?.viewPadding?.bottom ?? 0,);
    else return SizedBox(height: 0,);
  }
}
