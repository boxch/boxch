import 'package:flutter/material.dart';

enum AppTheme { ligth, dark }

final apptheme = {
  AppTheme.ligth: ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.black
          ),
        iconTheme: IconThemeData(
          color: Colors.grey[900]
        )
      ),
      cardColor: Color.fromARGB(255, 22, 22, 22),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Color.fromARGB(255, 236, 236, 236),
      hintColor: Colors.grey, 
      colorScheme: ColorScheme.fromSwatch().copyWith(
        onPrimary: Colors.blue,
        background: Colors.blueGrey[200],
        primary: Colors.black,
        brightness: Brightness.light,
        primaryContainer: Colors.white,
        secondary: Colors.black)),
  AppTheme.dark: ThemeData(
    appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            color: Colors.white
          ),
        iconTheme: IconThemeData(
          color: Colors.white70
        )
      ),
      cardColor: Color.fromARGB(255, 199, 199, 211),
      scaffoldBackgroundColor: Color.fromARGB(255, 19, 24, 31),
      primaryColor: Color.fromARGB(255, 24, 30, 37),
      hintColor: Colors.grey, 
      colorScheme: ColorScheme.fromSwatch().copyWith(
        onPrimary: Color.fromARGB(255, 24, 112, 184),
        background: Color.fromARGB(255, 30, 87, 79),
        primary: Colors.white,
        brightness: Brightness.dark,
        primaryContainer: Colors.black,
        secondary: Colors.white)),
};