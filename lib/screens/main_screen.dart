import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/screens/completed_tasks_screen.dart';
import 'package:tasky/screens/home_screen.dart';
import 'package:tasky/screens/profile_screen.dart';
import 'package:tasky/screens/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentScreen = 0;

  List<Widget> screens = [
    HomeScreen(),
    TasksScreen(),
    CompletedTasksScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
        },
        currentIndex: currentScreen,
        backgroundColor: Color(0XFF181818),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Color(0XFFC6C6C6),
        selectedItemColor: Color(0XFF15B86C),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/home.svg',
              colorFilter: ColorFilter.mode(
                currentScreen == 0 ? Color(0XFF15B86C) : Color(0XFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/todo.svg',
              colorFilter: ColorFilter.mode(
                currentScreen == 1 ? Color(0XFF15B86C) : Color(0XFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/todo_completed.svg',
              colorFilter: ColorFilter.mode(
                currentScreen == 2 ? Color(0XFF15B86C) : Color(0XFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/profile-icon.svg',
              colorFilter: ColorFilter.mode(
                currentScreen == 3 ? Color(0XFF15B86C) : Color(0XFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(child: screens[currentScreen]),
    );
  }
}
