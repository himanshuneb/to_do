import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/task_screen.dart';
import '../screens/edit_task_screen.dart';

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
      onTap: () {},
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: TaskTileText(
                        text: 'End Date: ${task.endDate.day.toString()}',
                      ),
                    ),
                  ),
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
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(TScreen.routeName,
                                arguments: {"TaskId": task.id});
                          },
                          child: Text('Task Screen'),
                        )),
                  ),
                  //Checkbox(value: task.isCompleted),
                  Expanded(
                      child: Consumer<Tasks>(
                    builder: (ctx, tasks, _) => FlatButton(
                        onPressed: () {
                          tasks.toggleCompletedStatus(task.id);
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
                                EditTaskScreen.routeName,
                                arguments: {"id": task.id});
                          },
                          child: Text('Edit')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
