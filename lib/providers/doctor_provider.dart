import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/symptom.dart';
import '../services/ai_service.dart';

class DoctorProvider extends ChangeNotifier {
  final aiService = AIService();
  List<Symptom> selectedSymptoms = [];
  DiagnosisResult? latestDiagnosis;
  List<DiagnosisResult> diagnosisHistory = [];
  bool isLoading = false;
  String? errorMessage;

  DoctorProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('diagnosis_history') ?? [];
      diagnosisHistory = historyJson
          .map((json) => DiagnosisResult.fromJson(jsonDecode(json)))
          .toList()
          .cast<DiagnosisResult>();
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error loading history';
      notifyListeners();
    }
  }

  Future<void> saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = diagnosisHistory
          .map((d) => jsonEncode(d.toJson()))
          .toList();
      await prefs.setStringList('diagnosis_history', historyJson);
    } catch (e) {
      errorMessage = 'Error saving history';
      notifyListeners();
    }
  }

  void addSymptom(String name, String description, String category, int severity) {
    selectedSymptoms.add(
      Symptom(
        id: const Uuid().v4(),
        name: name,
        description: description,
        category: category,
        severity: severity,
        startDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeSymptom(String id) {
    selectedSymptoms.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void clearSymptoms() {
    selectedSymptoms.clear();
    latestDiagnosis = null;
    notifyListeners();
  }

  Future<void> getDiagnosis() async {
    if (selectedSymptoms.isEmpty) {
      errorMessage = 'Please select at least one symptom';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final symptomNames = selectedSymptoms.map((s) => s.name).toList();
      final diagnosis = await aiService.diagnoseSymptomatic(symptomNames);
      
      latestDiagnosis = diagnosis;
      diagnosisHistory.insert(0, diagnosis);
      
      if (diagnosisHistory.length > 10) {
        diagnosisHistory.removeAt(10);
      }
      
      await saveHistory();
      isLoading = false;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    selectedSymptoms.clear();
    latestDiagnosis = null;
    diagnosisHistory.clear();
    errorMessage = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('diagnosis_history');
    notifyListeners();
  }
}