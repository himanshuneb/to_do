import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subtasks.dart';
import '../widgets/subtask_list.dart';

import '/screens/edit_subtask_screen.dart';
import '../utilities/percent_based_on_tasks.dart';
import 'package:to_do/widgets/task_list.dart';

class TScreen extends StatefulWidget {
  static const routeName = '/task-screen';

  @override
  State<TScreen> createState() => _TScreenState();
}

class _TScreenState extends State<TScreen> {
  String parentId;
  String parentName;
  double pDays;

  double pTasks;

  var _showOnlyIncomplete = false;

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  //shouldnt use async in such functions, so use the old approach of then
  @override
  void didChangeDependencies() {
    //check if running for the first time
    if (_isInit) {
      final temp = ModalRoute.of(context)?.settings.arguments as Map;
      var str = (temp['Task']);
      Map<String, dynamic> decode = json.decode(str);

      parentId = decode['taskId'].toString();
      parentName = decode['title'].toString();
      pDays = double.parse(decode['days']);

      setState(() {
        _isLoading = true;
      });

      Provider.of<Subtasks>(context).fetchAndSetSubtasks(parentId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Subtasks>(context);
    final total = taskData.tSubtasks;
    final completed = taskData.cSubtasks;
    pTasks = percentTasks(completed, total);
    return Scaffold(
      appBar: AppBar(
        title: Text(parentName),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.exit_to_app),
          //   onPressed: () {
          //     Navigator.of(context).pushReplacementNamed('/');

          //     Provider.of<Auth>(context, listen: false).logout();
          //   },
          // ),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditSubtaskScreen.routeName,
                    arguments: {"id": null, "TaskId": parentId});
              }),
        ],
      ),
      // //drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Text('PercentDays: ${pDays.toString()}'),
                Text(total.toString()),
                Text(completed.toString()),
                Text('Percent Tasks: ${pTasks.toString()}'),
                SubtaskList(_showOnlyIncomplete, parentId),
              ],
            ),
    );
  }
}
