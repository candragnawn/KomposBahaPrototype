/// Format tanggal & angka Bahasa Indonesia tanpa dependensi tambahan.
abstract class Fmt {
  static const List<String> _monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  static const List<String> _monthsLong = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  static const List<String> _days = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];

  static String monthShort(int month) => _monthsShort[month - 1];
  static String monthLong(int month) => _monthsLong[month - 1];
  static String dayName(DateTime d) => _days[d.weekday - 1];

  /// 18 Okt 2026
  static String date(DateTime d) => '${d.day} ${_monthsShort[d.month - 1]} ${d.year}';

  /// Senin, 18 Oktober 2026
  static String dateLong(DateTime d) =>
      '${dayName(d)}, ${d.day} ${_monthsLong[d.month - 1]} ${d.year}';

  /// 18 Okt
  static String dateShort(DateTime d) => '${d.day} ${_monthsShort[d.month - 1]}';

  /// 08.30
  static String time(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';

  /// 18 Okt 2026, 08.30
  static String dateTime(DateTime d) => '${date(d)}, ${time(d)}';

  /// Oktober 2026
  static String monthYear(DateTime d) => '${_monthsLong[d.month - 1]} ${d.year}';

  /// "Hari ini", "Besok", "Kemarin" atau tanggal.
  static String relativeDay(DateTime d) {
    final today = dateOnly(DateTime.now());
    final target = dateOnly(d);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Besok';
    if (diff == -1) return 'Kemarin';
    return '${dayName(d)}, ${date(d)}';
  }

  /// "5 menit lalu" dsb.
  static String ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return date(d);
  }

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// 12.840
  static String number(num value) {
    final isNeg = value < 0;
    final s = value.abs().round().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('.');
    }
    return '${isNeg ? '-' : ''}$buf';
  }

  /// 12,5 (koma desimal Indonesia, maksimal 1 angka di belakang koma)
  static String kg(double value) {
    if (value == value.roundToDouble()) return number(value);
    final fixed = value.toStringAsFixed(1);
    final parts = fixed.split('.');
    return '${number(int.parse(parts[0]))},${parts[1]}';
  }

  /// Parse "12,5" atau "12.5" menjadi double.
  static double? parseKg(String input) {
    final cleaned = input.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  /// +82 / −200
  static String signedPoints(int delta) => delta >= 0 ? '+${number(delta)}' : '−${number(delta.abs())}';

  /// 0812 3456 7890
  static String phone(String raw) {
    final d = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length < 8) return d;
    final buf = StringBuffer();
    for (int i = 0; i < d.length; i++) {
      if (i == 4 || i == 8) buf.write(' ');
      buf.write(d[i]);
    }
    return buf.toString();
  }

  /// Inisial nama: "I Wayan Sudarta" -> "WS"
  static String initials(String name) {
    final ignore = {'i', 'ni', 'ida', 'bagus', 'ayu'};
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty && !ignore.contains(p.toLowerCase()))
        .toList();
    if (parts.isEmpty) {
      final t = name.trim();
      return t.isEmpty ? '?' : t[0].toUpperCase();
    }
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// Sapaan berdasarkan jam.
  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi';
    if (h < 15) return 'Selamat siang';
    if (h < 19) return 'Selamat sore';
    return 'Selamat malam';
  }
}
