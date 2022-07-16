import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do/providers/subtask.dart';

import './task.dart';
import '../models/http_exception.dart';

class Tasks with ChangeNotifier {
  List<Task> _items = [];

  final String authToken;
  final String userId;

  Tasks(this.authToken, this.userId, this._items);

  List<Task> get items {
    return [..._items];
  }

  List<Task> get incompleteItems {
    return _items.where((tItem) => !tItem.isCompleted).toList();
  }

  Task findById(String id) {
    return _items.firstWhere((t) => t.id == id);
  }

  Future<void> fetchAndSetTasks() async {
    print('himanshuneb: called fetch');
    var url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks.json?auth=$authToken');
    print(
        'req to: https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _items = [];
        notifyListeners();
        return;
      }

      final List<Task> loadedTasks = [];
      extractedData.forEach((tId, tData) {
        loadedTasks.add(Task(
          id: tId,
          title: tData['title'],
          startDate: DateTime.parse(tData['start']),
          endDate: DateTime.parse(tData['end']),
          isCompleted: tData['isCompleted'] == true,
        ));
      });
      _items = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTask(Task task) async {
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks.json?auth=$authToken');
    //add try block around the code which might fail
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': task.title,
          'start': task.startDate.toIso8601String(),
          'end': task.endDate.toIso8601String(),
          'creatorId': userId,
          'isCompleted': task.isCompleted,
        }),
      );
      //then
      final newTask = Task(
        title: task.title,
        startDate: task.startDate,
        endDate: task.endDate,
        id: json.decode(response.body)['name'],
        isCompleted: false,
      );
      _items.add(newTask);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
      //then ends
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateTask(String id, Task newTask) async {
    final tIndex = _items.indexWhere((t) => t.id == id);
    if (tIndex >= 0) {
      final url = Uri.parse(
          'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newTask.title,
            'start': newTask.startDate.toIso8601String(),
            'end': newTask.endDate.toIso8601String(),
            'isCompleted': newTask.isCompleted.toString(),
          }));
      _items[tIndex] = newTask;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteTask(String id) async {
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$id.json?auth=$authToken');
    final existingTaskIndex = _items.indexWhere((t) => t.id == id);
    //removes from the list but still keeps the item in memory, helps in rollback if error
    var existingTask = _items[existingTaskIndex];
    //_items.removeWhere((prod) => prod.id == id);
    _items.removeAt(existingTaskIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      //re-add locally if fail
      _items.insert(existingTaskIndex, existingTask);
      notifyListeners();
      //throw is basically like return
      throw HttpException('Could not delete task.');
    }
    existingTask = null;
  }

  void _setCompleted(Task tsk, bool newValue) {
    tsk.isCompleted = newValue;
    notifyListeners();
  }

  Future<void> toggleCompletedStatus(String id) async {
    final taskIndex = _items.indexWhere((t) => t.id == id);
    var tsk = _items[taskIndex];
    final oldStatus = tsk.isCompleted;
    tsk.isCompleted = !tsk.isCompleted;
    notifyListeners();
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$id.json?auth=$authToken');
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isCompleted': tsk.isCompleted,
        }),
      );
      if (response.statusCode >= 400) {
        _setCompleted(tsk, oldStatus);
      }
    } catch (error) {
      _setCompleted(tsk, oldStatus);
    }
  }
}
