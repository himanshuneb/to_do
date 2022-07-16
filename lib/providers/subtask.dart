import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Subtask with ChangeNotifier {
  final String id;
  final String title;
  bool isCompleted;
  //String parent;

  Subtask({
    @required this.id,
    @required this.title,
    this.isCompleted = false,
    //this.parent = '',
  });

  // void setParent(String p) {
  //   //print('new parent set...');
  //   parent = p;
  //   notifyListeners();
  // }

  void _setCompleted(bool newValue) {
    isCompleted = newValue;
    notifyListeners();
  }

  Future<void> toggleCompletedStatus(String authToken, String userId) async {
    final oldStatus = isCompleted;
    isCompleted = !isCompleted;
    notifyListeners();
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/userCompleted/$userId/subtasks/$id.json?auth=$authToken');
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isCompleted': isCompleted,
        }),
      );
      if (response.statusCode >= 400) {
        _setCompleted(oldStatus);
      }
    } catch (error) {
      _setCompleted(oldStatus);
    }
  }
}
