import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:to_do/utilities/sizedbox.dart';

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
        date1 = _editedTask.startDate;
        date2 = _editedTask.endDate;
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _form,
                    //height: (MediaQuery.of(context).size.height * 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Title',
                          //textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'Halenoir',
                              color: Colors.black,
                              fontSize:
                                  (MediaQuery.of(context).size.height * 0.05),
                              fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          style: TextStyle(
                              fontFamily: 'Halenoir',
                              color: Colors.black,
                              fontSize:
                                  (MediaQuery.of(context).size.height * 0.035),
                              fontWeight: FontWeight.w700),
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                              //labelText: 'Title',
                              //border: InputBorder.none,
                              hintText: "Enter title",
                              hintStyle: TextStyle(
                                  fontFamily: 'Halenoir',
                                  color: Colors.black,
                                  fontSize:
                                      (MediaQuery.of(context).size.height *
                                          0.035),
                                  fontWeight: FontWeight.w700)),
                          textInputAction: TextInputAction.next,
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
                  verticalBox(15),
                  Text(
                    'Start Date',
                    //textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Halenoir',
                        color: Colors.black,
                        fontSize: (MediaQuery.of(context).size.height * 0.05),
                        fontWeight: FontWeight.w700),
                  ),
                  //date?
                  verticalBox(15),
                  GestureDetector(
                    child: Container(
                      //color: Colors.red,
                      height: 50,
                      //margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     blurRadius: 2,
                        //     color: Colors.grey.shade500,
                        //   )
                        // ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            //Icons.calendar_month_outlined,
                            //color: backgroundColor,
                            size: 30,
                          ),
                          horizontalBox(10),
                          Text(
                            DateFormat('dd-MM-yyyy').format(date1),
                            style: TextStyle(
                                fontFamily: 'Halenoir',
                                color: Colors.black,
                                fontSize: (MediaQuery.of(context).size.height *
                                    0.035),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      DateTime newDate = await showDatePicker(
                        context: context,
                        initialDate: date1,
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
                  verticalBox(15),
                  Text(
                    'End Date',
                    //textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Halenoir',
                        color: Colors.black,
                        fontSize: (MediaQuery.of(context).size.height * 0.05),
                        fontWeight: FontWeight.w700),
                  ),
                  //date?
                  verticalBox(15),
                  GestureDetector(
                    child: Container(
                      //color: Colors.red,
                      height: 50,
                      //margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        // boxShadow: [
                        //   BoxShadow(
                        //     blurRadius: 2,
                        //     color: Colors.grey.shade500,
                        //   )
                        // ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            //Icons.calendar_month_outlined,
                            //color: backgroundColor,
                            size: 30,
                          ),
                          horizontalBox(10),
                          Text(
                            DateFormat('dd-MM-yyyy').format(date2),
                            style: TextStyle(
                                fontFamily: 'Halenoir',
                                color: Colors.black,
                                fontSize: (MediaQuery.of(context).size.height *
                                    0.035),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      DateTime newDate = await showDatePicker(
                        context: context,
                        initialDate: date2,
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
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'bottomRightAddTaskButton',
        onPressed: _saveForm,
        //backgroundColor: colorPrimary,
        child: const Icon(Icons.check),
      ),
    );
  }
}
