import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/providers/tasks.dart';

import '/screens/edit_task_screen.dart';

import '../providers/auth.dart';
import '../componenets/theme.dart';

import 'package:to_do/widgets/task_list.dart';

enum FilterOptions {
  Incomplete,
  All,
}

class HomeScreen extends StatefulWidget {
  //const HomeScreen({ Key? key }) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyIncomplete = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  //shouldnt use async in such functions, so use the old approach of then
  void didChangeDependencies() {
    //check if running for the first time
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Tasks>(context).fetchAndSetTasks().then((_) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        iconTheme: const IconThemeData(color: colorAccent),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(EditTaskScreen.routeName);
          //   },
          // ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Incomplete) {
                  _showOnlyIncomplete = true;
                } else {
                  _showOnlyIncomplete = false;
                }
              });
            },
            icon: Icon(
              Icons.view_array,
              color: Colors.black,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show incomplete'),
                value: FilterOptions.Incomplete,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
      //drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          //Text("Hello"),
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "YOUR GOALS",
                    style: CusTextStyle(colorPrimary, 38, FontWeight.bold),
                  ),
                  alignment: Alignment.topLeft,
                ),
                TaskList(_showOnlyIncomplete),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'bottomRightAddTaskButton',
        onPressed: () {
          Navigator.of(context).pushNamed(EditTaskScreen.routeName);
        },
        //backgroundColor: colorPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
