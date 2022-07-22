import 'dart:convert';
import 'package:activity_ring/activity_ring.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/componenets/theme.dart';

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
        //title: Text(parentName),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        //iconTheme: const IconThemeData(color: colorAccent),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // //drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  //color: Colors.red,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.02,
                    //bottom: MediaQuery.of(context).size.height * 0.02
                  ),
                  child: Text(
                    parentName,
                    style: CusTextStyle(
                        colorPrimary,
                        MediaQuery.of(context).size.height * 0.05,
                        FontWeight.bold),
                  ),
                  alignment: Alignment.topLeft,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      //color: Colors.red,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Ring(
                          percent: pTasks,
                          color: RingColorScheme(ringColor: Colors.green),
                          radius: 70,
                          width: 10,
                          child: Center(
                              child: Text(
                            'Tasks done\n$pTasks%',
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Ring(
                        percent: pDays,
                        color: RingColorScheme(ringColor: Colors.green),
                        radius: 70,
                        width: 10,
                        child: Center(
                            child: Text(
                          'Days over\n$pDays%',
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                  ],
                ),
                // Text('PercentDays: ${pDays.toString()}'),
                // Text(total.toString()),
                // Text(completed.toString()),
                // Text('Percent Tasks: ${pTasks.toString()}'),
                SubtaskList(_showOnlyIncomplete, parentId),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'bottomRightAddTaskButton',
        onPressed: () {
          Navigator.of(context).pushNamed(EditSubtaskScreen.routeName,
              arguments: {"id": null, "TaskId": parentId});
        },
        //backgroundColor: colorPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
