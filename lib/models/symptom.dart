class Symptom {
  final String id;
  final String name;
  final String description;
  final String category;
  final int severity;
  final DateTime? startDate;

  Symptom({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.severity,
    this.startDate,
  });
}

class DiagnosisResult {
  final String id;
  final List<String> symptoms;
  final String disease;
  final double confidence;
  final String description;
  final List<String> recommendations;
  final List<String> medicines;
  final DateTime createdAt;
  final bool needsDoctor;

  DiagnosisResult({
    required this.id,
    required this.symptoms,
    required this.disease,
    required this.confidence,
    required this.description,
    required this.recommendations,
    required this.medicines,
    required this.createdAt,
    required this.needsDoctor,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      id: json['id'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      disease: json['disease'] ?? '',
      confidence: (json['confidence'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      recommendations: List<String>.from(json['recommendations'] ?? []),
      medicines: List<String>.from(json['medicines'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      needsDoctor: json['needsDoctor'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symptoms': symptoms,
      'disease': disease,
      'confidence': confidence,
      'description': description,
      'recommendations': recommendations,
      'medicines': medicines,
      'createdAt': createdAt.toIso8601String(),
      'needsDoctor': needsDoctor,
    };
  }
}