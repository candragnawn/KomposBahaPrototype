/// Validator form dengan pesan yang jelas & sopan.
abstract class Validators {
  static String normalizePhone(String raw) {
    var d = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.startsWith('62')) d = '0${d.substring(2)}';
    if (d.startsWith('8')) d = '0$d';
    return d;
  }

  static String? required(String? v, {String label = 'Kolom ini'}) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
    if (v.trim().length < 3) return 'Nama terlalu pendek';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nomor HP wajib diisi';
    final d = normalizePhone(v);
    if (!d.startsWith('08')) return 'Nomor HP harus diawali 08';
    if (d.length < 10 || d.length > 14) return 'Nomor HP 10–14 angka';
    return null;
  }

  static String? pin(String? v) {
    if (v == null || v.isEmpty) return 'PIN wajib diisi';
    if (!RegExp(r'^[0-9]{6}$').hasMatch(v)) return 'PIN harus 6 angka';
    return null;
  }

  static String? positiveNumber(String? v, {String label = 'Angka', double max = 100000}) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    final n = double.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null) return '$label harus berupa angka';
    if (n <= 0) return '$label harus lebih dari 0';
    if (n > max) return '$label terlalu besar';
    return null;
  }
}
