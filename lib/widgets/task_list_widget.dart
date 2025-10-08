import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final String? emptyMessage;

  final Function(bool? value, int? index) onTap;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage ?? 'No Data',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 60),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff282828),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Checkbox(
                      value: tasks[index].isDone,
                      onChanged: (bool? value) async {
                        onTap(value, index);
                      },
                      activeColor: Color(0xff15B86C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tasks[index].taskName,
                            style: TextStyle(
                              color: tasks[index].isDone
                                  ? Color(0xffC6C6C6)
                                  : Color(0xffFFFCFC),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              decoration: tasks[index].isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (tasks[index].taskDescription.isNotEmpty)
                            Text(
                              tasks[index].taskDescription,
                              style: TextStyle(
                                color: Color(0xffC6C6C6),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_vert,
                        color: tasks[index].isDone
                            ? Color(0XFFA0A0A0)
                            : Color(0xffC6C6C6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
