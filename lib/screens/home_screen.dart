import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/screens/add_task_screen.dart';

import '../widgets/high_priority_tasks_widget.dart';
import '../widgets/sliver_task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName = '';
  List<TaskModel> task = [];
  bool isLoading = false;
  int totalDoneTasks = 0;
  int totalTasks = 0;
  double percent = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTasks();
  }

  void _loadTasks() async {
    setState(() {
      isLoading = true;
    });
    // await Future.delayed(Duration(seconds: 5));

    final finalTasks = PreferencesManager().getString('tasks');
    if (finalTasks != null) {
      final tasksDecode = jsonDecode(finalTasks) as List<dynamic>;

      setState(() {
        task = tasksDecode
            .map((element) => TaskModel.fromJson(element))
            .toList();
        isLoading = false;
        calculatePercent();
      });
    }
  }

  void _loadUserName() async {
    setState(() {
      userName = PreferencesManager().getString('username');
    });
  }

  _doneTasks(bool? value, int? index) async {
    setState(() {
      task[index!].isDone = value ?? false;
      calculatePercent();
    });
    final updatedTask = task.map((element) => element.toJson()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  calculatePercent() {
    totalDoneTasks = task.where((e) => e.isDone).length;
    totalTasks = task.length;
    percent = totalTasks == 0 ? 0 : (totalDoneTasks / totalTasks) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/profile.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Evening ,$userName ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xffFFFCFC),
                            ),
                          ),
                          Text(
                            'One task at a time.One step closer.',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xffC6C6C6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Yuhuu ,Your work Is',
                    style: TextStyle(
                      color: Color(0xffFFFCFC),
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'almost done ! ',
                        style: TextStyle(
                          color: Color(0xffFFFCFC),
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SvgPicture.asset('assets/images/waving-hand.svg'),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xff282828),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Achieved Tasks',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFFFFFCFC),
                                ),
                              ),
                              Text(
                                '$totalDoneTasks Out of $totalTasks Done',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0XFFC6C6C6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: -pi / 2,
                              child: SizedBox(
                                height: 48,
                                width: 48,
                                child: CircularProgressIndicator(
                                  value: percent / 100,
                                  color: Color(0xff15B86C),
                                  backgroundColor: Color(0xff6D6D6D),
                                ),
                              ),
                            ),
                            Text(
                              "${percent.toInt()}%",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidget(
                    highPriorityList: task,
                    onTap: (value, index) async {
                      _doneTasks(value, index);
                    },
                    refresh: () => _loadTasks(),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'My Tasks',
                    style: TextStyle(
                      color: Color(0XFFFFFCFC),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : SliverTaskListWidget(
                    tasks: task,
                    onTap: (value, index) {
                      _doneTasks(value, index);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        width: 167,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddTaskScreen();
                },
              ),
            );
            if (result != null && result == true) {
              print('load task');
              _loadTasks();
            }
          },
          backgroundColor: Color(0xff15B86C),
          foregroundColor: Color(0xffFFFCFC),
          label: Text('Add New Task'),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
