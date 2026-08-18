import 'dart:math';

class ToolsService {
  // Generate strong password
  static String generatePassword({
    int length = 16,
    bool useUppercase = true,
    bool useLowercase = true,
    bool useNumbers = true,
    bool useSpecial = true,
  }) {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (useLowercase) chars += lowercase;
    if (useUppercase) chars += uppercase;
    if (useNumbers) chars += numbers;
    if (useSpecial) chars += special;

    if (chars.isEmpty) chars = lowercase;

    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Check password strength
  static Map<String, dynamic> checkPasswordStrength(String password) {
    int score = 0;
    List<String> feedback = [];

    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;

    if (password.contains(RegExp(r'[a-z]'))) score += 1;
    if (password.contains(RegExp(r'[A-Z]'))) score += 1;
    if (password.contains(RegExp(r'[0-9]'))) score += 1;
    if (password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'))) score += 1;

    String strength = 'Very Weak';
    if (score >= 6) strength = 'Strong';
    if (score >= 5) strength = 'Medium';
    if (score >= 3) strength = 'Weak';

    if (password.length < 8) feedback.add('Use at least 8 characters');
    if (!password.contains(RegExp(r'[a-z]'))) feedback.add('Add lowercase letters');
    if (!password.contains(RegExp(r'[A-Z]'))) feedback.add('Add uppercase letters');
    if (!password.contains(RegExp(r'[0-9]'))) feedback.add('Add numbers');
    if (!password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]')))
      feedback.add('Add special characters');

    return {
      'strength': strength,
      'score': score,
      'feedback': feedback,
    };
  }

  // Email validator
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
    );
    return emailRegex.hasMatch(email);
  }

  // URL validator
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  // IP Address validator
  static bool isValidIP(String ip) {
    final ipRegex = RegExp(
      r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}'
      r'([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$',
    );
    return ipRegex.hasMatch(ip);
  }

  // Text statistics
  static Map<String, dynamic> analyzeText(String text) {
    return {
      'characters': text.length,
      'charactersNoSpaces': text.replaceAll(' ', '').length,
      'words': text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length,
      'lines': text.isEmpty ? 0 : text.split('\n').length,
      'sentences': text.split(RegExp(r'[.!?]')).where((s) => s.isNotEmpty).length,
      'paragraphs': text.split(RegExp(r'\n\n')).where((s) => s.isNotEmpty).length,
      'avgWordLength': text.trim().isEmpty
          ? 0
          : (text.replaceAll(' ', '').length /
              text.trim().split(RegExp(r'\s+')).length)
          .toStringAsFixed(2),
    };
  }

  // Color converter
  static Map<String, String> colorConverter(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        int r = int.parse(hex.substring(0, 2), radix: 16);
        int g = int.parse(hex.substring(2, 4), radix: 16);
        int b = int.parse(hex.substring(4, 6), radix: 16);
        return {
          'hex': '#$hex',
          'rgb': 'rgb($r, $g, $b)',
          'hsl': _rgbToHsl(r, g, b),
        };
      }
    } catch (e) {
      return {'error': 'Invalid color'};
    }
    return {'error': 'Invalid format'};
  }

  static String _rgbToHsl(int r, int g, int b) {
    r ~/= 255;
    g ~/= 255;
    b ~/= 255;
    int max = [r, g, b].reduce((a, b) => a > b ? a : b);
    int min = [r, g, b].reduce((a, b) => a < b ? a : b);
    int l = ((max + min) / 2).toInt();
    if (max == min) {
      return 'hsl(0, 0%, $l%)';
    }
    int s = ((max - min) / (2 - max - min)).toInt();
    return 'hsl(?, ${s}%, ${l}%)';
  }
}