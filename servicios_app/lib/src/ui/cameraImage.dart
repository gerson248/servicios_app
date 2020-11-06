import 'dart:io';

import 'package:flutter/material.dart';

class CameraImage extends StatefulWidget {

  File image;
  CameraImage({Key key, this.image}) : super(key: key);

  @override
  _CameraImageState createState() => _CameraImageState();
}

class _CameraImageState extends State<CameraImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      margin: EdgeInsets.only(
        top:30.0,
        right:120.0,
        left: 120.0,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        //color: Color(0xFF32bcd1),
        image: DecorationImage(
          //image: AssetImage('assets/images/profile.png'),
          image: AssetImage(widget.image.path),
          //fit: BoxFit.cover,
        ),
      ),
    );
  }
}