import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/consts/colors.dart';

class CustomThemes{
  static final lightTheme=ThemeData(
    cardColor: Colors.white,
    fontFamily: "poppins",
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Vx.gray900,
    iconTheme: const IconThemeData(
      color: Vx.gray600,
    )
  );

  static final darkTheme=ThemeData(
    cardColor: Colors.blueGrey,
      fontFamily: "poppins",
      scaffoldBackgroundColor: bgColor,
      primaryColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.white,
      )
  );
}