import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/tasks.dart';
import '/widgets/item.dart';
import '/widgets/taskcard.dart';

class TaskList extends StatefulWidget {
  //const TaskList({ Key? key }) : super(key: key);
  final bool showIncomplete;
  TaskList(this.showIncomplete);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Tasks>(context);
    final tasks =
        widget.showIncomplete ? taskData.incompleteItems : taskData.items;
    return SizedBox(
      height: 500,
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: tasks.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: tasks[i],
          child: TaskCard(),
        ),
      ),
    );
  }
}
