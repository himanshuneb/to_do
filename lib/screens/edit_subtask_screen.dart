import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/subtask.dart';
import '/providers/subtasks.dart';
import '/providers/task.dart';
import '/providers/tasks.dart';

class EditSubtaskScreen extends StatefulWidget {
  //const EditTaskScreen({ Key? key }) : super(key: key);
  static const routeName = '/edit-subtask';
  @override
  State<EditSubtaskScreen> createState() => _EditSubtaskScreenState();
}

class _EditSubtaskScreenState extends State<EditSubtaskScreen> {
  String parentId;
  final _form = GlobalKey<FormState>();
  var _editedTask = Subtask(
    id: null,
    title: '',
  );
  var _initValues = {
    'title': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final temp = ModalRoute.of(context).settings.arguments as Map;
      //print(ModalRoute.of(context).settings.arguments);
      //this is actually for subtask
      var taskId;
      if (temp != null) {
        taskId = temp["id"];
      } else {
        taskId = null;
      }
      parentId = temp['TaskId'].toString();

      if (taskId != null) {
        _editedTask =
            Provider.of<Subtasks>(context, listen: false).findById(taskId);
        _initValues = {
          'title': _editedTask.title,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    // _priceFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    // _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    //final temp = ModalRoute.of(context).settings.arguments as Map;

    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    //wrap the isLoading in a setState as I want to reflect that change on the UI
    setState(() {
      _isLoading = true;
    });

    if (_editedTask.id != null) {
      await Provider.of<Subtasks>(context, listen: false)
          .updateSubask(_editedTask.id, _editedTask, parentId);
    } else {
      try {
        await Provider.of<Subtasks>(context, listen: false)
            .addSubtask(_editedTask, parentId);
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
    //final temp = ModalRoute.of(context).settings.arguments as Map;
    //parentId = temp['TaskId'].toString();
    print('parentId: $parentId');
    return Scaffold(
      // appBar: AppBar(
      //   //title: Text(parentName),
      //   iconTheme: IconThemeData(
      //     color: Colors.black, //change your color here
      //   ),
      //   //iconTheme: const IconThemeData(color: colorAccent),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Form(
                    key: _form,
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.height * 0.4),
                      child: ListView(
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
                                    (MediaQuery.of(context).size.height * 0.05),
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
                                            0.05),
                                    fontWeight: FontWeight.w700)),
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
                            onSaved: (value) {
                              _editedTask = Subtask(
                                  title: value,
                                  id: _editedTask.id,
                                  isCompleted: _editedTask.isCompleted);
                            },
                          ),
                        ],
                      ),
                    ),
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
