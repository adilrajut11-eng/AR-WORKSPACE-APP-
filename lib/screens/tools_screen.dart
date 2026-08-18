import 'package:flutter/material.dart';
import '../services/tools_service.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({Key? key}) : super(key: key);

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  int _selectedTool = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Password Generator
        Card(
          child: ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('Password Generator'),
            subtitle: const Text('Generate strong passwords'),
            onTap: () => _showPasswordGenerator(context),
          ),
        ),
        const SizedBox(height: 12),
        // Text Analyzer
        Card(
          child: ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Text Analyzer'),
            subtitle: const Text('Analyze text statistics'),
            onTap: () => _showTextAnalyzer(context),
          ),
        ),
        const SizedBox(height: 12),
        // Email Validator
        Card(
          child: ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email Validator'),
            subtitle: const Text('Validate email addresses'),
            onTap: () => _showEmailValidator(context),
          ),
        ),
        const SizedBox(height: 12),
        // URL Validator
        Card(
          child: ListTile(
            leading: const Icon(Icons.link),
            title: const Text('URL Validator'),
            subtitle: const Text('Check URL validity'),
            onTap: () => _showURLValidator(context),
          ),
        ),
        const SizedBox(height: 12),
        // Color Converter
        Card(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Color Converter'),
            subtitle: const Text('Convert between color formats'),
            onTap: () => _showColorConverter(context),
          ),
        ),
      ],
    );
  }

  void _showPasswordGenerator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Generator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              ToolsService.generatePassword(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextAnalyzer(BuildContext context) {
    TextEditingController controller = TextEditingController();
    Map<String, dynamic> result = {};

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Analyzer'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Enter text',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(
                    () => result = ToolsService.analyzeText(value),
                  ),
                ),
                if (result.isNotEmpty) ...
                  [
                    const SizedBox(height: 12),
                    ...result.entries
                        .map((e) => Text('${e.key}: ${e.value}'))
                        .toList(),
                  ],
              ],
            ),
          ),
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _showEmailValidator(BuildContext context) {
    TextEditingController controller = TextEditingController();
    bool isValid = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Validator'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(
                  () => isValid = ToolsService.isValidEmail(value),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isValid ? '✅ Valid Email' : '❌ Invalid Email',
                style: TextStyle(
                  color: isValid ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _showURLValidator(BuildContext context) {
    TextEditingController controller = TextEditingController();
    bool isValid = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('URL Validator'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter URL',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(
                  () => isValid = ToolsService.isValidUrl(value),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isValid ? '✅ Valid URL' : '❌ Invalid URL',
                style: TextStyle(
                  color: isValid ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _showColorConverter(BuildContext context) {
    TextEditingController controller = TextEditingController();
    Map<String, String> result = {};

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Color Converter'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter hex color (e.g., #FF0000)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(
                  () => result = ToolsService.colorConverter(value),
                ),
              ),
              if (result.isNotEmpty && !result.containsKey('error')) ...
                [
                  const SizedBox(height: 12),
                  ...result.entries
                      .map((e) => Text('${e.key}: ${e.value}'))
                      .toList(),
                ],
            ],
          ),
        ),
        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}