import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/models/task_model.dart';

import '../screens/high_priority_screen.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,
    required this.highPriorityList,
    required this.onTap,
    required this.refresh,
  });

  final List<TaskModel>  highPriorityList;
  final Function(bool? value, int? index) onTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0XFF282828),
        borderRadius: BorderRadius.circular(20),
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
                          Checkbox(
                            value: element.isDone,
                            onChanged: (bool? value) async {
                              var index = highPriorityList.indexWhere(
                                (e) => e.id == element.id,
                              );
                              onTap(value, index);
                            },
                            activeColor: Color(0xff15B86C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              element.taskName,
                              style: TextStyle(
                                color: element.isDone
                                    ? Color(0xffC6C6C6)
                                    : Color(0xffFFFCFC),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                decoration: element.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
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
                //    borderRadius: BorderRadiusGeometry.circular(100),
                border: BoxBorder.all(color: Color(0xff6E6E6E)),
                color: Colors.transparent,
              ),
              child: SvgPicture.asset('assets/images/arrow2.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
