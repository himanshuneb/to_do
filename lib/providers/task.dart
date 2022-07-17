import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import 'package:provider/provider.dart';
import '/providers/subtask.dart';

class Task with ChangeNotifier {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  bool isCompleted;
  int totalSubtasks;
  int completedSubtasks;

  Task({
    @required this.id,
    @required this.title,
    @required this.startDate,
    @required this.endDate,
    this.isCompleted = false,
    this.completedSubtasks = 0,
    this.totalSubtasks = 0,
  });

  // Future<void> getTotal(String userId, String authToken, String taskId) async {
  //   final url = Uri.parse(
  //       'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/$userId/tasks/$taskId/subtasks/.json?auth=$authToken');
  //   final response = await http.get(url);
  //   final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //   if (extractedData == null) {
  //     //_items = [];
  //     notifyListeners();
  //     return;
  //   }
  //   int t = 0;
  //   extractedData.forEach((tId, tData) {
  //     // loadedTasks.add(Subtask(
  //     //   id: tId,
  //     //   title: tData['title'].toString(),
  //     //   isCompleted: tData['isCompleted'] == true,
  //     // ));
  //     t++;
  //   });
  //   totalSubtasks = t;
  //   notifyListeners();
  //   //return t;
  // }
}
