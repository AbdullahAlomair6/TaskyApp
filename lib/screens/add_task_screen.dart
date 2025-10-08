import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isHighPriority = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xff181818),
        title: Text('New Task'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Task Name',
                        style: TextStyle(
                          color: Color(0xffFFFCFC),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: taskNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter your Task Name";
                          }
                          return null;
                        },
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Finish UI design for login screen',
                          hintStyle: TextStyle(color: Color(0xff6D6D6D)),
                          filled: true,
                          fillColor: Color(0xff282828),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Task Description',
                        style: TextStyle(
                          color: Color(0xffFFFCFC),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: taskDescriptionController,
                        // validator: (String? value) {
                        //   if (value == null || value.trim().isEmpty) {
                        //     return 'Enter your Description';
                        //   }
                        //   return null;
                        // },
                        cursorColor: Colors.white,
                        maxLines: 5,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText:
                              'Finish onboarding UI and hand off to devs by Thursday.',
                          hintStyle: TextStyle(color: Color(0xff6D6D6D)),
                          filled: true,
                          fillColor: Color(0xff282828),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'High Priority  ',
                            style: TextStyle(
                              color: Color(0xffFFFCFC),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
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
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_key.currentState?.validate() ?? false) {
                    final prf = await SharedPreferences.getInstance();
                    List listOfTasks = [];

                    /// to check and get from SharedPreferences
                    final taskJson = prf.getString('tasks');

                    if (taskJson != null) {
                      listOfTasks = jsonDecode(taskJson);
                    }

                    TaskModel model = TaskModel(
                      id: listOfTasks.length + 1,
                      taskName: taskNameController.text,
                      taskDescription: taskDescriptionController.text,
                      isHighPriority: isHighPriority,
                    );

                    /// to add in SharedPreferences as List
                    listOfTasks.add(model.toJson());
                    // print(model.toJson());
                    // print(listOfTasks);

                    // final taskEncode = jsonEncode(listOfTasks);
                    await prf.setString('tasks', jsonEncode(listOfTasks));

                    Navigator.of(context).pop(true);
                  }
                },
                label: Text('Add Task'),
                icon: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff15B86C),
                  foregroundColor: Color(0xffFFFCFC),
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
