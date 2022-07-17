import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '/providers/task.dart';
import '/providers/tasks.dart';

class EditTaskScreen extends StatefulWidget {
  //const EditTaskScreen({ Key? key }) : super(key: key);
  static const routeName = '/edit-task';
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  //created form
  final _form = GlobalKey<FormState>();
  String controllerXD;
  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now();
  //initialized new task
  var _editedTask = Task(
    id: null,
    title: '',
    startDate: null,
    endDate: null,
  );
  //*process for setting initial values start*

  //structure
  var _initValues = {
    'title': '',
    'start': DateTime.now(),
    'end': DateTime.now(),
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final temp = ModalRoute.of(context).settings.arguments as Map;
      //print(ModalRoute.of(context).settings.arguments);
      var taskId;
      if (temp != null) {
        taskId = temp["id"];
      } else {
        taskId = null;
      }
      if (taskId != null) {
        _editedTask =
            Provider.of<Tasks>(context, listen: false).findById(taskId);
        _initValues = {
          'title': _editedTask.title,
          'start': _editedTask.startDate.toIso8601String(),
          'price': _editedTask.endDate.toIso8601String(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //*process for setting intial values end*

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    // _priceFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    // _imageUrlFocusNode.dispose();
    //_controller.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    //wrap the isLoading in a setState as I want to reflect that change on the UI
    setState(() {
      _isLoading = true;
    });
    _editedTask = Task(
        title: controllerXD,
        startDate: date1,
        endDate: date2,
        id: _editedTask.id,
        isCompleted: _editedTask.isCompleted);

    if (_editedTask.id != null) {
      await Provider.of<Tasks>(context, listen: false)
          .updateTask(_editedTask.id, _editedTask);
    } else {
      try {
        await Provider.of<Tasks>(context, listen: false).addTask(_editedTask);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  }),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _form,
                    child: SizedBox(
                      height: 200,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            initialValue: _initValues['title'],
                            //controller: TextEditingController(
                            //    text: _initValues['title']),
                            decoration: InputDecoration(labelText: 'Title'),
                            textInputAction: TextInputAction.next,
                            // onFieldSubmitted: (_) {
                            //   FocusScope.of(context).requestFocus(_priceFocusNode);
                            // },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a value.';
                              }
                              return null;
                            },
                            // onSaved: (value) {
                            //   _editedTask = Task(
                            //       title: value,
                            //       startDate: DateTime.now(),
                            //       endDate: DateTime.now().add(Duration(days: 5)),
                            //       id: _editedTask.id,
                            //       isCompleted: _editedTask.isCompleted);
                            // },
                            onSaved: (value) {
                              controllerXD = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //date?
                GestureDetector(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      //color: primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.grey.shade500,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat('dd-MM-yyyy').format(date1),
                          style: const TextStyle(
                            //color: backgroundColor,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          //Icons.calendar_month_outlined,
                          //color: backgroundColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    DateTime newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (newDate == null) {
                      return;
                    } else {
                      setState(() {
                        date1 = newDate;
                      });
                    }
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      //color: primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: Colors.grey.shade500,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat('dd-MM-yyyy').format(date2),
                          style: const TextStyle(
                            //color: backgroundColor,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          //Icons.calendar_month_outlined,
                          //color: backgroundColor,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    DateTime newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (newDate == null) {
                      return;
                    } else {
                      setState(() {
                        date2 = newDate;
                      });
                    }
                  },
                ),
              ],
            ),
    );
  }
}
