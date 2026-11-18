import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Kontrak penyimpanan data Kompos Baha.
///
/// Saat ini memakai [LocalDatabaseService] (tersimpan di HP).
/// Untuk banyak perangkat (warga, driver, TPS, admin di HP berbeda),
/// buat implementasi baru (mis. Firebase / Supabase / REST API)
/// yang memenuhi kontrak ini, lalu ganti di `main.dart`.
abstract class DatabaseService {
  Future<Map<String, dynamic>?> load();
  Future<void> save(Map<String, dynamic> data);
  Future<void> clear();

  // Preferensi perangkat (bukan data bersama)
  Future<String?> getSession();
  Future<void> setSession(String? userId);
  Future<bool> getOnboardingSeen();
  Future<void> setOnboardingSeen(bool v);
  Future<double> getTextScale();
  Future<void> setTextScale(double v);
}

class LocalDatabaseService implements DatabaseService {
  static const _kData = 'kompos_baha_db_v1';
  static const _kSession = 'kompos_baha_session';
  static const _kOnboarding = 'kompos_baha_onboarding_seen';
  static const _kTextScale = 'kompos_baha_text_scale';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _p async => _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<Map<String, dynamic>?> load() async {
    final p = await _p;
    final raw = p.getString(_kData);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      // Data rusak: abaikan agar aplikasi tetap bisa dibuka.
    }
    return null;
  }

  @override
  Future<void> save(Map<String, dynamic> data) async {
    final p = await _p;
    await p.setString(_kData, jsonEncode(data));
  }

  @override
  Future<void> clear() async {
    final p = await _p;
    await p.remove(_kData);
    await p.remove(_kSession);
  }

  @override
  Future<String?> getSession() async => (await _p).getString(_kSession);

  @override
  Future<void> setSession(String? userId) async {
    final p = await _p;
    if (userId == null) {
      await p.remove(_kSession);
    } else {
      await p.setString(_kSession, userId);
    }
  }

  @override
  Future<bool> getOnboardingSeen() async => (await _p).getBool(_kOnboarding) ?? false;

  @override
  Future<void> setOnboardingSeen(bool v) async {
    await (await _p).setBool(_kOnboarding, v);
  }

  @override
  Future<double> getTextScale() async => (await _p).getDouble(_kTextScale) ?? 1.0;

  @override
  Future<void> setTextScale(double v) async {
    await (await _p).setDouble(_kTextScale, v);
  }
}

/// Penyimpanan di memori (untuk pengujian).
class MemoryDatabaseService implements DatabaseService {
  Map<String, dynamic>? _data;
  String? _session;
  bool _onboarding = false;
  double _scale = 1.0;

  @override
  Future<Map<String, dynamic>?> load() async =>
      _data == null ? null : Map<String, dynamic>.from(jsonDecode(jsonEncode(_data)) as Map);

  @override
  Future<void> save(Map<String, dynamic> data) async {
    _data = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
  }

  @override
  Future<void> clear() async {
    _data = null;
    _session = null;
  }

  @override
  Future<String?> getSession() async => _session;

  @override
  Future<void> setSession(String? userId) async {
    _session = userId;
  }

  @override
  Future<bool> getOnboardingSeen() async => _onboarding;

  @override
  Future<void> setOnboardingSeen(bool v) async {
    _onboarding = v;
  }

  @override
  Future<double> getTextScale() async => _scale;

  @override
  Future<void> setTextScale(double v) async {
    _scale = v;
  }
}
