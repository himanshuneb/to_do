import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/task_screen.dart';
import '../screens/edit_task_screen.dart';

import '../providers/task.dart';
import '../providers/tasks.dart';
import '../providers/auth.dart';
import '../utilities/sizedbox.dart';
import '../utilities/percent_based_on_days.dart';
import '../utilities/percent_based_on_tasks.dart';

class TaskCard extends StatelessWidget {
  //const TaskCard ({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final task = Provider.of<Task>(context, listen: false);
    String days = percentDays(task.startDate, task.endDate).toString();
    var encode = json.encode({
      'taskId': task.id,
      'title': task.title,
      'days': days,
    });
    final authData = Provider.of<Auth>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(right: 20),
      width: 200,
      //height: 100,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<Tasks>(
                builder: (ctx, tasks, _) => IconButton(
                    onPressed: () {
                      tasks.toggleCompletedStatus(task.id);
                    },
                    icon: task.isCompleted
                        ? Icon(
                            Icons.check_box,
                            //size: 25,
                          )
                        : Icon(Icons.crop_square)),
              ),
              horizontalBox(20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(TScreen.routeName, arguments: {
                    "Task": encode,
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Text(
                    task.title,
                    style: const TextStyle(
                        fontFamily: 'Halenoir',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              // GestureDetector(
              //     onTap: () {
              //       print(timing);
              //     },
              //     child: Icon(
              //       (() {
              //         if (timing == 'any') {
              //           return null;
              //         }
              //         if (timing == 'morning') {
              //           return Icons.wb_sunny_outlined;
              //         }
              //         if (timing == 'evening') {
              //           return Icons.cloud_circle_outlined;
              //         }
              //         if (timing == 'night') {
              //           return Icons.mode_night_outlined;
              //         }
              //       }()),
              //       color: colorAccent,
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
