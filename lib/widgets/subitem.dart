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

class SubItem extends StatelessWidget {
  //const Item({ Key? key }) : super(key: key);
  final String parentId;
  SubItem(this.parentId);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final task = Provider.of<Subtask>(context, listen: false);
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
                      child: Consumer<Subtasks>(
                    builder: (ctx, tasks, _) => FlatButton(
                        onPressed: () {
                          tasks.toggleCompletedStatus(task.id, parentId);
                        },
                        child: task.isCompleted
                            ? Text('Mark Incomplete')
                            : Text('Mark Complete')),
                  )),
                  Expanded(
                    //child: Consumer<Task>(
                    //builder: (ctx, no, _) => FlatButton(
                    child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              EditSubtaskScreen.routeName,
                              arguments: {"id": task.id, "TaskId": parentId});
                        },
                        child: Text('Edit')),
                  ),
                  //),
                  Expanded(
                    child: FlatButton(
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
                        },
                        child: Text('Delete')),
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
