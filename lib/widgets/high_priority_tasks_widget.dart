import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/widget/custom_check_box.dart';
import 'package:tasky/core/widget/custom_svg_picture.dart';
import 'package:tasky/models/task_model.dart';

import '../core/services/theme_controller.dart';
import '../screens/high_priority_screen.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,
    required this.highPriorityList,
    required this.onTap,
    required this.refresh,
  });

  final List<TaskModel> highPriorityList;
  final Function(bool? value, int? index) onTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(14),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'High Priority Tasks',
                  style: TextStyle(
                    color: Color(0xff15B86C),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                ...highPriorityList.reversed
                    .where((element) => element.isHighPriority)
                    .take(4)
                    .map((element) {
                      return Row(
                        children: [
                          CustomCheckBox(
                            value: element.isDone,
                            onChanged: (bool? value) async {
                              var index = highPriorityList.indexWhere(
                                (e) => e.id == element.id,
                              );
                              onTap(value, index);
                            },
                          ),
                          Expanded(
                            child: Text(
                              element.taskName,
                              style: element.isDone
                                  ? Theme.of(context).textTheme.labelLarge
                                  : Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HighPriorityScreen();
                  },
                ),
              );
              refresh();
            },
            child: Container(
              height: 48,
              width: 48,
              padding: EdgeInsetsGeometry.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: BoxBorder.all(color: Color(0xff6E6E6E)),
                color: Colors.transparent,
              ),
              child: CustomSvgPicture(path: 'assets/images/arrow2.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
