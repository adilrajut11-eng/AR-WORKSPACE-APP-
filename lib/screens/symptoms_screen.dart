import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';

const List<String> commonRespiratorySymptoms = [
  'Dry Cough',
  'Wet Cough with Phlegm',
  'Shortness of Breath',
  'Chest Pain',
  'Fever',
  'Sore Throat',
  'Runny Nose',
  'Wheezing',
  'Body Aches',
  'Fatigue',
  'Chills',
  'Nasal Congestion',
];

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({Key? key}) : super(key: key);

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your Symptoms',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose all symptoms you are experiencing',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: commonRespiratorySymptoms.length,
                itemBuilder: (context, index) {
                  final symptom = commonRespiratorySymptoms[index];
                  final isSelected = provider.selectedSymptoms
                      .any((s) => s.name == symptom);
                  
                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        final symptomId = provider.selectedSymptoms
                            .firstWhere((s) => s.name == symptom)
                            .id;
                        provider.removeSymptom(symptomId);
                      } else {
                        provider.addSymptom(
                          symptom,
                          'Patient reported symptom',
                          'respiratory',
                          3,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          symptom,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              if (provider.selectedSymptoms.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Symptoms (${provider.selectedSymptoms.length})',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: provider.selectedSymptoms.map((symptom) {
                          return Chip(
                            label: Text(symptom.name),
                            onDeleted: () => provider.removeSymptom(symptom.id),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: provider.selectedSymptoms.isEmpty
                      ? null
                      : () async {
                        await provider.getDiagnosis();
                      },
                  icon: const Icon(Icons.search),
                  label: const Text('Get AI Diagnosis'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => provider.clearSymptoms(),
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear All'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}