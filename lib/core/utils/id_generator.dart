import 'dart:math';

/// Pembuat ID & kode unik.
abstract class IdGen {
  static final Random _rand = Random.secure();
  static const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String id() {
    final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final r = List.generate(5, (_) => _chars[_rand.nextInt(_chars.length)]).join();
    return '$ts$r';
  }

  /// Kode acak, contoh: 7F3A
  static String code(int length) =>
      List.generate(length, (_) => _chars[_rand.nextInt(_chars.length)]).join();
}
