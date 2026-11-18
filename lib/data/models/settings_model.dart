/// Riwayat versi tarif poin.
class RateVersion {
  final int pointsPerKg;
  final double bonusMinKg;
  final int bonusPoints;
  final int cukupPercent;
  final DateTime effectiveAt;
  final String changedBy;

  const RateVersion({
    required this.pointsPerKg,
    required this.bonusMinKg,
    required this.bonusPoints,
    required this.cukupPercent,
    required this.effectiveAt,
    this.changedBy = '',
  });

  Map<String, dynamic> toJson() => {
        'pointsPerKg': pointsPerKg,
        'bonusMinKg': bonusMinKg,
        'bonusPoints': bonusPoints,
        'cukupPercent': cukupPercent,
        'effectiveAt': effectiveAt.toIso8601String(),
        'changedBy': changedBy,
      };

  factory RateVersion.fromJson(Map<String, dynamic> j) => RateVersion(
        pointsPerKg: (j['pointsPerKg'] as num?)?.toInt() ?? 10,
        bonusMinKg: (j['bonusMinKg'] as num?)?.toDouble() ?? 15,
        bonusPoints: (j['bonusPoints'] as num?)?.toInt() ?? 20,
        cukupPercent: (j['cukupPercent'] as num?)?.toInt() ?? 75,
        effectiveAt: DateTime.tryParse(j['effectiveAt'] as String? ?? '') ?? DateTime.now(),
        changedBy: j['changedBy'] as String? ?? '',
      );
}

/// Pengaturan layanan (bisa diubah Admin Desa).
class AppSettings {
  /// Poin per kg untuk kualitas Baik.
  final int pointsPerKg;

  /// Berat minimum untuk mendapat bonus (kualitas Baik).
  final double bonusMinKg;

  /// Jumlah poin bonus.
  final int bonusPoints;

  /// Persentase poin untuk kualitas Cukup (mis. 75%).
  final int cukupPercent;

  /// Kuota penerimaan TPS 3R per hari (kg).
  final double dailyQuotaKg;

  /// Batas setoran aktif per warga.
  final int maxActiveOrders;

  /// Masa berlaku kode penukaran (hari).
  final int redemptionValidDays;

  final List<String> timeSlots;
  final List<String> banjarList;

  /// Hari layanan (1=Senin ... 7=Minggu).
  final List<int> serviceDays;

  final String adminPhone;
  final String officeAddress;
  final String officeHours;
  final List<RateVersion> rateHistory;

  const AppSettings({
    this.pointsPerKg = 10,
    this.bonusMinKg = 15,
    this.bonusPoints = 20,
    this.cukupPercent = 75,
    this.dailyQuotaKg = 150,
    this.maxActiveOrders = 2,
    this.redemptionValidDays = 7,
    this.timeSlots = const ['08.00 - 10.00', '10.00 - 12.00', '14.00 - 16.00'],
    this.banjarList = const ['Baha Kaja', 'Baha Tengah', 'Baha Kelod', 'Munggu Baha'],
    this.serviceDays = const [1, 2, 3, 4, 5, 6],
    this.adminPhone = '081100000001',
    this.officeAddress = 'Kantor Desa Baha, Kec. Mengwi, Kab. Badung, Bali',
    this.officeHours = 'Senin – Jumat, 08.00 – 14.00 WITA',
    this.rateHistory = const [],
  });

  AppSettings copyWith({
    int? pointsPerKg,
    double? bonusMinKg,
    int? bonusPoints,
    int? cukupPercent,
    double? dailyQuotaKg,
    int? maxActiveOrders,
    int? redemptionValidDays,
    List<String>? timeSlots,
    List<String>? banjarList,
    List<int>? serviceDays,
    String? adminPhone,
    String? officeAddress,
    String? officeHours,
    List<RateVersion>? rateHistory,
  }) {
    return AppSettings(
      pointsPerKg: pointsPerKg ?? this.pointsPerKg,
      bonusMinKg: bonusMinKg ?? this.bonusMinKg,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      cukupPercent: cukupPercent ?? this.cukupPercent,
      dailyQuotaKg: dailyQuotaKg ?? this.dailyQuotaKg,
      maxActiveOrders: maxActiveOrders ?? this.maxActiveOrders,
      redemptionValidDays: redemptionValidDays ?? this.redemptionValidDays,
      timeSlots: timeSlots ?? this.timeSlots,
      banjarList: banjarList ?? this.banjarList,
      serviceDays: serviceDays ?? this.serviceDays,
      adminPhone: adminPhone ?? this.adminPhone,
      officeAddress: officeAddress ?? this.officeAddress,
      officeHours: officeHours ?? this.officeHours,
      rateHistory: rateHistory ?? this.rateHistory,
    );
  }

  Map<String, dynamic> toJson() => {
        'pointsPerKg': pointsPerKg,
        'bonusMinKg': bonusMinKg,
        'bonusPoints': bonusPoints,
        'cukupPercent': cukupPercent,
        'dailyQuotaKg': dailyQuotaKg,
        'maxActiveOrders': maxActiveOrders,
        'redemptionValidDays': redemptionValidDays,
        'timeSlots': timeSlots,
        'banjarList': banjarList,
        'serviceDays': serviceDays,
        'adminPhone': adminPhone,
        'officeAddress': officeAddress,
        'officeHours': officeHours,
        'rateHistory': rateHistory.map((e) => e.toJson()).toList(),
      };

  factory AppSettings.fromJson(Map<String, dynamic> j) {
    const d = AppSettings();
    return AppSettings(
      pointsPerKg: (j['pointsPerKg'] as num?)?.toInt() ?? d.pointsPerKg,
      bonusMinKg: (j['bonusMinKg'] as num?)?.toDouble() ?? d.bonusMinKg,
      bonusPoints: (j['bonusPoints'] as num?)?.toInt() ?? d.bonusPoints,
      cukupPercent: (j['cukupPercent'] as num?)?.toInt() ?? d.cukupPercent,
      dailyQuotaKg: (j['dailyQuotaKg'] as num?)?.toDouble() ?? d.dailyQuotaKg,
      maxActiveOrders: (j['maxActiveOrders'] as num?)?.toInt() ?? d.maxActiveOrders,
      redemptionValidDays: (j['redemptionValidDays'] as num?)?.toInt() ?? d.redemptionValidDays,
      timeSlots: (j['timeSlots'] as List?)?.map((e) => e.toString()).toList() ?? d.timeSlots,
      banjarList: (j['banjarList'] as List?)?.map((e) => e.toString()).toList() ?? d.banjarList,
      serviceDays: (j['serviceDays'] as List?)?.map((e) => (e as num).toInt()).toList() ?? d.serviceDays,
      adminPhone: j['adminPhone'] as String? ?? d.adminPhone,
      officeAddress: j['officeAddress'] as String? ?? d.officeAddress,
      officeHours: j['officeHours'] as String? ?? d.officeHours,
      rateHistory: (j['rateHistory'] as List?)
              ?.map((e) => RateVersion.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );
  }
}
