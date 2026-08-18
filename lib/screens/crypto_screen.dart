import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/crypto_service.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({Key? key}) : super(key: key);

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  late TextEditingController _controller;
  String _selectedHashType = 'MD5';
  String _result = '';

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

  void _generateHash() {
    String input = _controller.text;
    if (input.isEmpty) return;

    String hash = '';
    switch (_selectedHashType) {
      case 'MD5':
        hash = CryptoService.generateMD5(input);
        break;
      case 'SHA1':
        hash = CryptoService.generateSHA1(input);
        break;
      case 'SHA256':
        hash = CryptoService.generateSHA256(input);
        break;
      case 'SHA512':
        hash = CryptoService.generateSHA512(input);
        break;
      case 'Base64 Encode':
        hash = CryptoService.base64Encode(input);
        break;
      case 'Base64 Decode':
        hash = CryptoService.base64Decode(input);
        break;
      case 'ROT13':
        hash = CryptoService.rot13(input);
        break;
    }

    setState(() => _result = hash);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crypto Type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: _selectedHashType,
            isExpanded: true,
            onChanged: (value) => setState(() => _selectedHashType = value!),
            items: ['MD5', 'SHA1', 'SHA256', 'SHA512', 'Base64 Encode', 'Base64 Decode', 'ROT13']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => _generateHash(),
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
                children: [
                  Text(
                    'Result ($_selectedHashType)',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _result,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _result));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied!')),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _result = '');
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}