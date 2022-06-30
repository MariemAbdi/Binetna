import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyThemes{
  static const lightgreen = Color(0xFF9ebf43);
  static const darkgreen = Color(0xFF408454);

  static final lightTheme = ThemeData.light().copyWith(
    primaryColor: lightgreen,
    primaryColorDark: darkgreen,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: darkgreen,
        titleSpacing: 0,
      elevation: 0.0,
      textTheme: TextTheme(titleMedium: TextStyle(fontSize: 15,)),
        iconTheme: IconThemeData(color: darkgreen, opacity: 0.7,),
    ),

    brightness: Brightness.light,
    buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(),
      buttonColor: darkgreen,
      hoverColor: lightgreen),

   tabBarTheme: TabBarTheme(
     labelColor: lightgreen,
     unselectedLabelColor: darkgreen,
   ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
    ),

   scaffoldBackgroundColor: Colors.white,
   backgroundColor: Colors.white,

   indicatorColor: lightgreen,
   dividerColor: Colors.black,

    inputDecorationTheme: InputDecorationTheme(
        iconColor: Colors.white,
    fillColor: lightgreen,
    border: InputBorder.none,
    hintStyle: TextStyle(color: Colors.grey.shade300,fontWeight: FontWeight.w800,fontSize: 16)),
  );





  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF121212),
    backgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade800,
      foregroundColor: darkgreen,
      shadowColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      textTheme: TextTheme(titleMedium: TextStyle(fontSize: 15,)),
      iconTheme: IconThemeData(color: darkgreen, opacity: 0.7,),
    ),
    brightness: Brightness.dark,
    primaryColorLight: Colors.grey.shade900,
    primaryColorDark: Colors.black26,


    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.light,
    ),

    indicatorColor: lightgreen,
    tabBarTheme: TabBarTheme(
      labelColor: lightgreen,
      unselectedLabelColor: darkgreen,

    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(color: Colors.white),
    ),

    buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.light(),
        buttonColor: darkgreen,
        hoverColor: lightgreen),

    dividerColor: Colors.white,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(iconColor: Colors.white,
        fillColor: lightgreen,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.shade300,fontWeight: FontWeight.w800,fontSize: 16)), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightgreen),
  );

}
