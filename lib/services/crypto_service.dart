import 'package:crypto/crypto.dart';
import 'dart:convert';

class CryptoService {
  // Generate MD5 Hash
  static String generateMD5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // Generate SHA1 Hash
  static String generateSHA1(String input) {
    return sha1.convert(utf8.encode(input)).toString();
  }

  // Generate SHA256 Hash
  static String generateSHA256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  // Generate SHA512 Hash
  static String generateSHA512(String input) {
    return sha512.convert(utf8.encode(input)).toString();
  }

  // Base64 Encode
  static String base64Encode(String input) {
    return base64.encode(utf8.encode(input));
  }

  // Base64 Decode
  static String base64Decode(String input) {
    try {
      return utf8.decode(base64.decode(input));
    } catch (e) {
      return 'Invalid Base64';
    }
  }

  // Simple Caesar Cipher Encrypt
  static String caesarEncrypt(String input, int shift) {
    String result = '';
    for (int i = 0; i < input.length; i++) {
      int charCode = input.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        result += String.fromCharCode((charCode - 65 + shift) % 26 + 65);
      } else if (charCode >= 97 && charCode <= 122) {
        result += String.fromCharCode((charCode - 97 + shift) % 26 + 97);
      } else {
        result += input[i];
      }
    }
    return result;
  }

  // Caesar Cipher Decrypt
  static String caesarDecrypt(String input, int shift) {
    return caesarEncrypt(input, 26 - shift);
  }

  // ROT13
  static String rot13(String input) {
    return caesarEncrypt(input, 13);
  }
}