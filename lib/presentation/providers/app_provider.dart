import 'package:flutter/foundation.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/id_generator.dart';
import '../../core/utils/security.dart';
import '../../core/utils/validators.dart';
import '../../data/models/misc_models.dart';
import '../../data/models/order_model.dart';
import '../../data/models/reward_model.dart';
import '../../data/models/settings_model.dart';
import '../../data/models/user_model.dart';
import '../../data/seed/seed_data.dart';
import '../../data/services/database_service.dart';

/// Ringkasan statistik satu bulan.
class MonthStats {
  final double verifiedKg;
  final int verifiedCount;
  final int pointsIssued;
  final int pointsRedeemed;
  final int activeWarga;
  final int rejectedCount;
  final int failedCount;
  final int newWarga;

  const MonthStats({
    this.verifiedKg = 0,
    this.verifiedCount = 0,
    this.pointsIssued = 0,
    this.pointsRedeemed = 0,
    this.activeWarga = 0,
    this.rejectedCount = 0,
    this.failedCount = 0,
    this.newWarga = 0,
  });
}

/// Rekap per kelompok (banjar / warga).
class RecapRow {
  final String key;
  final String label;
  final String sublabel;
  final int count;
  final double kg;
  final int points;

  const RecapRow({
    required this.key,
    required this.label,
    this.sublabel = '',
    required this.count,
    required this.kg,
    required this.points,
  });
}

/// Hasil operasi: [error] null berarti berhasil.
class OpResult<T> {
  final T? data;
  final String? error;
  const OpResult.ok(this.data) : error = null;
  const OpResult.fail(this.error) : data = null;
  bool get isOk => error == null;
}

/// Pusat data & logika bisnis Kompos Baha.
class AppProvider extends ChangeNotifier {
  AppProvider({DatabaseService? database}) : _db = database ?? LocalDatabaseService();

  final DatabaseService _db;

  // ─── State ─────────────────────────────────────────────────────────────
  bool _ready = false;
  bool _onboardingSeen = false;
  double _textScale = 1.0;
  String? _sessionId;

  List<AppUser> _users = [];
  List<PickupOrder> _orders = [];
  List<Reward> _rewards = [];
  List<Redemption> _redemptions = [];
  List<LedgerEntry> _ledger = [];
  List<Complaint> _complaints = [];
  List<AppNotification> _notifications = [];
  List<Announcement> _announcements = [];
  AppSettings _settings = const AppSettings();

  Future<void> _saveChain = Future<void>.value();

  // ─── Getters ───────────────────────────────────────────────────────────
  bool get isReady => _ready;
  bool get onboardingSeen => _onboardingSeen;
  double get textScale => _textScale;
  AppSettings get settings => _settings;

  List<AppUser> get users => List.unmodifiable(_users);
  List<PickupOrder> get orders => List.unmodifiable(_orders);
  List<Reward> get rewards => List.unmodifiable(_rewards);
  List<Redemption> get redemptions => List.unmodifiable(_redemptions);
  List<Complaint> get complaints => List.unmodifiable(_complaints);
  List<Announcement> get announcements => List.unmodifiable(_announcements);

  AppUser? get currentUser => _sessionId == null ? null : userById(_sessionId!);
  bool get isLoggedIn => currentUser != null;

  static T? _first<T>(Iterable<T> items, bool Function(T) test) {
    for (final e in items) {
      if (test(e)) return e;
    }
    return null;
  }

  AppUser? userById(String? id) => id == null ? null : _first(_users, (u) => u.id == id);
  PickupOrder? orderById(String id) => _first(_orders, (o) => o.id == id);
  Reward? rewardById(String id) => _first(_rewards, (r) => r.id == id);

  // ─── Init & persistence ────────────────────────────────────────────────
  Future<void> init() async {
    try {
      final data = await _db.load();
      if (data == null) {
        _seedBase();
        await _db.save(_toJson());
      } else {
        _fromJson(data);
        if (_users.where((u) => u.role == UserRole.admin).isEmpty) {
          // Pengaman: pastikan selalu ada admin.
          _users.addAll(SeedData.baseUsers(DateTime.now()).where((u) => u.role == UserRole.admin));
        }
      }
      _onboardingSeen = await _db.getOnboardingSeen();
      _textScale = await _db.getTextScale();
      final s = await _db.getSession();
      final u = userById(s);
      if (u != null && u.isActive) {
        _sessionId = u.id;
      } else if (s != null) {
        await _db.setSession(null);
      }
      _housekeeping();
    } catch (e) {
      debugPrint('Init error: $e');
      _seedBase();
    }
    _ready = true;
    notifyListeners();
  }

  void _seedBase() {
    final now = DateTime.now();
    _users = SeedData.baseUsers(now);
    _rewards = SeedData.baseRewards(now);
    _announcements = SeedData.baseAnnouncements(now);
    _settings = SeedData.baseSettings(now);
    _orders = [];
    _redemptions = [];
    _ledger = [];
    _complaints = [];
    _notifications = [];
  }

  Map<String, dynamic> _toJson() => {
        'version': 1,
        'users': _users.map((e) => e.toJson()).toList(),
        'orders': _orders.map((e) => e.toJson()).toList(),
        'rewards': _rewards.map((e) => e.toJson()).toList(),
        'redemptions': _redemptions.map((e) => e.toJson()).toList(),
        'ledger': _ledger.map((e) => e.toJson()).toList(),
        'complaints': _complaints.map((e) => e.toJson()).toList(),
        'notifications': _notifications.map((e) => e.toJson()).toList(),
        'announcements': _announcements.map((e) => e.toJson()).toList(),
        'settings': _settings.toJson(),
      };

  List<T> _list<T>(dynamic raw, T Function(Map<String, dynamic>) f) {
    if (raw is! List) return <T>[];
    final out = <T>[];
    for (final e in raw) {
      if (e is Map) {
        try {
          out.add(f(Map<String, dynamic>.from(e)));
        } catch (_) {}
      }
    }
    return out;
  }

  void _fromJson(Map<String, dynamic> j) {
    _users = _list(j['users'], AppUser.fromJson);
    _orders = _list(j['orders'], PickupOrder.fromJson);
    _rewards = _list(j['rewards'], Reward.fromJson);
    _redemptions = _list(j['redemptions'], Redemption.fromJson);
    _ledger = _list(j['ledger'], LedgerEntry.fromJson);
    _complaints = _list(j['complaints'], Complaint.fromJson);
    _notifications = _list(j['notifications'], AppNotification.fromJson);
    _announcements = _list(j['announcements'], Announcement.fromJson);
    final s = j['settings'];
    _settings = s is Map ? AppSettings.fromJson(Map<String, dynamic>.from(s)) : SeedData.baseSettings(DateTime.now());
  }

  /// Simpan & beri tahu UI.
  void _commit() {
    notifyListeners();
    final snapshot = _toJson();
    _saveChain = _saveChain.then((_) => _db.save(snapshot)).catchError((Object e) {
      debugPrint('Save error: $e');
    });
  }

  /// Menunggu semua penyimpanan selesai (dipakai di pengujian).
  Future<void> flush() => _saveChain;

  /// Tugas rutin: kode penukaran kedaluwarsa → poin & stok dikembalikan.
  void _housekeeping() {
    final now = DateTime.now();
    bool changed = false;
    for (int i = 0; i < _redemptions.length; i++) {
      final r = _redemptions[i];
      if (r.status == RedemptionStatus.menunggu && now.isAfter(r.expiresAt)) {
        _redemptions[i] = r.copyWith(status: RedemptionStatus.kedaluwarsa, completedAt: now);
        _refundRedemption(r, 'Kode ${r.code} kedaluwarsa');
        changed = true;
      }
    }
    // Batasi jumlah notifikasi tersimpan
    if (_notifications.length > 400) {
      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _notifications = _notifications.take(300).toList();
      changed = true;
    }
    if (changed) _commit();
  }

  // ─── Preferensi perangkat ──────────────────────────────────────────────
  Future<void> completeOnboarding() async {
    _onboardingSeen = true;
    notifyListeners();
    await _db.setOnboardingSeen(true);
  }

  Future<void> setTextScale(double v) async {
    _textScale = v;
    notifyListeners();
    await _db.setTextScale(v);
  }

  // ─── Autentikasi ───────────────────────────────────────────────────────
  AppUser? userByPhone(String phoneRaw) {
    final phone = Validators.normalizePhone(phoneRaw);
    return _first(_users, (u) => u.phone == phone);
  }

  Future<String?> login(String phoneRaw, String pin) async {
    final u = userByPhone(phoneRaw);
    if (u == null) return 'Nomor HP belum terdaftar. Silakan daftar terlebih dahulu.';
    if (!u.isActive) return 'Akun Anda sedang dinonaktifkan. Silakan hubungi Admin Desa.';
    if (u.pinHash != Security.hashPin(u.id, pin)) return 'PIN salah. Silakan periksa kembali.';
    _sessionId = u.id;
    _housekeeping();
    notifyListeners();
    await _db.setSession(u.id);
    return null;
  }

  Future<String?> register({
    required String name,
    required String phone,
    required String pin,
    required String banjar,
    required String address,
  }) async {
    final p = Validators.normalizePhone(phone);
    if (userByPhone(p) != null) return 'Nomor HP ini sudah terdaftar. Silakan masuk.';
    final id = IdGen.id();
    final user = AppUser(
      id: id,
      name: name.trim(),
      phone: p,
      pinHash: Security.hashPin(id, pin),
      role: UserRole.warga,
      banjar: banjar,
      address: address.trim(),
      createdAt: DateTime.now(),
    );
    _users.add(user);
    _sessionId = id;
    _notify(id, 'Selamat datang, ${user.name}!',
        'Akun Kompos Baha Anda sudah aktif. Yuk setor kompos pertama Anda dan kumpulkan poin.', 'info');
    _notifyRole(UserRole.admin, 'Warga baru terdaftar', '${user.name} (Banjar $banjar) baru saja mendaftar.', 'info');
    _commit();
    await _db.setSession(id);
    return null;
  }

  Future<void> logout() async {
    _sessionId = null;
    notifyListeners();
    await _db.setSession(null);
  }

  String? changePin(String oldPin, String newPin) {
    final u = currentUser;
    if (u == null) return 'Sesi berakhir, silakan masuk kembali.';
    if (u.pinHash != Security.hashPin(u.id, oldPin)) return 'PIN lama salah.';
    if (oldPin == newPin) return 'PIN baru harus berbeda dari PIN lama.';
    _replaceUser(u.copyWith(pinHash: Security.hashPin(u.id, newPin)));
    _commit();
    return null;
  }

  String? updateProfile({required String name, required String address, String? banjar, String? vehicle}) {
    final u = currentUser;
    if (u == null) return 'Sesi berakhir, silakan masuk kembali.';
    _replaceUser(u.copyWith(name: name.trim(), address: address.trim(), banjar: banjar, vehicle: vehicle));
    _commit();
    return null;
  }

  void _replaceUser(AppUser u) {
    final i = _users.indexWhere((e) => e.id == u.id);
    if (i >= 0) _users[i] = u;
  }

  void _replaceOrder(PickupOrder o) {
    final i = _orders.indexWhere((e) => e.id == o.id);
    if (i >= 0) _orders[i] = o;
  }

  // ─── Notifikasi ────────────────────────────────────────────────────────
  void _notify(String userId, String title, String body, String type) {
    _notifications.insert(
      0,
      AppNotification(
        id: IdGen.id(),
        userId: userId,
        title: title,
        body: body,
        type: type,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _notifyRole(UserRole role, String title, String body, String type) {
    for (final u in _users.where((u) => u.role == role && u.isActive)) {
      _notify(u.id, title, body, type);
    }
  }

  List<AppNotification> notificationsFor(String userId) {
    final list = _notifications.where((n) => n.userId == userId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int unreadCount(String userId) => _notifications.where((n) => n.userId == userId && !n.isRead).length;

  void markNotificationRead(String id) {
    final i = _notifications.indexWhere((n) => n.id == id);
    if (i >= 0 && !_notifications[i].isRead) {
      _notifications[i] = _notifications[i].markRead();
      _commit();
    }
  }

  void markAllNotificationsRead(String userId) {
    bool changed = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (_notifications[i].userId == userId && !_notifications[i].isRead) {
        _notifications[i] = _notifications[i].markRead();
        changed = true;
      }
    }
    if (changed) _commit();
  }

  // ─── Jadwal & kuota ────────────────────────────────────────────────────
  bool isServiceDay(DateTime d) => _settings.serviceDays.contains(d.weekday);

  double bookedKg(DateTime date) {
    double sum = 0;
    for (final o in _orders) {
      if (o.status.countsForQuota && Fmt.sameDay(o.pickupDate, date)) {
        sum += o.officialKg ?? o.estimatedKg;
      }
    }
    return sum;
  }

  double quotaRemaining(DateTime date) {
    final r = _settings.dailyQuotaKg - bookedKg(date);
    return r < 0 ? 0 : r;
  }

  /// 7 hari layanan ke depan (hari ini masih bisa jika sebelum jam 12.00).
  List<DateTime> availablePickupDates() {
    final now = DateTime.now();
    var d = Fmt.dateOnly(now);
    if (now.hour >= 12) d = d.add(const Duration(days: 1));
    final out = <DateTime>[];
    int guard = 0;
    while (out.length < 7 && guard < 30) {
      if (isServiceDay(d)) out.add(d);
      d = d.add(const Duration(days: 1));
      guard++;
    }
    return out;
  }

  // ─── Setoran (Warga) ───────────────────────────────────────────────────
  String _nextOrderCode() {
    int maxNo = 400;
    for (final o in _orders) {
      final n = int.tryParse(o.code.replaceAll(RegExp(r'[^0-9]'), ''));
      if (n != null && n > maxNo) maxNo = n;
    }
    return 'KB-${(maxNo + 1).toString().padLeft(4, '0')}';
  }

  List<PickupOrder> ordersOfWarga(String wargaId) {
    final l = _orders.where((o) => o.wargaId == wargaId).toList();
    l.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return l;
  }

  List<PickupOrder> activeOrdersOfWarga(String wargaId) =>
      ordersOfWarga(wargaId).where((o) => o.status.isActive).toList();

  OpResult<PickupOrder> createOrder({
    required double estimatedKg,
    required DateTime pickupDate,
    required String timeSlot,
    required String address,
    required String notes,
    required String? photoPath,
  }) {
    final u = currentUser;
    if (u == null || u.role != UserRole.warga) return const OpResult.fail('Hanya warga yang dapat menyetor kompos.');
    if (estimatedKg < 1) return const OpResult.fail('Berat minimal 1 kg.');
    if (estimatedKg > 100) return const OpResult.fail('Berat maksimal 100 kg per setoran.');
    if (photoPath == null || photoPath.isEmpty) return const OpResult.fail('Foto kompos wajib ditambahkan.');
    if (address.trim().isEmpty) return const OpResult.fail('Alamat penjemputan wajib diisi.');
    if (timeSlot.isEmpty) return const OpResult.fail('Pilih jam penjemputan.');
    if (!isServiceDay(pickupDate)) return const OpResult.fail('Tanggal tersebut bukan hari layanan.');
    final active = activeOrdersOfWarga(u.id).length;
    if (active >= _settings.maxActiveOrders) {
      return OpResult.fail('Anda masih punya $active setoran yang berjalan. Tunggu hingga selesai sebelum membuat setoran baru.');
    }
    final remaining = quotaRemaining(pickupDate);
    if (estimatedKg > remaining) {
      return OpResult.fail(remaining <= 0
          ? 'Kuota TPS 3R pada tanggal ini sudah penuh. Silakan pilih tanggal lain.'
          : 'Kuota tanggal ini tinggal ${Fmt.kg(remaining)} kg. Kurangi berat atau pilih tanggal lain.');
    }
    final now = DateTime.now();
    final order = PickupOrder(
      id: IdGen.id(),
      code: _nextOrderCode(),
      wargaId: u.id,
      wargaName: u.name,
      wargaPhone: u.phone,
      banjar: u.banjar,
      address: address.trim(),
      estimatedKg: estimatedKg,
      pickupDate: Fmt.dateOnly(pickupDate),
      timeSlot: timeSlot,
      notes: notes.trim(),
      photoWarga: photoPath,
      logs: [StatusLog(status: OrderStatus.menunggu, at: now, actor: u.name)],
      createdAt: now,
      updatedAt: now,
    );
    _orders.insert(0, order);
    final msg = '${u.name} (Banjar ${u.banjar}) menyetor ±${Fmt.kg(estimatedKg)} kg untuk ${Fmt.date(pickupDate)}, $timeSlot.';
    _notifyRole(UserRole.tps, 'Setoran baru ${order.code}', msg, 'order');
    _notifyRole(UserRole.admin, 'Setoran baru ${order.code}', msg, 'order');
    _commit();
    return OpResult.ok(order);
  }

  String? cancelOrder(String orderId, String reason) {
    final o = orderById(orderId);
    final u = currentUser;
    if (o == null || u == null) return 'Data setoran tidak ditemukan.';
    if (o.status != OrderStatus.menunggu && o.status != OrderStatus.ditugaskan) {
      return 'Setoran yang sudah dijemput tidak bisa dibatalkan.';
    }
    final isOwner = o.wargaId == u.id;
    if (!isOwner && u.role != UserRole.admin && u.role != UserRole.tps) return 'Anda tidak berhak membatalkan setoran ini.';
    final now = DateTime.now();
    _replaceOrder(o.copyWith(
      status: OrderStatus.dibatalkan,
      cancelReason: reason,
      logs: [...o.logs, StatusLog(status: OrderStatus.dibatalkan, at: now, actor: u.name, note: reason)],
      updatedAt: now,
    ));
    if (o.driverId != null) {
      _notify(o.driverId!, 'Tugas ${o.code} dibatalkan', 'Setoran ${o.wargaName} dibatalkan: $reason', 'order');
    }
    if (!isOwner) {
      _notify(o.wargaId, 'Setoran ${o.code} dibatalkan', 'Dibatalkan oleh ${u.role.label}: $reason', 'order');
    } else {
      _notifyRole(UserRole.tps, 'Setoran ${o.code} dibatalkan warga', '${o.wargaName}: $reason', 'order');
    }
    _commit();
    return null;
  }

  // ─── Penugasan driver (TPS/Admin) ──────────────────────────────────────
  List<AppUser> get drivers => _users.where((u) => u.role == UserRole.driver).toList();
  List<AppUser> get activeDrivers => drivers.where((d) => d.isActive).toList();

  int driverLoad(String driverId, DateTime date) => _orders
      .where((o) => o.driverId == driverId && o.status.isActive && Fmt.sameDay(o.pickupDate, date))
      .length;

  String? assignDriver(String orderId, String driverId) {
    final o = orderById(orderId);
    final d = userById(driverId);
    final u = currentUser;
    if (o == null || d == null || u == null) return 'Data tidak ditemukan.';
    if (u.role != UserRole.admin && u.role != UserRole.tps) return 'Anda tidak berhak menugaskan driver.';
    if (!d.isActive) return 'Driver ini sedang nonaktif.';
    if (o.status != OrderStatus.menunggu && o.status != OrderStatus.ditugaskan) {
      return 'Setoran ini sudah tidak bisa ditugaskan ulang.';
    }
    final previous = o.driverId;
    final now = DateTime.now();
    _replaceOrder(o.copyWith(
      driverId: d.id,
      driverName: d.name,
      status: OrderStatus.ditugaskan,
      logs: [...o.logs, StatusLog(status: OrderStatus.ditugaskan, at: now, actor: u.name, note: 'Driver: ${d.name}')],
      updatedAt: now,
    ));
    if (previous != null && previous != d.id) {
      _notify(previous, 'Tugas ${o.code} dialihkan', 'Tugas penjemputan ${o.wargaName} dialihkan ke driver lain.', 'order');
    }
    _notify(d.id, 'Tugas baru ${o.code}',
        'Jemput kompos ${o.wargaName} (±${Fmt.kg(o.estimatedKg)} kg) — ${Fmt.relativeDay(o.pickupDate)}, ${o.timeSlot}. ${o.address}', 'order');
    _notify(o.wargaId, 'Driver sudah ditugaskan',
        '${d.name} akan menjemput kompos Anda ${Fmt.relativeDay(o.pickupDate).toLowerCase()} pukul ${o.timeSlot}.', 'order');
    _commit();
    return null;
  }

  // ─── Driver ────────────────────────────────────────────────────────────
  List<PickupOrder> ordersOfDriver(String driverId) {
    final l = _orders.where((o) => o.driverId == driverId).toList();
    l.sort((a, b) {
      final c = a.pickupDate.compareTo(b.pickupDate);
      return c != 0 ? c : a.timeSlot.compareTo(b.timeSlot);
    });
    return l;
  }

  void setDriverAvailability(bool available) {
    final u = currentUser;
    if (u == null || u.role != UserRole.driver) return;
    _replaceUser(u.copyWith(isAvailable: available));
    _commit();
  }

  String? _driverGuard(PickupOrder? o) {
    final u = currentUser;
    if (o == null || u == null) return 'Data tidak ditemukan.';
    if (u.role == UserRole.driver && o.driverId != u.id) return 'Tugas ini bukan milik Anda.';
    return null;
  }

  String? startPickup(String orderId) {
    final o = orderById(orderId);
    final err = _driverGuard(o);
    if (err != null) return err;
    if (o!.status != OrderStatus.ditugaskan) return 'Tugas ini tidak dalam status siap dijemput.';
    final now = DateTime.now();
    _replaceOrder(o.copyWith(
      status: OrderStatus.dijemput,
      logs: [...o.logs, StatusLog(status: OrderStatus.dijemput, at: now, actor: currentUser!.name)],
      updatedAt: now,
    ));
    _notify(o.wargaId, 'Driver sedang menuju rumah Anda',
        '${o.driverName ?? 'Driver'} sedang dalam perjalanan untuk menjemput kompos ${o.code}.', 'order');
    _commit();
    return null;
  }

  String? confirmCollected(String orderId, String? photoPath) {
    final o = orderById(orderId);
    final err = _driverGuard(o);
    if (err != null) return err;
    if (o!.status != OrderStatus.dijemput) return 'Mulai penjemputan terlebih dahulu.';
    if (photoPath == null || photoPath.isEmpty) return 'Foto bukti pengambilan wajib ditambahkan.';
    _replaceOrder(o.copyWith(collected: true, photoPickup: photoPath));
    _notify(o.wargaId, 'Kompos sudah diambil', 'Kompos ${o.code} sudah diambil driver dan sedang dibawa ke TPS 3R.', 'order');
    _commit();
    return null;
  }

  String? confirmDelivered(String orderId) {
    final o = orderById(orderId);
    final err = _driverGuard(o);
    if (err != null) return err;
    if (o!.status != OrderStatus.dijemput || !o.collected) return 'Konfirmasi pengambilan terlebih dahulu.';
    final now = DateTime.now();
    _replaceOrder(o.copyWith(
      status: OrderStatus.diantar,
      logs: [...o.logs, StatusLog(status: OrderStatus.diantar, at: now, actor: currentUser!.name)],
      updatedAt: now,
    ));
    _notifyRole(UserRole.tps, 'Kompos ${o.code} tiba', 'Kompos ${o.wargaName} (±${Fmt.kg(o.estimatedKg)} kg) siap ditimbang.', 'order');
    _notify(o.wargaId, 'Kompos tiba di TPS 3R', 'Kompos ${o.code} sudah sampai di TPS 3R dan akan segera ditimbang.', 'order');
    _commit();
    return null;
  }

  String? failPickup(String orderId, String reason) {
    final o = orderById(orderId);
    final err = _driverGuard(o);
    if (err != null) return err;
    if (o!.status != OrderStatus.ditugaskan && o.status != OrderStatus.dijemput) {
      return 'Status tugas ini tidak bisa dilaporkan gagal.';
    }
    final now = DateTime.now();
    _replaceOrder(o.copyWith(
      status: OrderStatus.gagal,
      failureReason: reason,
      logs: [...o.logs, StatusLog(status: OrderStatus.gagal, at: now, actor: currentUser!.name, note: reason)],
      updatedAt: now,
    ));
    _notify(o.wargaId, 'Penjemputan ${o.code} gagal', 'Alasan: $reason. Silakan buat setoran baru atau hubungi Admin Desa.', 'order');
    _notifyRole(UserRole.admin, 'Gagal jemput ${o.code}', '${o.driverName ?? 'Driver'}: $reason', 'order');
    _notifyRole(UserRole.tps, 'Gagal jemput ${o.code}', '${o.driverName ?? 'Driver'}: $reason', 'order');
    _commit();
    return null;
  }

  // ─── TPS 3R: timbang & verifikasi ──────────────────────────────────────
  /// Hitung poin: (poin dasar, bonus).
  (int, int) calculatePoints(double kg, CompostQuality quality) {
    double base = kg * _settings.pointsPerKg;
    if (quality == CompostQuality.cukup) base = base * _settings.cukupPercent / 100;
    final bonus = (quality == CompostQuality.baik && kg >= _settings.bonusMinKg) ? _settings.bonusPoints : 0;
    return (base.round(), bonus);
  }

  String? verifyOrder({
    required String orderId,
    required double officialKg,
    required CompostQuality quality,
    required List<String> checklist,
    String? photoPath,
  }) {
    final o = orderById(orderId);
    final u = currentUser;
    if (o == null || u == null) return 'Data tidak ditemukan.';
    if (u.role != UserRole.tps && u.role != UserRole.admin) return 'Hanya petugas TPS 3R yang dapat memverifikasi.';
    if (o.status != OrderStatus.diantar) return 'Kompos ini belum tiba di TPS 3R.';
    if (officialKg <= 0 || officialKg > 200) return 'Berat timbangan tidak valid.';
    final warga = userById(o.wargaId);
    if (warga == null) return 'Akun warga tidak ditemukan.';

    final (pts, bonus) = calculatePoints(officialKg, quality);
    final total = pts + bonus;
    final now = DateTime.now();
    _replaceOrder(o.copyWith(
      status: OrderStatus.selesai,
      officialKg: officialKg,
      quality: quality,
      checklist: checklist,
      photoTps: photoPath,
      pointsEarned: pts,
      bonusPoints: bonus,
      logs: [
        ...o.logs,
        StatusLog(
          status: OrderStatus.selesai,
          at: now,
          actor: u.name,
          note: '${Fmt.kg(officialKg)} kg, kualitas ${quality.label}, +$total poin',
        ),
      ],
      updatedAt: now,
    ));
    final newBalance = warga.points + total;
    _replaceUser(warga.copyWith(points: newBalance));
    _ledger.insert(
      0,
      LedgerEntry(
        id: IdGen.id(),
        wargaId: warga.id,
        description: 'Setoran ${o.code} (${Fmt.kg(officialKg)} kg)',
        delta: total,
        balanceAfter: newBalance,
        type: 'setor',
        createdAt: now,
      ),
    );
    _notify(warga.id, 'Poin masuk +${Fmt.number(total)}',
        'Kompos ${o.code} ditimbang ${Fmt.kg(officialKg)} kg (kualitas ${quality.label}). Saldo Anda kini ${Fmt.number(newBalance)} poin.',
        'points');
    _commit();
    return null;
  }

  String? rejectOrder(String orderId, String reason) {
    final o = orderById(orderId);
    final u = currentUser;
    if (o == null || u == null) return 'Data tidak ditemukan.';
    if (u.role != UserRole.tps && u.role != UserRole.admin) return 'Hanya petugas TPS 3R yang dapat menolak.';
    if (o.status != OrderStatus.diantar) return 'Kompos ini belum tiba di TPS 3R.';
    final now = DateTime.now();
    _replaceOrder(o.copyWith(
      status: OrderStatus.ditolak,
      rejectionReason: reason,
      logs: [...o.logs, StatusLog(status: OrderStatus.ditolak, at: now, actor: u.name, note: reason)],
      updatedAt: now,
    ));
    _notify(o.wargaId, 'Kompos ${o.code} ditolak',
        'Alasan: $reason. Lihat Panduan Kompos agar setoran berikutnya diterima.', 'order');
    _commit();
    return null;
  }

  // ─── Poin & hadiah ─────────────────────────────────────────────────────
  List<LedgerEntry> ledgerOf(String wargaId) {
    final l = _ledger.where((e) => e.wargaId == wargaId).toList();
    l.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return l;
  }

  List<Redemption> redemptionsOf(String wargaId) {
    final l = _redemptions.where((e) => e.wargaId == wargaId).toList();
    l.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return l;
  }

  List<Reward> get activeRewards => _rewards.where((r) => r.isActive).toList()..sort((a, b) => a.price.compareTo(b.price));

  String _uniqueRedemptionCode() {
    String code;
    do {
      code = 'TKR-${IdGen.code(4)}';
    } while (_redemptions.any((r) => r.code == code));
    return code;
  }

  OpResult<Redemption> redeem(String rewardId) {
    final u = currentUser;
    final r = rewardById(rewardId);
    if (u == null || u.role != UserRole.warga) return const OpResult.fail('Hanya warga yang dapat menukar poin.');
    if (r == null || !r.isActive) return const OpResult.fail('Hadiah tidak tersedia.');
    if (r.stock <= 0) return const OpResult.fail('Stok hadiah sudah habis.');
    if (u.points < r.price) {
      return OpResult.fail('Poin belum cukup. Anda butuh ${Fmt.number(r.price - u.points)} poin lagi.');
    }
    final now = DateTime.now();
    final balance = u.points - r.price;
    _replaceUser(u.copyWith(points: balance));
    final ri = _rewards.indexWhere((e) => e.id == r.id);
    _rewards[ri] = r.copyWith(stock: r.stock - 1);
    final red = Redemption(
      id: IdGen.id(),
      code: _uniqueRedemptionCode(),
      wargaId: u.id,
      wargaName: u.name,
      rewardId: r.id,
      rewardName: r.name,
      price: r.price,
      createdAt: now,
      expiresAt: now.add(Duration(days: _settings.redemptionValidDays)),
    );
    _redemptions.insert(0, red);
    _ledger.insert(
      0,
      LedgerEntry(
        id: IdGen.id(),
        wargaId: u.id,
        description: 'Tukar ${r.name}',
        delta: -r.price,
        balanceAfter: balance,
        type: 'tukar',
        createdAt: now,
      ),
    );
    _notify(u.id, 'Penukaran berhasil',
        'Kode ${red.code} untuk ${r.name}. Ambil di Kantor Desa sebelum ${Fmt.date(red.expiresAt)}.', 'reward');
    _notifyRole(UserRole.admin, 'Penukaran baru ${red.code}', '${u.name} menukar ${r.name}.', 'reward');
    _commit();
    return OpResult.ok(red);
  }

  Redemption? findRedemptionByCode(String code) {
    final c = code.trim().toUpperCase().replaceAll(' ', '');
    final normalized = c.startsWith('TKR-') ? c : 'TKR-$c';
    return _first(_redemptions, (r) => r.code == normalized);
  }

  String? completeRedemption(String redemptionId) {
    final u = currentUser;
    final i = _redemptions.indexWhere((r) => r.id == redemptionId);
    if (u == null || i < 0) return 'Kode penukaran tidak ditemukan.';
    final r = _redemptions[i];
    if (r.status != RedemptionStatus.menunggu) return 'Kode ini berstatus "${r.status.label}".';
    if (DateTime.now().isAfter(r.expiresAt)) {
      _housekeeping();
      return 'Kode ini sudah kedaluwarsa. Poin otomatis dikembalikan ke warga.';
    }
    _redemptions[i] = r.copyWith(status: RedemptionStatus.diambil, completedAt: DateTime.now(), handledBy: u.name);
    _notify(r.wargaId, 'Hadiah sudah diambil', '${r.rewardName} (kode ${r.code}) sudah Anda terima. Terima kasih!', 'reward');
    _commit();
    return null;
  }

  void _refundRedemption(Redemption r, String description) {
    final w = userById(r.wargaId);
    if (w != null) {
      final bal = w.points + r.price;
      _replaceUser(w.copyWith(points: bal));
      _ledger.insert(
        0,
        LedgerEntry(
          id: IdGen.id(),
          wargaId: w.id,
          description: description,
          delta: r.price,
          balanceAfter: bal,
          type: 'refund',
          createdAt: DateTime.now(),
        ),
      );
      _notify(w.id, 'Poin dikembalikan', '$description. ${Fmt.number(r.price)} poin dikembalikan ke saldo Anda.', 'points');
    }
    final ri = _rewards.indexWhere((e) => e.id == r.rewardId);
    if (ri >= 0) _rewards[ri] = _rewards[ri].copyWith(stock: _rewards[ri].stock + 1);
  }

  String? cancelRedemption(String redemptionId) {
    final u = currentUser;
    final i = _redemptions.indexWhere((r) => r.id == redemptionId);
    if (u == null || i < 0) return 'Data tidak ditemukan.';
    final r = _redemptions[i];
    if (r.status != RedemptionStatus.menunggu) return 'Penukaran ini sudah tidak bisa dibatalkan.';
    if (u.role == UserRole.warga && r.wargaId != u.id) return 'Anda tidak berhak membatalkan penukaran ini.';
    _redemptions[i] = r.copyWith(status: RedemptionStatus.dibatalkan, completedAt: DateTime.now(), handledBy: u.name);
    _refundRedemption(r, 'Batal tukar ${r.rewardName}');
    _commit();
    return null;
  }

  String? upsertReward(Reward reward) {
    if (reward.name.trim().isEmpty) return 'Nama hadiah wajib diisi.';
    if (reward.price <= 0) return 'Harga poin harus lebih dari 0.';
    if (reward.stock < 0) return 'Stok tidak boleh negatif.';
    final i = _rewards.indexWhere((r) => r.id == reward.id);
    if (i >= 0) {
      _rewards[i] = reward;
    } else {
      _rewards.add(reward);
    }
    _commit();
    return null;
  }

  /// Hapus hadiah. Jika masih ada penukaran berjalan, hadiah dinonaktifkan saja.
  String deleteReward(String rewardId) {
    final pending = _redemptions.any((r) => r.rewardId == rewardId && r.status == RedemptionStatus.menunggu);
    final used = _redemptions.any((r) => r.rewardId == rewardId);
    final i = _rewards.indexWhere((r) => r.id == rewardId);
    if (i < 0) return 'Hadiah tidak ditemukan.';
    if (pending || used) {
      _rewards[i] = _rewards[i].copyWith(isActive: false);
      _commit();
      return 'Hadiah memiliki riwayat penukaran, jadi dinonaktifkan (tidak dihapus).';
    }
    _rewards.removeAt(i);
    _commit();
    return 'Hadiah dihapus.';
  }

  String? adjustPoints(String wargaId, int delta, String reason) {
    final w = userById(wargaId);
    final u = currentUser;
    if (w == null || u == null) return 'Data tidak ditemukan.';
    if (u.role != UserRole.admin) return 'Hanya Admin Desa yang dapat mengoreksi poin.';
    if (delta == 0) return 'Jumlah koreksi tidak boleh 0.';
    final bal = w.points + delta;
    if (bal < 0) return 'Saldo warga tidak boleh minus.';
    _replaceUser(w.copyWith(points: bal));
    _ledger.insert(
      0,
      LedgerEntry(
        id: IdGen.id(),
        wargaId: w.id,
        description: 'Koreksi admin: $reason',
        delta: delta,
        balanceAfter: bal,
        type: 'koreksi',
        createdAt: DateTime.now(),
      ),
    );
    _notify(w.id, 'Koreksi poin ${Fmt.signedPoints(delta)}', 'Alasan: $reason. Saldo kini ${Fmt.number(bal)} poin.', 'points');
    _commit();
    return null;
  }

  // ─── Pengguna (Admin) ──────────────────────────────────────────────────
  String? addUser({
    required String name,
    required String phone,
    required UserRole role,
    required String pin,
    String banjar = '',
    String address = '',
    String vehicle = '',
  }) {
    final p = Validators.normalizePhone(phone);
    if (userByPhone(p) != null) return 'Nomor HP sudah dipakai akun lain.';
    final id = IdGen.id();
    _users.add(AppUser(
      id: id,
      name: name.trim(),
      phone: p,
      pinHash: Security.hashPin(id, pin),
      role: role,
      banjar: banjar,
      address: address.trim(),
      vehicle: vehicle.trim(),
      createdAt: DateTime.now(),
    ));
    _notify(id, 'Selamat datang di Kompos Baha', 'Akun ${role.label} Anda sudah dibuat oleh Admin Desa.', 'info');
    _commit();
    return null;
  }

  String? updateUser(
    String id, {
    required String name,
    required String phone,
    required UserRole role,
    String banjar = '',
    String address = '',
    String vehicle = '',
  }) {
    final u = userById(id);
    if (u == null) return 'Pengguna tidak ditemukan.';
    final p = Validators.normalizePhone(phone);
    final other = userByPhone(p);
    if (other != null && other.id != id) return 'Nomor HP sudah dipakai akun lain.';
    if (u.id == _sessionId && role != u.role) return 'Anda tidak bisa mengubah peran akun sendiri.';
    _replaceUser(u.copyWith(
      name: name.trim(),
      phone: p,
      role: role,
      banjar: banjar,
      address: address.trim(),
      vehicle: vehicle.trim(),
    ));
    _commit();
    return null;
  }

  String? setUserActive(String id, bool active) {
    final u = userById(id);
    if (u == null) return 'Pengguna tidak ditemukan.';
    if (u.id == _sessionId) return 'Anda tidak bisa menonaktifkan akun sendiri.';
    if (!active && u.role == UserRole.admin) {
      final admins = _users.where((x) => x.role == UserRole.admin && x.isActive).length;
      if (admins <= 1) return 'Harus ada minimal satu Admin Desa yang aktif.';
    }
    _replaceUser(u.copyWith(isActive: active));
    _commit();
    return null;
  }

  String? resetPin(String id, String newPin) {
    final u = userById(id);
    if (u == null) return 'Pengguna tidak ditemukan.';
    _replaceUser(u.copyWith(pinHash: Security.hashPin(u.id, newPin)));
    _notify(u.id, 'PIN diatur ulang', 'PIN akun Anda telah diatur ulang oleh Admin Desa. Segera ganti PIN di menu Profil.', 'info');
    _commit();
    return null;
  }

  // ─── Pengaduan ─────────────────────────────────────────────────────────
  List<Complaint> complaintsOf(String wargaId) {
    final l = _complaints.where((c) => c.wargaId == wargaId).toList();
    l.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return l;
  }

  List<Complaint> get complaintsSorted {
    final l = [..._complaints];
    l.sort((a, b) {
      final s = a.status.index.compareTo(b.status.index);
      return s != 0 ? s : b.createdAt.compareTo(a.createdAt);
    });
    return l;
  }

  String? submitComplaint({required String topic, required String description, String orderCode = ''}) {
    final u = currentUser;
    if (u == null) return 'Sesi berakhir, silakan masuk kembali.';
    if (description.trim().length < 10) return 'Mohon jelaskan masalah minimal 10 huruf.';
    int maxNo = 0;
    for (final c in _complaints) {
      final n = int.tryParse(c.code.replaceAll(RegExp(r'[^0-9]'), ''));
      if (n != null && n > maxNo) maxNo = n;
    }
    final code = 'PGD-${(maxNo + 1).toString().padLeft(3, '0')}';
    _complaints.insert(
      0,
      Complaint(
        id: IdGen.id(),
        code: code,
        wargaId: u.id,
        wargaName: u.name,
        topic: topic,
        description: description.trim(),
        orderCode: orderCode,
        createdAt: DateTime.now(),
      ),
    );
    _notifyRole(UserRole.admin, 'Pengaduan baru $code', '${u.name}: $topic', 'complaint');
    _commit();
    return null;
  }

  String? replyComplaint(String id, String reply, ComplaintStatus status) {
    final i = _complaints.indexWhere((c) => c.id == id);
    if (i < 0) return 'Pengaduan tidak ditemukan.';
    if (reply.trim().isEmpty && status == ComplaintStatus.selesai) return 'Tulis balasan sebelum menandai selesai.';
    final c = _complaints[i];
    _complaints[i] = c.copyWith(
      status: status,
      reply: reply.trim().isEmpty ? c.reply : reply.trim(),
      repliedAt: reply.trim().isEmpty ? c.repliedAt : DateTime.now(),
    );
    _notify(c.wargaId, 'Tanggapan pengaduan ${c.code}',
        reply.trim().isEmpty ? 'Status pengaduan Anda: ${status.label}.' : reply.trim(), 'complaint');
    _commit();
    return null;
  }

  // ─── Pengumuman ────────────────────────────────────────────────────────
  List<Announcement> get activeAnnouncements {
    final l = _announcements.where((a) => a.isActive).toList();
    l.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return l;
  }

  String? upsertAnnouncement(Announcement a, {bool broadcast = false}) {
    if (a.title.trim().isEmpty) return 'Judul wajib diisi.';
    if (a.body.trim().isEmpty) return 'Isi pengumuman wajib diisi.';
    final i = _announcements.indexWhere((e) => e.id == a.id);
    if (i >= 0) {
      _announcements[i] = a;
    } else {
      _announcements.insert(0, a);
    }
    if (broadcast && a.isActive) {
      _notifyRole(UserRole.warga, a.title, a.body, 'info');
      _notifyRole(UserRole.driver, a.title, a.body, 'info');
    }
    _commit();
    return null;
  }

  void deleteAnnouncement(String id) {
    _announcements.removeWhere((a) => a.id == id);
    _commit();
  }

  // ─── Pengaturan ────────────────────────────────────────────────────────
  String? updateSettings(AppSettings next) {
    if (next.pointsPerKg <= 0) return 'Poin per kg harus lebih dari 0.';
    if (next.cukupPercent < 0 || next.cukupPercent > 100) return 'Persentase kualitas Cukup harus 0–100.';
    if (next.dailyQuotaKg <= 0) return 'Kuota harian harus lebih dari 0.';
    if (next.timeSlots.isEmpty) return 'Minimal harus ada satu jam penjemputan.';
    if (next.banjarList.isEmpty) return 'Minimal harus ada satu banjar.';
    if (next.serviceDays.isEmpty) return 'Pilih minimal satu hari layanan.';
    final rateChanged = next.pointsPerKg != _settings.pointsPerKg ||
        next.bonusMinKg != _settings.bonusMinKg ||
        next.bonusPoints != _settings.bonusPoints ||
        next.cukupPercent != _settings.cukupPercent;
    var s = next;
    if (rateChanged) {
      s = next.copyWith(rateHistory: [
        RateVersion(
          pointsPerKg: next.pointsPerKg,
          bonusMinKg: next.bonusMinKg,
          bonusPoints: next.bonusPoints,
          cukupPercent: next.cukupPercent,
          effectiveAt: DateTime.now(),
          changedBy: currentUser?.name ?? '',
        ),
        ..._settings.rateHistory,
      ]);
      _notifyRole(UserRole.warga, 'Tarif poin diperbarui',
          'Mulai hari ini: ${next.pointsPerKg} poin/kg (kualitas Baik). Bonus ${next.bonusPoints} poin untuk setoran ≥ ${Fmt.kg(next.bonusMinKg)} kg.',
          'points');
    } else {
      s = next.copyWith(rateHistory: _settings.rateHistory);
    }
    _settings = s;
    _commit();
    return null;
  }

  // ─── Statistik & laporan ───────────────────────────────────────────────
  bool _inMonth(DateTime d, DateTime month) => d.year == month.year && d.month == month.month;

  DateTime _verifiedAt(PickupOrder o) => o.timeOf(OrderStatus.selesai) ?? o.updatedAt;

  MonthStats monthStats(DateTime month) {
    double kg = 0;
    int count = 0, issued = 0, rejected = 0, failed = 0;
    final wargaSet = <String>{};
    for (final o in _orders) {
      if (o.status == OrderStatus.selesai && _inMonth(_verifiedAt(o), month)) {
        kg += o.officialKg ?? 0;
        count++;
        issued += o.totalPoints;
        wargaSet.add(o.wargaId);
      } else if (o.status == OrderStatus.ditolak && _inMonth(o.updatedAt, month)) {
        rejected++;
      } else if (o.status == OrderStatus.gagal && _inMonth(o.updatedAt, month)) {
        failed++;
      }
    }
    int redeemed = 0;
    for (final r in _redemptions) {
      if ((r.status == RedemptionStatus.menunggu || r.status == RedemptionStatus.diambil) && _inMonth(r.createdAt, month)) {
        redeemed += r.price;
      }
    }
    final newWarga = _users.where((u) => u.role == UserRole.warga && _inMonth(u.createdAt, month)).length;
    return MonthStats(
      verifiedKg: kg,
      verifiedCount: count,
      pointsIssued: issued,
      pointsRedeemed: redeemed,
      activeWarga: wargaSet.length,
      rejectedCount: rejected,
      failedCount: failed,
      newWarga: newWarga,
    );
  }

  /// Total kg terverifikasi per minggu (terlama → terbaru).
  List<(String, double)> weeklyKg({int weeks = 6}) {
    final today = Fmt.dateOnly(DateTime.now());
    final startOfThisWeek = today.subtract(Duration(days: today.weekday - 1));
    final out = <(String, double)>[];
    for (int i = weeks - 1; i >= 0; i--) {
      final start = startOfThisWeek.subtract(Duration(days: 7 * i));
      final end = start.add(const Duration(days: 7));
      double sum = 0;
      for (final o in _orders) {
        if (o.status != OrderStatus.selesai) continue;
        final t = _verifiedAt(o);
        if (!t.isBefore(start) && t.isBefore(end)) sum += o.officialKg ?? 0;
      }
      out.add((Fmt.dateShort(start), sum));
    }
    return out;
  }

  Map<OrderStatus, int> statusCounts() {
    final m = <OrderStatus, int>{for (final s in OrderStatus.values) s: 0};
    for (final o in _orders) {
      m[o.status] = (m[o.status] ?? 0) + 1;
    }
    return m;
  }

  List<RecapRow> banjarRecap(DateTime month) {
    final map = <String, RecapRow>{};
    for (final b in _settings.banjarList) {
      map[b] = RecapRow(key: b, label: b, count: 0, kg: 0, points: 0);
    }
    final wargaPerBanjar = <String, Set<String>>{};
    for (final o in _orders) {
      if (o.status != OrderStatus.selesai || !_inMonth(_verifiedAt(o), month)) continue;
      final prev = map[o.banjar] ?? RecapRow(key: o.banjar, label: o.banjar, count: 0, kg: 0, points: 0);
      map[o.banjar] = RecapRow(
        key: o.banjar,
        label: o.banjar,
        count: prev.count + 1,
        kg: prev.kg + (o.officialKg ?? 0),
        points: prev.points + o.totalPoints,
      );
      (wargaPerBanjar[o.banjar] ??= <String>{}).add(o.wargaId);
    }
    final rows = map.values
        .map((r) => RecapRow(
              key: r.key,
              label: r.label,
              sublabel: '${wargaPerBanjar[r.key]?.length ?? 0} warga',
              count: r.count,
              kg: r.kg,
              points: r.points,
            ))
        .toList();
    rows.sort((a, b) => b.kg.compareTo(a.kg));
    return rows;
  }

  /// Rekap pemasok (warga) — semua waktu atau bulan tertentu.
  List<RecapRow> supplierRecap({DateTime? month}) {
    final map = <String, RecapRow>{};
    for (final o in _orders) {
      if (o.status != OrderStatus.selesai) continue;
      if (month != null && !_inMonth(_verifiedAt(o), month)) continue;
      final prev = map[o.wargaId];
      map[o.wargaId] = RecapRow(
        key: o.wargaId,
        label: o.wargaName,
        sublabel: o.banjar,
        count: (prev?.count ?? 0) + 1,
        kg: (prev?.kg ?? 0) + (o.officialKg ?? 0),
        points: (prev?.points ?? 0) + o.totalPoints,
      );
    }
    final rows = map.values.toList()..sort((a, b) => b.kg.compareTo(a.kg));
    return rows;
  }

  double totalKgOfWarga(String wargaId, {DateTime? month}) {
    double s = 0;
    for (final o in _orders) {
      if (o.wargaId != wargaId || o.status != OrderStatus.selesai) continue;
      if (month != null && !_inMonth(_verifiedAt(o), month)) continue;
      s += o.officialKg ?? 0;
    }
    return s;
  }

  int completedCountOfWarga(String wargaId) =>
      _orders.where((o) => o.wargaId == wargaId && o.status == OrderStatus.selesai).length;

  /// Laporan CSV bulanan (bisa disalin & ditempel ke Excel/Google Sheets).
  String monthlyCsv(DateTime month) {
    final b = StringBuffer();
    b.writeln('Laporan Kompos Baha;${Fmt.monthYear(month)}');
    b.writeln();
    b.writeln('Kode;Tanggal;Warga;Banjar;Driver;Estimasi (kg);Berat resmi (kg);Kualitas;Poin;Bonus;Status');
    final list = _orders.where((o) => _inMonth(o.pickupDate, month)).toList()
      ..sort((a, b) => a.pickupDate.compareTo(b.pickupDate));
    for (final o in list) {
      b.writeln([
        o.code,
        Fmt.date(o.pickupDate),
        o.wargaName,
        o.banjar,
        o.driverName ?? '-',
        Fmt.kg(o.estimatedKg),
        o.officialKg == null ? '-' : Fmt.kg(o.officialKg!),
        o.quality?.label ?? '-',
        o.pointsEarned,
        o.bonusPoints,
        o.status.label,
      ].join(';'));
    }
    b.writeln();
    b.writeln('Rekap per banjar');
    b.writeln('Banjar;Jumlah setoran;Total (kg);Poin');
    for (final r in banjarRecap(month)) {
      b.writeln('${r.label};${r.count};${Fmt.kg(r.kg)};${r.points}');
    }
    return b.toString();
  }

  // ─── Data contoh & reset (Admin) ───────────────────────────────────────
  int loadDemoData() {
    final bundle = DemoBundle.build(
      now: DateTime.now(),
      settings: _settings,
      drivers: activeDrivers,
      rewards: _rewards.where((r) => r.isActive).toList(),
    );
    final allowedUsers = bundle.users.where((u) => userByPhone(u.phone) == null).toList();
    final ids = allowedUsers.map((u) => u.id).toSet();
    if (ids.isEmpty) return 0;
    _users.addAll(allowedUsers);
    // Kode setoran demo dibuat unik terhadap data yang sudah ada.
    final existingCodes = _orders.map((o) => o.code).toSet();
    final demoOrders = bundle.orders.where((o) => ids.contains(o.wargaId)).toList();
    for (final o in demoOrders) {
      if (existingCodes.contains(o.code)) {
        final fresh = _nextOrderCode();
        existingCodes.add(fresh);
        _orders.add(PickupOrder.fromJson({...o.toJson(), 'code': fresh}));
      } else {
        existingCodes.add(o.code);
        _orders.add(o);
      }
    }
    _ledger.addAll(bundle.ledger.where((e) => ids.contains(e.wargaId)));
    _redemptions.addAll(bundle.redemptions.where((e) => ids.contains(e.wargaId)));
    final existingComplaint = _complaints.map((c) => c.code).toSet();
    for (final c in bundle.complaints.where((e) => ids.contains(e.wargaId))) {
      if (!existingComplaint.contains(c.code)) _complaints.add(c);
    }
    _commit();
    return allowedUsers.length;
  }

  Future<void> resetAllData() async {
    await _saveChain;
    await _db.clear();
    _seedBase();
    _sessionId = null;
    await _db.save(_toJson());
    notifyListeners();
  }
}
