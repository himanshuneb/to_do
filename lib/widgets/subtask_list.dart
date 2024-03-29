import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/subtasks.dart';
import '/widgets/subtaskcard.dart';

class SubtaskList extends StatelessWidget {
  //const TaskList({ Key? key }) : super(key: key);
  final bool showIncomplete;
  final String parentId;
  SubtaskList(this.showIncomplete, this.parentId);
  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Subtasks>(context);
    //final tasks = showIncomplete ? taskData.incompleteItems : taskData.items;
    final tasks = taskData.items;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.525,
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: tasks.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: tasks[i],
          child: SubTaskCard(parentId),
        ),
      ),
    );
  }
}
