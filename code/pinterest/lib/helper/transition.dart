import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
class SlidePageRoute extends PageRouteBuilder {
  Widget wiget;
  SlidePageRoute({this.wiget}) : super(
      pageBuilder: (context, animation, secondaryAnimation) => wiget,
      transitionDuration: Duration(microseconds: 10),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            curve: Curves.easeIn, parent: null,
          ),
          child: FadeTransition(
            opacity: ,
            child: child,
          ),
        );
      }
  );
}
*/

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute(this.child, this.duration);
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  final Widget child;
  final int duration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: duration);
}