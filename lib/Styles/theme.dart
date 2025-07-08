import 'package:flutter/material.dart';
import 'package:day1task/Styles/colors.dart';

final ThemeData appDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: AppColors.scaffoldBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.appBarBackground,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFill,
    labelStyle: TextStyle(color: AppColors.label),
    border: OutlineInputBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonBackground,
      foregroundColor: AppColors.buttonText,
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColors.textButton),
  ),
);
