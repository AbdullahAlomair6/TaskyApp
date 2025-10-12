import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/main_screen.dart';
import 'package:tasky/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();

  String? userName = pref.getString('username');
  runApp(MyApp(userName: userName));
}

class MyApp extends StatelessWidget {
  final String? userName;

  const MyApp({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff181818),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff181818),
          titleTextStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          foregroundColor: Color(0xffFFFCFC),
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xff15B86C)),
            foregroundColor: WidgetStateProperty.all(Color(0xffFFFCFC))
          )
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
      ),
      home: userName == null ? WelcomeScreen() : MainScreen(),
    );
  }
}
