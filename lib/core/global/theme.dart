import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle textStyle =  TextStyle(
    //color:  Color(0X000000),
    color: Colors.red,
    fontSize: ScreenUtil().setSp(16),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle dateStyle =  TextStyle(
    //color:  Color(0X000000),
    color: Colors.deepPurpleAccent,
    fontSize:  ScreenUtil().setSp(16),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle phoneNumberStyle =  TextStyle(
    //color:  Color(0X000000),
    color: Colors.amberAccent,
    fontSize:  ScreenUtil().setSp(16),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle positiveStyle =  TextStyle(
    //color:  Color(0X000000),
    color: Colors.blueAccent,
    fontSize:  ScreenUtil().setSp(16),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle textWhiteStyle =  TextStyle(
    //color:  Color(0X000000),
    color: Colors.white,
    fontSize:  ScreenUtil().setSp(16),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);

TextStyle tabLabelStyle =  TextStyle(
    //color:  Color(0X000000)
    fontSize:  ScreenUtil().setSp(24),);

ThemeData appTheme = ThemeData(
    // hintColor: Colors.white,
    primarySwatch: Colors.blue);

Color textFieldColor =  Color.fromRGBO(255, 255, 255, 0.1);

Color primaryColor =  Color(0xFF00c497);

TextStyle buttonTextStyle =  TextStyle(
    color:  Color.fromRGBO(255, 255, 255, 0.8),
    fontSize:  ScreenUtil().setSp(14),
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);
