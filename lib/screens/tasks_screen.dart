import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

import '../widgets/task_list_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = [];

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
        todoTasks = tasksAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone == false)
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
              tasks: todoTasks,
              onTap: (value, index) async {
                setState(() {
                  todoTasks[index!].isDone = value ?? false;
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

                final allTasks = PreferencesManager().getString('tasks');
                if (allTasks != null) {
                  List<TaskModel> allDataList = (jsonDecode(allTasks) as List)
                      .map((element) => TaskModel.fromJson(element))
                      .toList();

                  /// read my own note to know what indexWhere do
                  final newIndex = allDataList.indexWhere(
                    (e) => e.id == todoTasks[index!].id,
                  );
                  allDataList[newIndex] = todoTasks[index!];
                  await PreferencesManager().setString(
                    'tasks',
                    jsonEncode(allDataList),
                  );
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
