import '../../core/utils/formatters.dart';
import '../../core/utils/id_generator.dart';
import '../../core/utils/security.dart';
import '../models/misc_models.dart';
import '../models/order_model.dart';
import '../models/reward_model.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

/// Akun bawaan saat aplikasi pertama kali dibuka.
/// WAJIB ganti PIN setelah login pertama (menu Profil → Ganti PIN).
class DefaultAccounts {
  static const String pin = '123456';
  static const String adminPhone = '081100000001';
  static const String tpsPhone = '081100000002';
  static const String driver1Phone = '081100000003';
  static const String driver2Phone = '081100000004';
  static const String demoWargaPhone = '081200000001';
}

class SeedData {
  SeedData._();

  static AppUser _user({
    required String name,
    required String phone,
    required UserRole role,
    String banjar = '',
    String address = '',
    String vehicle = '',
    int points = 0,
    required DateTime createdAt,
  }) {
    final id = IdGen.id();
    return AppUser(
      id: id,
      name: name,
      phone: phone,
      pinHash: Security.hashPin(id, DefaultAccounts.pin),
      role: role,
      banjar: banjar,
      address: address,
      vehicle: vehicle,
      points: points,
      createdAt: createdAt,
    );
  }

  static List<AppUser> baseUsers(DateTime now) => [
        _user(
          name: 'Admin Desa Baha',
          phone: DefaultAccounts.adminPhone,
          role: UserRole.admin,
          banjar: 'Kantor Desa',
          address: 'Kantor Desa Baha',
          createdAt: now,
        ),
        _user(
          name: 'I Ketut Budi Santosa',
          phone: DefaultAccounts.tpsPhone,
          role: UserRole.tps,
          banjar: 'TPS 3R Desa Baha',
          address: 'TPS 3R Desa Baha',
          createdAt: now,
        ),
        _user(
          name: 'Kadek Dwi Arta',
          phone: DefaultAccounts.driver1Phone,
          role: UserRole.driver,
          banjar: 'Baha Kelod',
          vehicle: 'DK 4821 FI',
          createdAt: now,
        ),
        _user(
          name: 'Komang Adi Putra',
          phone: DefaultAccounts.driver2Phone,
          role: UserRole.driver,
          banjar: 'Baha Tengah',
          vehicle: 'DK 5512 FG',
          createdAt: now,
        ),
      ];

  static List<Reward> baseRewards(DateTime now) => [
        Reward(id: IdGen.id(), name: 'Bibit cabai (5 pohon)', description: 'Bibit cabai rawit siap tanam dari kebun desa.', price: 200, stock: 12, category: 'bibit', createdAt: now),
        Reward(id: IdGen.id(), name: 'Bibit tomat (5 pohon)', description: 'Bibit tomat sehat, cocok untuk pekarangan.', price: 180, stock: 15, category: 'bibit', createdAt: now),
        Reward(id: IdGen.id(), name: 'Polybag 10 pcs', description: 'Polybag ukuran 30x30 cm untuk menanam.', price: 150, stock: 20, category: 'pertanian', createdAt: now),
        Reward(id: IdGen.id(), name: 'Pupuk kompos matang 5 kg', description: 'Kompos olahan TPS 3R Desa Baha.', price: 120, stock: 30, category: 'pertanian', createdAt: now),
        Reward(id: IdGen.id(), name: 'Beras lokal 5 kg', description: 'Beras dari petani Desa Baha.', price: 600, stock: 5, category: 'sembako', createdAt: now),
        Reward(id: IdGen.id(), name: 'Kopi Baha 250 g', description: 'Kopi bubuk produksi UMKM desa.', price: 350, stock: 8, category: 'sembako', createdAt: now),
        Reward(id: IdGen.id(), name: 'Sekop kebun', description: 'Sekop kecil untuk berkebun di rumah.', price: 450, stock: 4, category: 'alat', createdAt: now),
      ];

  static List<Announcement> baseAnnouncements(DateTime now) => [
        Announcement(
          id: IdGen.id(),
          title: 'Selamat datang di Kompos Baha',
          body: 'Ubah sampah dapur menjadi kompos, setor lewat aplikasi, dan kumpulkan poin '
              'untuk ditukar hadiah di Kantor Desa Baha. Terima kasih sudah menjaga desa tetap bersih!',
          isPinned: true,
          createdAt: now,
        ),
        Announcement(
          id: IdGen.id(),
          title: 'Jadwal penjemputan',
          body: 'Penjemputan kompos dilayani Senin – Sabtu pada jam yang Anda pilih. '
              'Siapkan kompos dalam karung/ember tertutup di depan rumah.',
          createdAt: now,
        ),
      ];

  static AppSettings baseSettings(DateTime now) {
    const s = AppSettings();
    return s.copyWith(rateHistory: [
      RateVersion(
        pointsPerKg: s.pointsPerKg,
        bonusMinKg: s.bonusMinKg,
        bonusPoints: s.bonusPoints,
        cukupPercent: s.cukupPercent,
        effectiveAt: now,
        changedBy: 'Sistem',
      ),
    ]);
  }
}

/// Paket data contoh agar admin bisa mencoba seluruh fitur.
class DemoBundle {
  final List<AppUser> users;
  final List<PickupOrder> orders;
  final List<LedgerEntry> ledger;
  final List<Complaint> complaints;
  final List<Redemption> redemptions;

  DemoBundle(this.users, this.orders, this.ledger, this.complaints, this.redemptions);

  static DemoBundle build({
    required DateTime now,
    required AppSettings settings,
    required List<AppUser> drivers,
    required List<Reward> rewards,
  }) {
    final today = Fmt.dateOnly(now);
    final banjars = settings.banjarList;
    String b(int i) => banjars.isEmpty ? 'Baha Kelod' : banjars[i % banjars.length];

    final wargaSeed = [
      ('I Wayan Sudarta', DefaultAccounts.demoWargaPhone, 'Jl. Baha No. 18'),
      ('Ni Luh Ayu Wulandari', '081200000002', 'Jl. Baha No. 7'),
      ('Ni Kadek Sari', '081200000003', 'Jl. Baha Kaja No. 22'),
      ('I Made Sukarta', '081200000004', 'Gg. Melati No. 3'),
      ('Putu Eka Pramana', '081200000005', 'Jl. Baha No. 12'),
    ];

    final users = <AppUser>[];
    for (int i = 0; i < wargaSeed.length; i++) {
      final w = wargaSeed[i];
      final uid = IdGen.id();
      users.add(AppUser(
        id: uid,
        name: w.$1,
        phone: w.$2,
        pinHash: Security.hashPin(uid, DefaultAccounts.pin),
        role: UserRole.warga,
        banjar: b(i),
        address: '${w.$3}, Banjar ${b(i)}',
        createdAt: today.subtract(Duration(days: 60 - i)),
      ));
    }

    final orders = <PickupOrder>[];
    final ledger = <LedgerEntry>[];
    final balances = <String, int>{for (final u in users) u.id: 0};
    int codeNo = 401;

    String slot(int i) => settings.timeSlots.isEmpty ? '08.00 - 10.00' : settings.timeSlots[i % settings.timeSlots.length];
    AppUser? driver(int i) => drivers.isEmpty ? null : drivers[i % drivers.length];

    // Riwayat 6 minggu terakhir (selesai)
    final weights = [8.2, 11.5, 14.0, 9.6, 16.4, 7.8, 12.2, 10.5, 18.0, 6.5, 13.4, 15.2, 9.0, 11.0];
    for (int i = 0; i < weights.length; i++) {
      final w = users[i % users.length];
      final d = driver(i);
      final date = today.subtract(Duration(days: 40 - i * 3));
      final kg = weights[i];
      final quality = i % 4 == 3 ? CompostQuality.cukup : CompostQuality.baik;
      var base = kg * settings.pointsPerKg;
      if (quality == CompostQuality.cukup) base = base * settings.cukupPercent / 100;
      final pts = base.round();
      final bonus = (quality == CompostQuality.baik && kg >= settings.bonusMinKg) ? settings.bonusPoints : 0;
      final code = 'KB-${(codeNo++).toString().padLeft(4, '0')}';
      final created = date.subtract(const Duration(days: 1)).add(const Duration(hours: 9));
      orders.add(PickupOrder(
        id: IdGen.id(),
        code: code,
        wargaId: w.id,
        wargaName: w.name,
        wargaPhone: w.phone,
        banjar: w.banjar,
        address: w.address,
        estimatedKg: kg.roundToDouble(),
        pickupDate: date,
        timeSlot: slot(i),
        notes: 'Kompos di karung depan rumah.',
        driverId: d?.id,
        driverName: d?.name,
        status: OrderStatus.selesai,
        collected: true,
        officialKg: kg,
        quality: quality,
        checklist: const ['Sudah matang', 'Tidak becek', 'Bebas plastik'],
        pointsEarned: pts,
        bonusPoints: bonus,
        logs: [
          StatusLog(status: OrderStatus.menunggu, at: created, actor: w.name),
          StatusLog(status: OrderStatus.ditugaskan, at: created.add(const Duration(hours: 2)), actor: 'Petugas TPS 3R'),
          StatusLog(status: OrderStatus.dijemput, at: date.add(const Duration(hours: 8)), actor: d?.name ?? ''),
          StatusLog(status: OrderStatus.diantar, at: date.add(const Duration(hours: 10)), actor: d?.name ?? ''),
          StatusLog(status: OrderStatus.selesai, at: date.add(const Duration(hours: 13)), actor: 'Petugas TPS 3R'),
        ],
        createdAt: created,
        updatedAt: date.add(const Duration(hours: 13)),
      ));
      final total = pts + bonus;
      balances[w.id] = (balances[w.id] ?? 0) + total;
      ledger.add(LedgerEntry(
        id: IdGen.id(),
        wargaId: w.id,
        description: 'Setoran $code (${Fmt.kg(kg)} kg)',
        delta: total,
        balanceAfter: balances[w.id]!,
        type: 'setor',
        createdAt: date.add(const Duration(hours: 13)),
      ));
    }

    // Penukaran yang sudah diambil
    final redemptions = <Redemption>[];
    if (rewards.isNotEmpty) {
      final w = users[0];
      final r = rewards.first;
      final at = today.subtract(const Duration(days: 10));
      balances[w.id] = (balances[w.id] ?? 0) - r.price;
      ledger.add(LedgerEntry(
        id: IdGen.id(),
        wargaId: w.id,
        description: 'Tukar ${r.name}',
        delta: -r.price,
        balanceAfter: balances[w.id]!,
        type: 'tukar',
        createdAt: at,
      ));
      redemptions.add(Redemption(
        id: IdGen.id(),
        code: 'TKR-${IdGen.code(4)}',
        wargaId: w.id,
        wargaName: w.name,
        rewardId: r.id,
        rewardName: r.name,
        price: r.price,
        status: RedemptionStatus.diambil,
        createdAt: at,
        expiresAt: at.add(Duration(days: settings.redemptionValidDays)),
        completedAt: at.add(const Duration(days: 1)),
        handledBy: 'Admin Desa Baha',
      ));
    }

    // Setoran aktif hari ini / besok (berbagai status)
    final activeStatuses = [
      OrderStatus.menunggu,
      OrderStatus.menunggu,
      OrderStatus.ditugaskan,
      OrderStatus.dijemput,
      OrderStatus.diantar,
    ];
    for (int i = 0; i < activeStatuses.length; i++) {
      final st = activeStatuses[i];
      final w = users[(i + 1) % users.length];
      final d = st == OrderStatus.menunggu ? null : driver(i);
      final date = i < 3 ? today : today.add(const Duration(days: 1));
      final created = now.subtract(Duration(hours: 5 - i));
      final logs = <StatusLog>[StatusLog(status: OrderStatus.menunggu, at: created, actor: w.name)];
      if (st.stepIndex >= 1) logs.add(StatusLog(status: OrderStatus.ditugaskan, at: created.add(const Duration(minutes: 30)), actor: 'Petugas TPS 3R'));
      if (st.stepIndex >= 2) logs.add(StatusLog(status: OrderStatus.dijemput, at: created.add(const Duration(hours: 1)), actor: d?.name ?? ''));
      if (st.stepIndex >= 3) logs.add(StatusLog(status: OrderStatus.diantar, at: created.add(const Duration(hours: 2)), actor: d?.name ?? ''));
      orders.add(PickupOrder(
        id: IdGen.id(),
        code: 'KB-${(codeNo++).toString().padLeft(4, '0')}',
        wargaId: w.id,
        wargaName: w.name,
        wargaPhone: w.phone,
        banjar: w.banjar,
        address: w.address,
        estimatedKg: [12.0, 15.0, 8.0, 10.0, 9.0][i],
        pickupDate: date,
        timeSlot: slot(i),
        notes: 'Kompos disimpan di karung putih dekat pintu samping.',
        driverId: d?.id,
        driverName: d?.name,
        status: st,
        collected: st.stepIndex >= 3,
        logs: logs,
        createdAt: created,
        updatedAt: logs.last.at,
      ));
    }

    // Satu setoran ditolak & satu gagal
    final rejectedW = users[3];
    final rejectedDate = today.subtract(const Duration(days: 9));
    orders.add(PickupOrder(
      id: IdGen.id(),
      code: 'KB-${(codeNo++).toString().padLeft(4, '0')}',
      wargaId: rejectedW.id,
      wargaName: rejectedW.name,
      wargaPhone: rejectedW.phone,
      banjar: rejectedW.banjar,
      address: rejectedW.address,
      estimatedKg: 10,
      pickupDate: rejectedDate,
      timeSlot: slot(1),
      driverId: driver(1)?.id,
      driverName: driver(1)?.name,
      status: OrderStatus.ditolak,
      collected: true,
      rejectionReason: 'Tercampur sampah plastik',
      logs: [
        StatusLog(status: OrderStatus.menunggu, at: rejectedDate.subtract(const Duration(hours: 20)), actor: rejectedW.name),
        StatusLog(status: OrderStatus.ditolak, at: rejectedDate.add(const Duration(hours: 12)), actor: 'Petugas TPS 3R', note: 'Tercampur sampah plastik'),
      ],
      createdAt: rejectedDate.subtract(const Duration(hours: 20)),
      updatedAt: rejectedDate.add(const Duration(hours: 12)),
    ));
    final failedW = users[4];
    final failedDate = today.subtract(const Duration(days: 16));
    orders.add(PickupOrder(
      id: IdGen.id(),
      code: 'KB-${(codeNo++).toString().padLeft(4, '0')}',
      wargaId: failedW.id,
      wargaName: failedW.name,
      wargaPhone: failedW.phone,
      banjar: failedW.banjar,
      address: failedW.address,
      estimatedKg: 9,
      pickupDate: failedDate,
      timeSlot: slot(0),
      driverId: driver(0)?.id,
      driverName: driver(0)?.name,
      status: OrderStatus.gagal,
      failureReason: 'Warga tidak di tempat',
      logs: [
        StatusLog(status: OrderStatus.menunggu, at: failedDate.subtract(const Duration(hours: 20)), actor: failedW.name),
        StatusLog(status: OrderStatus.gagal, at: failedDate.add(const Duration(hours: 9)), actor: driver(0)?.name ?? '', note: 'Warga tidak di tempat'),
      ],
      createdAt: failedDate.subtract(const Duration(hours: 20)),
      updatedAt: failedDate.add(const Duration(hours: 9)),
    ));

    // Terapkan saldo akhir
    for (int i = 0; i < users.length; i++) {
      users[i] = users[i].copyWith(points: balances[users[i].id] ?? 0);
    }

    final complaints = [
      Complaint(
        id: IdGen.id(),
        code: 'PGD-001',
        wargaId: users[1].id,
        wargaName: users[1].name,
        topic: 'Driver terlambat / tidak datang',
        description: 'Penjemputan dijadwalkan pukul 08.00 - 10.00, tetapi driver belum tiba sampai pukul 11.30.',
        createdAt: now.subtract(const Duration(hours: 20)),
      ),
      Complaint(
        id: IdGen.id(),
        code: 'PGD-002',
        wargaId: users[2].id,
        wargaName: users[2].name,
        topic: 'Saran & masukan',
        description: 'Mohon ditambah jadwal penjemputan sore hari untuk warga yang bekerja.',
        status: ComplaintStatus.selesai,
        reply: 'Terima kasih masukannya. Mulai bulan ini tersedia jadwal 14.00 - 16.00.',
        createdAt: now.subtract(const Duration(days: 6)),
        repliedAt: now.subtract(const Duration(days: 5)),
      ),
    ];

    return DemoBundle(users, orders, ledger, complaints, redemptions);
  }
}
