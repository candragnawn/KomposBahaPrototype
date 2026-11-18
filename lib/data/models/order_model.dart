import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Status setoran kompos dari awal sampai selesai.
enum OrderStatus {
  menunggu, // warga sudah mengajukan, menunggu penugasan driver
  ditugaskan, // driver sudah ditugaskan
  dijemput, // driver dalam perjalanan / sedang mengambil
  diantar, // kompos sudah tiba di TPS 3R, menunggu ditimbang
  selesai, // diverifikasi TPS, poin diberikan
  ditolak, // ditolak TPS 3R
  gagal, // gagal dijemput
  dibatalkan, // dibatalkan warga / admin
}

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.menunggu => 'Menunggu konfirmasi',
        OrderStatus.ditugaskan => 'Driver ditugaskan',
        OrderStatus.dijemput => 'Sedang dijemput',
        OrderStatus.diantar => 'Tiba di TPS 3R',
        OrderStatus.selesai => 'Poin diberikan',
        OrderStatus.ditolak => 'Ditolak TPS 3R',
        OrderStatus.gagal => 'Gagal dijemput',
        OrderStatus.dibatalkan => 'Dibatalkan',
      };

  /// Penjelasan sederhana untuk warga.
  String get explanation => switch (this) {
        OrderStatus.menunggu => 'Setoran Anda sudah kami terima. Petugas akan segera menugaskan driver.',
        OrderStatus.ditugaskan => 'Driver sudah ditugaskan. Mohon siapkan kompos sesuai jadwal.',
        OrderStatus.dijemput => 'Driver sedang menuju / mengambil kompos di rumah Anda.',
        OrderStatus.diantar => 'Kompos sudah sampai di TPS 3R dan menunggu ditimbang.',
        OrderStatus.selesai => 'Kompos sudah ditimbang dan poin sudah masuk ke saldo Anda.',
        OrderStatus.ditolak => 'Kompos tidak memenuhi syarat. Lihat alasan di bawah.',
        OrderStatus.gagal => 'Driver tidak berhasil mengambil kompos. Lihat alasan di bawah.',
        OrderStatus.dibatalkan => 'Setoran ini sudah dibatalkan.',
      };

  Color get color => switch (this) {
        OrderStatus.menunggu => AppColors.warning,
        OrderStatus.ditugaskan => AppColors.info,
        OrderStatus.dijemput => AppColors.primary,
        OrderStatus.diantar => AppColors.soil,
        OrderStatus.selesai => AppColors.success,
        OrderStatus.ditolak => AppColors.error,
        OrderStatus.gagal => AppColors.error,
        OrderStatus.dibatalkan => AppColors.muted,
      };

  Color get background => switch (this) {
        OrderStatus.menunggu => AppColors.warningLight,
        OrderStatus.ditugaskan => AppColors.infoLight,
        OrderStatus.dijemput => AppColors.primarySurface,
        OrderStatus.diantar => AppColors.soilLight,
        OrderStatus.selesai => AppColors.successLight,
        OrderStatus.ditolak => AppColors.errorLight,
        OrderStatus.gagal => AppColors.errorLight,
        OrderStatus.dibatalkan => AppColors.sageLight,
      };

  IconData get icon => switch (this) {
        OrderStatus.menunggu => Icons.hourglass_top_rounded,
        OrderStatus.ditugaskan => Icons.assignment_ind_rounded,
        OrderStatus.dijemput => Icons.local_shipping_rounded,
        OrderStatus.diantar => Icons.warehouse_rounded,
        OrderStatus.selesai => Icons.verified_rounded,
        OrderStatus.ditolak => Icons.block_rounded,
        OrderStatus.gagal => Icons.report_rounded,
        OrderStatus.dibatalkan => Icons.cancel_rounded,
      };

  bool get isActive =>
      this == OrderStatus.menunggu ||
      this == OrderStatus.ditugaskan ||
      this == OrderStatus.dijemput ||
      this == OrderStatus.diantar;

  /// Menghitung beban kuota (setoran yang tidak batal/gagal/ditolak).
  bool get countsForQuota =>
      this != OrderStatus.dibatalkan && this != OrderStatus.gagal && this != OrderStatus.ditolak;

  /// Posisi pada timeline 5 langkah.
  int get stepIndex => switch (this) {
        OrderStatus.menunggu => 0,
        OrderStatus.ditugaskan => 1,
        OrderStatus.dijemput => 2,
        OrderStatus.diantar => 3,
        OrderStatus.selesai => 4,
        _ => -1,
      };

  static OrderStatus parse(String? v) =>
      OrderStatus.values.firstWhere((e) => e.name == v, orElse: () => OrderStatus.menunggu);
}

/// Kualitas kompos hasil pemeriksaan TPS 3R.
enum CompostQuality { baik, cukup }

extension CompostQualityX on CompostQuality {
  String get label => switch (this) {
        CompostQuality.baik => 'Baik',
        CompostQuality.cukup => 'Cukup',
      };

  static CompostQuality? parse(String? v) {
    if (v == null) return null;
    for (final q in CompostQuality.values) {
      if (q.name == v) return q;
    }
    return null;
  }
}

/// Catatan riwayat perubahan status.
class StatusLog {
  final OrderStatus status;
  final DateTime at;
  final String actor;
  final String note;

  const StatusLog({
    required this.status,
    required this.at,
    this.actor = '',
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'at': at.toIso8601String(),
        'actor': actor,
        'note': note,
      };

  factory StatusLog.fromJson(Map<String, dynamic> j) => StatusLog(
        status: OrderStatusX.parse(j['status'] as String?),
        at: DateTime.tryParse(j['at'] as String? ?? '') ?? DateTime.now(),
        actor: j['actor'] as String? ?? '',
        note: j['note'] as String? ?? '',
      );
}

/// Setoran / penjemputan kompos.
class PickupOrder {
  final String id;
  final String code;
  final String wargaId;
  final String wargaName;
  final String wargaPhone;
  final String banjar;
  final String address;
  final double estimatedKg;
  final DateTime pickupDate;
  final String timeSlot;
  final String notes;
  final String? photoWarga;
  final String? driverId;
  final String? driverName;
  final OrderStatus status;
  final bool collected;
  final String? photoPickup;
  final double? officialKg;
  final CompostQuality? quality;
  final List<String> checklist;
  final String? photoTps;
  final int pointsEarned;
  final int bonusPoints;
  final String? rejectionReason;
  final String? failureReason;
  final String? cancelReason;
  final List<StatusLog> logs;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PickupOrder({
    required this.id,
    required this.code,
    required this.wargaId,
    required this.wargaName,
    required this.wargaPhone,
    required this.banjar,
    required this.address,
    required this.estimatedKg,
    required this.pickupDate,
    required this.timeSlot,
    this.notes = '',
    this.photoWarga,
    this.driverId,
    this.driverName,
    this.status = OrderStatus.menunggu,
    this.collected = false,
    this.photoPickup,
    this.officialKg,
    this.quality,
    this.checklist = const [],
    this.photoTps,
    this.pointsEarned = 0,
    this.bonusPoints = 0,
    this.rejectionReason,
    this.failureReason,
    this.cancelReason,
    this.logs = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Tanggal ketika status tertentu tercatat (untuk timeline).
  DateTime? timeOf(OrderStatus s) {
    for (final l in logs.reversed) {
      if (l.status == s) return l.at;
    }
    return null;
  }

  int get totalPoints => pointsEarned + bonusPoints;

  PickupOrder copyWith({
    String? notes,
    String? address,
    String? driverId,
    String? driverName,
    OrderStatus? status,
    bool? collected,
    String? photoPickup,
    double? officialKg,
    CompostQuality? quality,
    List<String>? checklist,
    String? photoTps,
    int? pointsEarned,
    int? bonusPoints,
    String? rejectionReason,
    String? failureReason,
    String? cancelReason,
    List<StatusLog>? logs,
    DateTime? pickupDate,
    String? timeSlot,
    DateTime? updatedAt,
  }) {
    return PickupOrder(
      id: id,
      code: code,
      wargaId: wargaId,
      wargaName: wargaName,
      wargaPhone: wargaPhone,
      banjar: banjar,
      address: address ?? this.address,
      estimatedKg: estimatedKg,
      pickupDate: pickupDate ?? this.pickupDate,
      timeSlot: timeSlot ?? this.timeSlot,
      notes: notes ?? this.notes,
      photoWarga: photoWarga,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      status: status ?? this.status,
      collected: collected ?? this.collected,
      photoPickup: photoPickup ?? this.photoPickup,
      officialKg: officialKg ?? this.officialKg,
      quality: quality ?? this.quality,
      checklist: checklist ?? this.checklist,
      photoTps: photoTps ?? this.photoTps,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      failureReason: failureReason ?? this.failureReason,
      cancelReason: cancelReason ?? this.cancelReason,
      logs: logs ?? this.logs,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'wargaId': wargaId,
        'wargaName': wargaName,
        'wargaPhone': wargaPhone,
        'banjar': banjar,
        'address': address,
        'estimatedKg': estimatedKg,
        'pickupDate': pickupDate.toIso8601String(),
        'timeSlot': timeSlot,
        'notes': notes,
        'photoWarga': photoWarga,
        'driverId': driverId,
        'driverName': driverName,
        'status': status.name,
        'collected': collected,
        'photoPickup': photoPickup,
        'officialKg': officialKg,
        'quality': quality?.name,
        'checklist': checklist,
        'photoTps': photoTps,
        'pointsEarned': pointsEarned,
        'bonusPoints': bonusPoints,
        'rejectionReason': rejectionReason,
        'failureReason': failureReason,
        'cancelReason': cancelReason,
        'logs': logs.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory PickupOrder.fromJson(Map<String, dynamic> j) => PickupOrder(
        id: j['id'] as String,
        code: j['code'] as String? ?? '',
        wargaId: j['wargaId'] as String? ?? '',
        wargaName: j['wargaName'] as String? ?? '',
        wargaPhone: j['wargaPhone'] as String? ?? '',
        banjar: j['banjar'] as String? ?? '',
        address: j['address'] as String? ?? '',
        estimatedKg: (j['estimatedKg'] as num?)?.toDouble() ?? 0,
        pickupDate: DateTime.tryParse(j['pickupDate'] as String? ?? '') ?? DateTime.now(),
        timeSlot: j['timeSlot'] as String? ?? '',
        notes: j['notes'] as String? ?? '',
        photoWarga: j['photoWarga'] as String?,
        driverId: j['driverId'] as String?,
        driverName: j['driverName'] as String?,
        status: OrderStatusX.parse(j['status'] as String?),
        collected: j['collected'] as bool? ?? false,
        photoPickup: j['photoPickup'] as String?,
        officialKg: (j['officialKg'] as num?)?.toDouble(),
        quality: CompostQualityX.parse(j['quality'] as String?),
        checklist: (j['checklist'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        photoTps: j['photoTps'] as String?,
        pointsEarned: (j['pointsEarned'] as num?)?.toInt() ?? 0,
        bonusPoints: (j['bonusPoints'] as num?)?.toInt() ?? 0,
        rejectionReason: j['rejectionReason'] as String?,
        failureReason: j['failureReason'] as String?,
        cancelReason: j['cancelReason'] as String?,
        logs: (j['logs'] as List?)
                ?.map((e) => StatusLog.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            const [],
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(j['updatedAt'] as String? ?? '') ?? DateTime.now(),
      );
}
