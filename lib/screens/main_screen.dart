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
        items: [
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/home.svg', 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/todo.svg', 1),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/todo_completed.svg', 2),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/profile-icon.svg', 3),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(child: screens[currentScreen]),
    );
  }

  SvgPicture _buildSvgPicture(String path, int index) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
        currentScreen == index ? Color(0XFF15B86C) : Color(0XFFC6C6C6),
        BlendMode.srcIn,
      ),
    );
  }
}
