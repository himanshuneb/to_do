import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/task.dart';
import '/providers/tasks.dart';

class EditTaskScreen extends StatefulWidget {
  //const EditTaskScreen({ Key? key }) : super(key: key);
  static const routeName = '/edit-task';
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _form = GlobalKey<FormState>();
  var _editedTask = Task(
    id: null,
    title: '',
    startDate: null,
    endDate: null,
  );
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
      final taskId = ModalRoute.of(context).settings.arguments as String;
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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
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
                      onSaved: (value) {
                        _editedTask = Task(
                            title: value,
                            startDate: DateTime.now(),
                            endDate: DateTime.now().add(Duration(days: 5)),
                            id: _editedTask.id,
                            isCompleted: _editedTask.isCompleted);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
