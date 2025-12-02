import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/enums/task_item_actions_enum.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/services/theme_controller.dart';
import 'package:tasky/core/widget/custom_text_form_field.dart';
import 'package:tasky/models/task_model.dart';

import '../widget/custom_check_box.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.updateEditTask,
  });

  final TaskModel model;
  final Function(bool? value) onChanged;
  final Function(int id) onDelete;
  final Function updateEditTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(0XFFD1DAD6),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          CustomCheckBox(
            value: model.isDone,
            onChanged: (bool? value) async {
              onChanged(value);
            },
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  model.taskName,
                  style: model.isDone
                      ? Theme.of(context).textTheme.labelLarge
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (model.taskDescription.isNotEmpty)
                  Text(
                    model.taskDescription,
                    style: TextStyle(
                      color: Color(0xffC6C6C6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color: ThemeController.isDark()
                  ? (model.isDone ? Color(0XFFA0A0A0) : Color(0xffC6C6C6))
                  : (model.isDone ? Color(0XFF6A6A6A) : Color(0xff3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.doneTask:
                  onChanged(!model.isDone);
                case TaskItemActionsEnum.edit:
                  final result = await _showBottomSheet(context, model);
                  if (result == true) {
                    updateEditTask();
                  }
                case TaskItemActionsEnum.delete:
                  _buildShowDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => TaskItemActionsEnum.values
                .map(
                  (element) =>
                      PopupMenuItem(value: element, child: Text(element.name)),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Future<String?> _buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are You Sure You Want To Delete Task ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(decoration: TextDecoration.none),
              ),
            ),
            TextButton(
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: Text(
                'DELETE',
                style: TextStyle(decoration: TextDecoration.none),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showBottomSheet(BuildContext context, TaskModel model) {
    TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    TextEditingController taskDescriptionController = TextEditingController(
      text: model.taskDescription,
    );
    bool isHighPriority = model.isHighPriority;
    GlobalKey<FormState> key = GlobalKey<FormState>();
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CustomTextFormField(
                            title: "Task Name",
                            controller: taskNameController,
                            hintText: 'Finish UI design for login screen',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Add Task Name! ";
                              }
                              ;
                            },
                          ),
                          SizedBox(height: 20),
                          CustomTextFormField(
                            title: 'Task Description',
                            controller: taskDescriptionController,
                            hintText:
                                'Finish onboarding UI and hand off to devs by Thursday.',
                            maxLines: 5,
                          ),
                          SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'High Priority  ',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Switch(
                                value: isHighPriority,
                                onChanged: (value) {
                                  setState(() {
                                    isHighPriority = value;
                                  });
                                },
                                activeTrackColor: Color(0xff15B86C),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (key.currentState?.validate() ?? false) {
                          final tasksDecode = PreferencesManager().getString(
                            'tasks',
                          );
                          List<dynamic> allTasks = [];

                          allTasks = jsonDecode(tasksDecode!) as List;

                          final index = allTasks.indexWhere(
                            (e) => e['id'] == model.id,
                          );

                          allTasks[index] = TaskModel(
                            id: model.id,
                            taskName: taskNameController.text,
                            taskDescription: taskDescriptionController.text,
                            isHighPriority: isHighPriority,
                            isDone: model.isDone,
                          );

                          PreferencesManager().setString(
                            'tasks',
                            jsonEncode(allTasks),
                          );
                          // updateTask();
                          Navigator.pop(context, true);
                        }
                      },
                      label: Text(
                        'Edit Task',
                        style: TextStyle(decoration: TextDecoration.none),
                      ),
                      icon: Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
