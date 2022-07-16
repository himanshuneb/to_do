import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/task_screen.dart';

import '../providers/task.dart';
import '../providers/tasks.dart';
import '../providers/auth.dart';
import '../utilities/percent_based_on_days.dart';
import '../utilities/percent_based_on_tasks.dart';

class Item extends StatelessWidget {
  //const Item({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<Task>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => TaskScreen(
        //         task: task,
        //       ),
        //     ));
      },
      //child: Slidable(
      //actionPane: const SlidableDrawerActionPane(),
      //actionExtentRatio: 0.2,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 160,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.amber,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey.shade500,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            // Expanded(
            //   child: CircularProgressIndicator(
            //     backgroundColor: Colors.white,
            //     color: Colors.purple.withAlpha(100),
            //     strokeWidth: 2,
            //     value: percentDays(task.date, task.end),
            //   ),
            // ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.bottomLeft,
                        child: TaskTileText(
                          text: task.title,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(left: 10),
                  //     alignment: Alignment.centerLeft,
                  //     child: TaskTileText(
                  //       text: "Start date:".toString(),
                  //       color: textColor,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: TaskTileText(
                        text: 'Start Date: ${task.startDate.day.toString()}',
                        //color: textColor,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(left: 10),
                  //     alignment: Alignment.centerLeft,
                  //     child: TaskTileText(
                  //       text: "End date:".toString(),
                  //       color: textColor,
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(left: 10),
                  //     alignment: Alignment.centerLeft,
                  //     child: CircularProgressIndicator(
                  //       backgroundColor: Colors.white,
                  //       color: Colors.purple.withAlpha(100),
                  //       strokeWidth: 5,
                  //       value: 0.5, //
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: TaskTileText(
                        text: 'End Date: ${task.endDate.day.toString()}',
                        //color: textColor,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(left: 10),
                  //     alignment: Alignment.centerLeft,
                  //     child: TaskTileText(
                  //       text: "Percent based on days:".toString(),
                  //       color: textColor,
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: TaskTileText(
                        text: percentDays(task.startDate, task.endDate)
                            .toString(),
                        //color: textColor,
                      ),
                    ),
                  ),
                  //Checkbox(value: task.isCompleted),
                  Expanded(
                      child: Consumer<Task>(
                    builder: (ctx, task, _) => FlatButton(
                        onPressed: () {
                          task.toggleCompletedStatus(
                              authData.token, authData.userId);
                          //Provider.of<Task>(context, listen: false).increment();
                          //Provider.of<Tasks>(context, listen: false)
                          //.fetchAndSetTasks();
                        },
                        child: task.isCompleted
                            ? Text('Mark Incomplete')
                            : Text('Mark Complete')),
                  )),
                  Expanded(
                      child: Consumer<Task>(
                          builder: (ctx, task, _) => FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      TScreen.routeName,
                                      arguments: {"TaskId": task.id});
                                },
                                child: Text('Task Screen'),
                              ))),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.only(left: 10),
                  //     alignment: Alignment.centerLeft,
                  //     child: TaskTileText(
                  //       text: percentTasks(
                  //               task.checkedSubtasks, task.totalSubtasks)
                  //           .toString(),
                  //       color: textColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      // actions: !task.isCompleted
      //     ? [
      //         TaskTileActions(
      //           color: Colors.lightGreen,
      //           icon: task.isCompleted
      //               ? Icons.remove_done_rounded
      //               : Icons.checklist_rtl_sharp,
      //           onTap: () {
      //             task.isCompleted = true;
      //             updateTask(task);
      //           },
      //         ),
      //         TaskTileActions(
      //           color: Colors.lightBlue.shade100,
      //           icon: task.isStarred ? Icons.star : Icons.star_border,
      //           onTap: () {
      //             task.isStarred = !task.isStarred;
      //             updateTask(task);
      //           },
      //         ),
      //       ]
      //     : [],
      // secondaryActions: [
      //   TaskTileActions(
      //     color: Colors.red,
      //     icon: Icons.delete,
      //     onTap: () {
      //       if (task.id == null) {
      //       } else {
      //         deleteTask(task.id!);
      //       }
      //     },
      //   ),
      // ],
      //),
    );
  }
}

// class TaskTileActions extends StatelessWidget {
//   const TaskTileActions({
//     Key? key,
//     required this.color,
//     required this.icon,
//     required this.onTap,
//   }) : super(key: key);

//   final Color color;
//   final IconData icon;
//   final Function() onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//         alignment: Alignment.center,
//         margin: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: color,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 2,
//               color: Colors.grey.shade500,
//             ),
//           ],
//           borderRadius: const BorderRadius.all(Radius.circular(10)),
//         ),
//         child: Icon(
//           icon,
//           color: backgroundColor,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }

class TaskTileText extends StatelessWidget {
  const TaskTileText(
      {
      //Key? key,
      @required this.text,
      this.fontSize = 14,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black});

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
