import 'package:flutter/material.dart';
import 'package:student_sync/utils/theme/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      primaryColor: blueColor,
      colorScheme: const ColorScheme.light(
          background: Colors.white,
          brightness: Brightness.light,
          primary: Colors.black,
          secondary: Colors.white),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize: MaterialStateProperty.all(const Size(200, 45)),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return Colors.black;
                },
              ),
              foregroundColor: const MaterialStatePropertyAll(Colors.white))),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return blueColor;
              },
            )),
      ));

  static ThemeData darkTheme = ThemeData(
      primaryColor: blueColor,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
          background: Colors.black,
          brightness: Brightness.dark,
          primary: Colors.white,
          secondary: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            minimumSize: MaterialStateProperty.all(const Size(200, 45)),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.white;
              },
            ),
            foregroundColor: const MaterialStatePropertyAll(Colors.black)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return blueColor;
              },
            )),
      ));
}
