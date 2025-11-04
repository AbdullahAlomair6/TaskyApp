import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/widgets/task_list_widget.dart';

import '../models/task_model.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> completedTasks = [];

  @override
  void initState() {
    super.initState();

    _loadingTask();
  }

  void _loadingTask() async {
    final tasksBeforeDecode = PreferencesManager().getString('tasks');
    if (tasksBeforeDecode != null) {
      final tasksAfterDecode = jsonDecode(tasksBeforeDecode) as List<dynamic>;

      setState(() {
        completedTasks = tasksAfterDecode.reversed
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isHighPriority)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('High Priority Tasks')),
      body: Padding(
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
                onTap: (value, index) async {
                  setState(() {
                    completedTasks[index!].isDone = value ?? false;
                  });
                  // final updateTasks = tasks
                  //    .map((element) => element.toJson())
                  //    .toList();

                  /// 1. need to get all list to avoid save the todoTasks to SharedPreferences
                  ///   and replace old list in SharedPreferences with only todoList
                  /// 2. check using indexWhere with bool to return (todoTasks[index!].id) index
                  ///   using id on TaskModel (ex: e.id == todoTasks[index!].id )
                  /// 3. after checked then reassigned object in the allTasks (List) with
                  ///   new value on todoTasks (ex: allDataList[newIndex] = todoTasks[index!]; )
                  /// 4. finally save data on SharedPreferences with last update task

                  final allTasks =PreferencesManager().getString('tasks');
                  if (allTasks != null) {
                    List<TaskModel> allDataList = (jsonDecode(allTasks) as List)
                        .map((element) => TaskModel.fromJson(element))
                        .toList();

                    /// read my own note to know what indexWhere do
                    final newIndex = allDataList.indexWhere(
                      (e) => e.id == completedTasks[index!].id,
                    );
                    allDataList[newIndex] = completedTasks[index!];
                    await PreferencesManager().setString('tasks', jsonEncode(allDataList));
                  }

                  _loadingTask();
                },
                emptyMessage: 'No Tasks Found',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
