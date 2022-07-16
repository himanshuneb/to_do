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

  Task({
    @required this.id,
    @required this.title,
    @required this.startDate,
    @required this.endDate,
    this.isCompleted = false,
  });
}
