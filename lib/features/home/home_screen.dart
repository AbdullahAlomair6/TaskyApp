import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widget/custom_svg_picture.dart';
import 'package:tasky/features/home/compontes/achieved_tasks_widget.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/features/add_tasks/add_task_screen.dart';

import '../../core/services/theme_controller.dart';
import 'compontes/high_priority_tasks_widget.dart';
import 'compontes/sliver_task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName = '';
  String? userImage;
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

  _onDelete(int id) {
    setState(() {
      task.removeWhere((element) => element.id == id);
      calculatePercent();
    });
    final taskAfterDelete = task.map((element) => element.toJson()).toList();
    PreferencesManager().setString('tasks', jsonEncode(taskAfterDelete));
  }

  void _loadUserName() async {
    setState(() {
      userName = PreferencesManager().getString('username');
      userImage = PreferencesManager().getString('user_image');
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
                        backgroundImage: userImage == null
                            ? AssetImage('assets/images/profile.png')
                            : FileImage(File(userImage!)),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Evening ,$userName ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'One task at a time.One step closer.',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Yuhuu ,Your work Is',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        'almost done ! ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      CustomSvgPicture.withoutColor(
                        path: 'assets/images/waving-hand.svg',
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  AchievedTasksWidget(
                    totalDoneTasks: totalDoneTasks,
                    totalTasks: totalTasks,
                    percent: percent,
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
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(fontSize: 20),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                : SliverTaskListWidget(
                    tasks: task,
                    onTap: (value, index) {
                      _doneTasks(value, index);
                    },
                    onDelete: (int id) => _onDelete(id),
                    updateTask: () => _loadTasks(),
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
              _loadTasks();
            }
          },
          backgroundColor: Color(0xff15B86C),
          foregroundColor: Color(0xffFFFCFC),
          label: Text(
            'Add New Task',
            style: TextStyle(decoration: TextDecoration.none),
          ),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
