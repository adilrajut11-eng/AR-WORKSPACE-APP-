import 'package:flutter/material.dart';
import '../services/radio_service.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  String _selectedType = 'FM Radio';
  double _frequency = 100.0;
  Map<String, dynamic> _result = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequency Type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
                _frequency = _getDefaultFrequency();
              });
            },
            items: ['FM Radio', 'AM Radio', 'WiFi', 'Cellular', 'Bluetooth']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'Frequency: ${_frequency.toStringAsFixed(2)} MHz',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Slider(
            value: _frequency,
            min: 0,
            max: 3800,
            onChanged: (value) => setState(() => _frequency = value),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _result = RadioService.generateFrequency(
                    type: _selectedType,
                    baseFrequency: _frequency,
                  );
                });
              },
              icon: const Icon(Icons.waves),
              label: const Text('Analyze'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_result.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _result.entries
                    .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.key.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.value.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  double _getDefaultFrequency() {
    switch (_selectedType) {
      case 'FM Radio':
        return 100.0;
      case 'AM Radio':
        return 1000.0;
      case 'WiFi':
        return 2400.0;
      case 'Cellular':
        return 1800.0;
      case 'Bluetooth':
        return 2400.0;
      default:
        return 100.0;
    }
  }
}