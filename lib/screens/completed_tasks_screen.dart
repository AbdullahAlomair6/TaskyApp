import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/widgets/task_list_widget.dart';

import '../models/task_model.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  List<TaskModel> completedTasks = [];

  @override
  void initState() {
    super.initState();

    _loadingTask();
  }

  void _loadingTask() async {
    final pref = await SharedPreferences.getInstance();
    final tasksBeforeDecode = pref.getString('tasks');
    if (tasksBeforeDecode != null) {
      final tasksAfterDecode = jsonDecode(tasksBeforeDecode) as List<dynamic>;

      setState(() {
        completedTasks = tasksAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone == true)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completed Tasks',
            style: TextStyle(
              color: Color(0XFFFFFCFC),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: TaskListWidget(
              tasks: completedTasks,
              onTap: (isCompleted, index) async {
                setState(() {
                  completedTasks[index!].isDone = isCompleted ?? false;
                });

                final pref = await SharedPreferences.getInstance();
                final allTasks = pref.getString('tasks');
                if (allTasks != null) {
                  final allListData = (jsonDecode(allTasks) as List)
                      .map((element) => TaskModel.fromJson(element))
                      .toList();
                  final newIndex = allListData.indexWhere(
                    (element) => element.id == completedTasks[index!].id,
                  );
                  allListData[newIndex] = completedTasks[index!];

                  pref.setString('tasks', jsonEncode(allListData));
                }
                _loadingTask();
              },
              emptyMessage: 'No Tasks Found',
            ),
          ),
        ],
      ),
    );
  }
}
