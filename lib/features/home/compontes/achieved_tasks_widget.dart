import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/services/theme_controller.dart';

class AchievedTasksWidget extends StatelessWidget {
  const AchievedTasksWidget({
    super.key,
    required this.totalDoneTasks,
    required this.totalTasks,
    required this.percent,
  });

  final int totalDoneTasks;
  final int totalTasks;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achieved Tasks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '$totalDoneTasks Out of $totalTasks Done',
                  style: Theme.of(context).textTheme.titleSmall,
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
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
