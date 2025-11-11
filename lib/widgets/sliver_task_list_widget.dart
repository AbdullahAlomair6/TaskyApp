import 'package:flutter/material.dart';
import 'package:tasky/core/widget/custom_check_box.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_item_widget.dart';

class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({
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
        ? SliverToBoxAdapter(
            child: Center(
              child: Text(
                emptyMessage ?? 'No Data',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        : SliverPadding(
            padding: EdgeInsetsGeometry.only(bottom: 60),
            sliver: SliverList.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TaskItemWidget(
                  model: tasks[index],
                  onChanged: (bool? value) {
                    onTap(value, index);
                  },
                ),
              ),
            ),
          );
  }
}
