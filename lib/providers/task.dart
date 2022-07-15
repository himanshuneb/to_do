import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Task with ChangeNotifier {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  bool isCompleted;

  Task({
    @required this.id,
    @required this.title,
    @required this.startDate,
    @required this.endDate,
    this.isCompleted = false,
  });

  void _setCompleted(bool newValue) {
    isCompleted = newValue;
    notifyListeners();
  }

  Future<void> toggleCompletedStatus(String token, String userId) async {
    final oldStatus = isCompleted;
    isCompleted = !isCompleted;
    notifyListeners();
    final url = Uri.parse(
        'https://to-do-5abc5-default-rtdb.asia-southeast1.firebasedatabase.app/userCompleted/$userId/tasks/$id.json?auth=$token');
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
