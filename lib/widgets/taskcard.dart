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
      //padding: const EdgeInsets.only(right: 20),
      child: Card(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(TScreen.routeName, arguments: {
              "Task": encode,
            });
          },
          child: Container(
            //padding: const EdgeInsets.all(15),
            //padding:
            //const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            height: MediaQuery.of(context).size.height * 0.075,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Consumer<Tasks>(
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
                ),
                Container(),
                Container(),
                Container(),
                Container(), Container(), Container(), Container(), Container(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  //color: Colors.black,
                  child: Text(
                    task.title,
                    style: const TextStyle(
                        fontFamily: 'Halenoir',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                //),
                Container(),
                Container(),
                Container(), Container(), Container(), Container(), Container(),
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditTaskScreen.routeName,
                          arguments: {"id": task.id});
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
                Container(
                  //alignment: Alignment.centerRight,
                  child: IconButton(
                      //alignment: Alignment.centerRight,
                      onPressed: () async {
                        try {
                          await Provider.of<Tasks>(context, listen: false)
                              .deleteTask(task.id);
                        } catch (error) {
                          scaffold.showSnackBar(SnackBar(
                              content: Text(
                            'Deleting failed!',
                            textAlign: TextAlign.center,
                          )));
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                )
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
      ),
    );
  }
}
