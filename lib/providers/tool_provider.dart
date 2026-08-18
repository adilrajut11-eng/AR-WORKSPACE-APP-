import 'package:flutter/material.dart';

class ToolProvider extends ChangeNotifier {
  // Add your state management here
  String currentTool = 'OSINT';

  void selectTool(String tool) {
    currentTool = tool;
    notifyListeners();
  }
}