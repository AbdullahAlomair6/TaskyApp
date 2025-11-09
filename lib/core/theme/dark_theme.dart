import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: Color(0xff181818),
  colorScheme: ColorScheme.dark(primaryContainer: Color(0xff282828)),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xff181818),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
    foregroundColor: Color(0xffFFFCFC),
    centerTitle: false,
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: BorderSide(color: Color(0xff6E6E6E), width: 2),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Color(0xff15B86C)),
      foregroundColor: WidgetStateProperty.all(Color(0xffFFFCFC)),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Color(0XFF15B86C);
      }
      return Color(0xffFFFFFF);
    }),
    thumbColor: WidgetStateProperty.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Color(0XFF9E9E9E);
    }),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: Color(0xffFFFCFC),
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Color(0xffFFFCFC),
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Color(0xffC6C6C6),
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      color: Color(0xffFFFFFF),
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      color: Color(0xffFFFCFC),
      fontWeight: FontWeight.w400,
      fontSize: 24,
    ),
    labelSmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Colors.white,
    ),
    labelMedium: TextStyle(color: Colors.black, fontSize: 16),
    // for Done Tasks
    labelLarge: TextStyle(
      color: Color(0xffC6C6C6),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Color(0xff6D6D6D)),
    filled: true,
    fillColor: Color(0xff282828),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0XFF181818)),
);
