import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/symptom.dart';

class AIService {
  static const String baseUrl = 'https://api.openai.com/v1';
  late String apiKey;

  AIService() {
    apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  Future<DiagnosisResult> diagnoseSymptomatic(List<String> symptoms) async {
    try {
      if (apiKey.isEmpty) {
        throw Exception('API Key not found. Please add OPENAI_API_KEY to .env file');
      }

      final prompt = '''You are a medical AI assistant specializing in respiratory diseases. 
      A patient has reported the following symptoms: ${symptoms.join(', ')}
      
      Based on these symptoms, provide:
      1. Most likely respiratory disease (single most probable diagnosis)
      2. Confidence level (0-100%)
      3. Detailed description of the condition
      4. Recommended actions
      5. Common medicines (if applicable)
      6. Whether immediate doctor consultation is needed
      
      Respond in this JSON format only:
      {
        "disease": "disease name",
        "confidence": 75,
        "description": "detailed explanation",
        "recommendations": ["recommendation 1", "recommendation 2"],
        "medicines": ["medicine 1", "medicine 2"],
        "needsDoctor": true/false
      }''';

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a medical AI assistant.'},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final content = jsonResponse['choices'][0]['message']['content'];
        
        final jsonMatch = RegExp(r'\{[^{}]*"disease"[^{}]*\}', dotAll: true).firstMatch(content);
        if (jsonMatch != null) {
          final diagnosisJson = jsonDecode(jsonMatch.group(0)!);
          return DiagnosisResult(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            symptoms: symptoms,
            disease: diagnosisJson['disease'] ?? 'Unknown',
            confidence: (diagnosisJson['confidence'] ?? 0).toDouble(),
            description: diagnosisJson['description'] ?? '',
            recommendations: List<String>.from(diagnosisJson['recommendations'] ?? []),
            medicines: List<String>.from(diagnosisJson['medicines'] ?? []),
            createdAt: DateTime.now(),
            needsDoctor: diagnosisJson['needsDoctor'] ?? false,
          );
        }
        throw Exception('Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key');
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}