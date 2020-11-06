import 'package:flutter/material.dart';

class ProgressIndicators {
  static Widget smallProgressIndicator(context) {
    return Container(
      margin: EdgeInsets.only(top:200),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.pink),
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}