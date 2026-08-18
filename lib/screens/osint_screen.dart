import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tool_provider.dart';
import '../services/osint_service.dart';

class OSINTScreen extends StatefulWidget {
  const OSINTScreen({Key? key}) : super(key: key);

  @override
  State<OSINTScreen> createState() => _OSINTScreenState();
}

class _OSINTScreenState extends State<OSINTScreen> {
  late TextEditingController _controller;
  String _selectedType = 'IP Address';
  Map<String, dynamic> _result = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyze() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    Map<String, dynamic> result = {};

    switch (_selectedType) {
      case 'IP Address':
        result = OSINTService.analyzeIP(input);
        break;
      case 'Domain':
        result = OSINTService.analyzeDomain(input);
        break;
      case 'Email':
        result = OSINTService.analyzeEmail(input);
        break;
      case 'Phone':
        result = OSINTService.analyzePhone(input);
        break;
      case 'MAC Address':
        result = OSINTService.validateMAC(input);
        break;
    }

    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Analysis Type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            onChanged: (value) => setState(() => _selectedType = value!),
            items: ['IP Address', 'Domain', 'Email', 'Phone', 'MAC Address']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter $_selectedType',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
            onSubmitted: (_) => _analyze(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _analyze,
              icon: const Icon(Icons.analyze),
              label: const Text('Analyze'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),
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
                          SelectableText(
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
}