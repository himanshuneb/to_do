import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/screens/edit_subtask_screen.dart';

import '../screens/task_screen.dart';

import '../providers/task.dart';
import '../providers/tasks.dart';
import '../providers/subtask.dart';
import '../providers/subtasks.dart';

import '../providers/auth.dart';
import '../utilities/percent_based_on_days.dart';
import '../utilities/percent_based_on_tasks.dart';

class SubTaskCard extends StatelessWidget {
  //const SubTaskCard({ Key? key }) : super(key: key);
  final String parentId;
  SubTaskCard(this.parentId);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final task = Provider.of<Subtask>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Container(
      //padding: const EdgeInsets.only(right: 20),
      child: Card(
        child: Container(
          //padding: const EdgeInsets.all(15),
          //padding:
          //const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          height: MediaQuery.of(context).size.height * 0.075,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Consumer<Subtasks>(
                  builder: (ctx, tasks, _) => IconButton(
                      onPressed: () {
                        tasks.toggleCompletedStatus(task.id, parentId);
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
                    Navigator.of(context).pushNamed(EditSubtaskScreen.routeName,
                        arguments: {"id": task.id, "TaskId": parentId});
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
                        await Provider.of<Subtasks>(context, listen: false)
                            .deleteSubtask(task.id, parentId);
                      } catch (error) {
                        scaffold.showSnackBar(SnackBar(
                            content: Text(
                          'Deleting failed!',
                          textAlign: TextAlign.center,
                        )));
                      }
                      // Provider.of<Tasks>(context, listen: false)
                      //     .decTotal(parentId);
                      // Provider.of<Tasks>(context, listen: false)
                      //     .decCompleted(parentId);
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
    );
  }
}
