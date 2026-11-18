import 'dart:convert';
import 'package:crypto/crypto.dart';

/// PIN tidak pernah disimpan dalam bentuk asli.
abstract class Security {
  /// [salt] = ID pengguna (tetap walau nomor HP diganti).
  static String hashPin(String salt, String pin) {
    final bytes = utf8.encode('kompos-baha::$salt::$pin');
    return sha256.convert(bytes).toString();
  }
}
