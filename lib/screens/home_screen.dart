import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/providers/tasks.dart';

import '/screens/edit_task_screen.dart';

import '../providers/auth.dart';

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditTaskScreen.routeName);
            },
          ),
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
              Icons.more_vert,
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
        ],
      ),
      //drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          //Text("Hello"),
          : TaskList(_showOnlyIncomplete),
    );
  }
}
