import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/providers/subtask.dart';

import '../models/http_exception.dart';

class Subtasks with ChangeNotifier {
  List<Subtask> _items = [];

  final String authToken;
  final String userId;

  Subtasks(this.authToken, this.userId, this._items);

  List<Subtask> get items {
    return [..._items];
  }

  List<Subtask> get incompleteItems {
    return _items.where((tItem) => !tItem.isCompleted).toList();
  }

  Subtask findById(String id) {
    return _items.firstWhere((t) => t.id == id);
  }

  Future<void> fetchAndSetSubtasks(String parentId) async {
    var url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/subtasks/$parentId.json?auth=$authToken');

    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/userCompleted/$userId/subtasks.json?auth=$authToken');
    final completeResponse = await http.get(url);
    final completeData =
        json.decode(completeResponse.body) as Map<String, dynamic>;
    print('himanshuneb $completeData');

    final List<Subtask> loadedTasks = [];
    //prodId, prodData <=> key, value
    extractedData.forEach((tId, tData) {
      var completeStatus = false;
      if (completeData != null) {
        print('himanshuneb test 1');
        if (completeData[tId] != null) {
          print('himanshuneb test 2');
          if (completeData[tId]['isCompleted'] != null) {
            print('himanshuneb test 3');
            completeStatus = completeData[tId]['isCompleted'];
          }
        }
      }
      print('himanshuneb $completeStatus');

      loadedTasks.add(Subtask(
        id: tId,
        title: tData['title'].toString(),
        isCompleted: completeStatus,
      ));
    });
    _items = loadedTasks;
    notifyListeners();
  }

  Future<void> addSubtask(Subtask task, String parentId) async {
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/subtasks/$parentId.json?auth=$authToken');
    //add try block around the code which might fail
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': task.title,
          'creatorId': userId,
        }),
      );
      //then
      final newTask = Subtask(
        title: task.title,
        id: json.decode(response.body)['name'],
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

  Future<void> updateSubask(String id, Subtask newTask, String parentId) async {
    final tIndex = _items.indexWhere((t) => t.id == id);
    if (tIndex >= 0) {
      final url = Uri.parse(
          'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/subtasks/$parentId/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newTask.title,
          }));
      _items[tIndex] = newTask;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteSubtask(String id, String parentId) async {
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/subtasks/$parentId/$id.json?auth=$authToken');
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
}
