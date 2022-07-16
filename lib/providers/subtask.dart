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

}
