import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '/providers/subtask.dart';
import '/providers/task.dart';

import '../models/http_exception.dart';

class Subtasks with ChangeNotifier {
  List<Subtask> _items = [];
  int _totalSubtasks = 0;
  int _completedSubtasks = 0;

  final String authToken;
  final String userId;

  Subtasks(this.authToken, this.userId, this._items, this._totalSubtasks,
      this._completedSubtasks);

  List<Subtask> get items {
    return [..._items];
  }

  int get tSubtasks {
    return _totalSubtasks;
  }

  int get cSubtasks {
    return _completedSubtasks;
  }

  List<Subtask> get incompleteItems {
    return _items.where((tItem) => !tItem.isCompleted).toList();
  }

  Subtask findById(String id) {
    return _items.firstWhere((t) => t.id == id);
  }

  // Future<void> fetchNumbers(String parentId) async {
  //   var url = Uri.parse(
  //       'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$parentId.json?auth=$authToken');
  // }

  Future<void> fetchAndSetSubtasks(String parentId) async {
    var url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$parentId/subtasks.json?auth=$authToken');
    _totalSubtasks = 0;
    _completedSubtasks = 0;
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      _items = [];
      notifyListeners();
      return;
    }

    final List<Subtask> loadedTasks = [];
    //prodId, prodData <=> key, value
    extractedData.forEach((tId, tData) {
      loadedTasks.add(Subtask(
        id: tId,
        title: tData['title'].toString(),
        isCompleted: tData['isCompleted'] == true,
      ));
      if (tData['isCompleted'] == true) {
        _completedSubtasks++;
      }
      _totalSubtasks++;
    });
    _items = loadedTasks;
    notifyListeners();
  }

  Future<void> addSubtask(Subtask task, String parentId) async {
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$parentId/subtasks.json?auth=$authToken');
    //add try block around the code which might fail
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': task.title,
          'creatorId': userId,
          'isCompleted': task.isCompleted,
        }),
      );
      //then
      final newTask = Subtask(
        title: task.title,
        id: json.decode(response.body)['name'],
        isCompleted: false,
      );
      _items.add(newTask);
      _totalSubtasks++;
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
      //then ends
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateSubask(String id, Subtask newTask, String parentId) async {
    final tIndex = _items.indexWhere((t) => t.id == id);
    if (tIndex >= 0) {
      final url = Uri.parse(
          'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$parentId/subtasks/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newTask.title,
            'isCompleted': newTask.isCompleted,
          }));
      _items[tIndex] = newTask;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteSubtask(String id, String parentId) async {
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$parentId/subtasks/$id.json?auth=$authToken');
    final existingTaskIndex = _items.indexWhere((t) => t.id == id);
    //removes from the list but still keeps the item in memory, helps in rollback if error
    var existingTask = _items[existingTaskIndex];
    bool itWasCompleted = false;
    //_items.removeWhere((prod) => prod.id == id);
    if (_items[existingTaskIndex].isCompleted) {
      itWasCompleted = true;
    }
    if (itWasCompleted) {
      _completedSubtasks--;
    }
    _totalSubtasks--;
    _items.removeAt(existingTaskIndex);

    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      //re-add locally if fail
      _items.insert(existingTaskIndex, existingTask);
      if (itWasCompleted) {
        _completedSubtasks++;
      }
      _totalSubtasks++;
      notifyListeners();
      //throw is basically like return
      throw HttpException('Could not delete task.');
    }
    existingTask = null;
  }

  void _setCompleted(Subtask tsk, bool newValue) {
    tsk.isCompleted = newValue;
    notifyListeners();
  }

  Future<void> toggleCompletedStatus(String id, String parentId) async {
    final taskIndex = _items.indexWhere((t) => t.id == id);
    var tsk = _items[taskIndex];
    final oldStatus = tsk.isCompleted;
    tsk.isCompleted = !tsk.isCompleted;
    bool setToCompleted = false;
    if (tsk.isCompleted) {
      setToCompleted = true;
    }

    if (setToCompleted) {
      _completedSubtasks++;
    } else {
      _completedSubtasks--;
    }

    notifyListeners();
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$parentId/subtasks/$id.json?auth=$authToken');
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isCompleted': tsk.isCompleted,
        }),
      );
      if (response.statusCode >= 400) {
        _setCompleted(tsk, oldStatus);
        if (setToCompleted) {
          _completedSubtasks--;
        } else {
          _completedSubtasks++;
        }
      }
    } catch (error) {
      _setCompleted(tsk, oldStatus);
      if (setToCompleted) {
        _completedSubtasks--;
      } else {
        _completedSubtasks++;
      }
    }
  }
}
