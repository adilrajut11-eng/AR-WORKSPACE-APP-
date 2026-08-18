class OSINTService {
  // Validate and format IP
  static Map<String, dynamic> analyzeIP(String ip) {
    final ipRegex = RegExp(
      r'^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}'
      r'([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$',
    );

    if (!ipRegex.hasMatch(ip)) {
      return {'valid': false, 'error': 'Invalid IP Address'};
    }

    List<String> octets = ip.split('.');
    List<int> octetsInt = octets.map((e) => int.parse(e)).toList();

    String type = 'Public';
    if (ip.startsWith('10.') ||
        ip.startsWith('172.') && octetsInt[1] >= 16 && octetsInt[1] <= 31 ||
        ip.startsWith('192.168.')) {
      type = 'Private';
    }

    return {
      'valid': true,
      'ip': ip,
      'type': type,
      'binary': octetsInt.map((e) => e.toRadixString(2).padLeft(8, '0')).join('.'),
      'decimal': octetsInt[0] * 16777216 +
          octetsInt[1] * 65536 +
          octetsInt[2] * 256 +
          octetsInt[3],
      'hex': octetsInt.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':'),
    };
  }

  // Extract domain info
  static Map<String, dynamic> analyzeDomain(String domain) {
    domain = domain.toLowerCase().replaceAll('https://', '').replaceAll('http://', '');
    List<String> parts = domain.split('.');

    if (parts.length < 2) {
      return {'valid': false, 'error': 'Invalid domain'};
    }

    String tld = parts.last;
    String name = parts.length > 2 ? parts[parts.length - 2] : 'N/A';
    String subdomain = parts.length > 2 ? parts.sublist(0, parts.length - 2).join('.') : '';

    return {
      'valid': true,
      'domain': domain,
      'name': name,
      'tld': tld,
      'subdomain': subdomain.isEmpty ? 'None' : subdomain,
      'length': domain.length,
    };
  }

  // Analyze email
  static Map<String, dynamic> analyzeEmail(String email) {
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return {'valid': false, 'error': 'Invalid email'};
    }

    List<String> parts = email.split('@');
    String username = parts[0];
    String domain = parts[1];
    List<String> domainParts = domain.split('.');
    String provider = domainParts[0];

    return {
      'valid': true,
      'email': email,
      'username': username,
      'domain': domain,
      'provider': provider,
      'tld': domainParts.last,
    };
  }

  // Phone number analyzer
  static Map<String, dynamic> analyzePhone(String phone) {
    phone = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.length < 7) {
      return {'valid': false, 'error': 'Invalid phone number'};
    }

    String country = 'Unknown';
    if (phone.startsWith('+92')) country = 'Pakistan';
    if (phone.startsWith('+1')) country = 'USA/Canada';
    if (phone.startsWith('+44')) country = 'UK';
    if (phone.startsWith('+91')) country = 'India';
    if (phone.startsWith('+86')) country = 'China';
    if (phone.startsWith('+81')) country = 'Japan';

    return {
      'valid': true,
      'original': phone,
      'cleaned': phone,
      'length': phone.length,
      'country': country,
      'type': 'Unknown',
    };
  }

  // Generate IMEI (for testing only)
  static String generateIMEI() {
    String imei = '';
    for (int i = 0; i < 15; i++) {
      imei += (DateTime.now().millisecond % 10).toString();
    }
    return imei;
  }

  // MAC Address validator
  static Map<String, dynamic> validateMAC(String mac) {
    final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');

    if (!macRegex.hasMatch(mac)) {
      return {'valid': false, 'error': 'Invalid MAC address'};
    }

    String normalized = mac.replaceAll(':', '-').toUpperCase();
    List<String> parts = normalized.split('-');
    String oui = parts.sublist(0, 3).join('-');

    return {
      'valid': true,
      'original': mac,
      'normalized': normalized,
      'oui': oui,
      'length': mac.length,
    };
  }
}