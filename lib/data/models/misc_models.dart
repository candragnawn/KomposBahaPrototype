import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

// ─── Mutasi poin ────────────────────────────────────────────────────────────

class LedgerEntry {
  final String id;
  final String wargaId;
  final String description;
  final int delta;
  final int balanceAfter;
  final String type; // setor, tukar, refund, koreksi
  final DateTime createdAt;

  const LedgerEntry({
    required this.id,
    required this.wargaId,
    required this.description,
    required this.delta,
    required this.balanceAfter,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'wargaId': wargaId,
        'description': description,
        'delta': delta,
        'balanceAfter': balanceAfter,
        'type': type,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LedgerEntry.fromJson(Map<String, dynamic> j) => LedgerEntry(
        id: j['id'] as String,
        wargaId: j['wargaId'] as String? ?? '',
        description: j['description'] as String? ?? '',
        delta: (j['delta'] as num?)?.toInt() ?? 0,
        balanceAfter: (j['balanceAfter'] as num?)?.toInt() ?? 0,
        type: j['type'] as String? ?? 'koreksi',
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

// ─── Pengaduan ──────────────────────────────────────────────────────────────

enum ComplaintStatus { baru, diproses, selesai }

extension ComplaintStatusX on ComplaintStatus {
  String get label => switch (this) {
        ComplaintStatus.baru => 'Baru',
        ComplaintStatus.diproses => 'Sedang diproses',
        ComplaintStatus.selesai => 'Selesai',
      };

  Color get color => switch (this) {
        ComplaintStatus.baru => AppColors.warning,
        ComplaintStatus.diproses => AppColors.info,
        ComplaintStatus.selesai => AppColors.success,
      };

  Color get background => switch (this) {
        ComplaintStatus.baru => AppColors.warningLight,
        ComplaintStatus.diproses => AppColors.infoLight,
        ComplaintStatus.selesai => AppColors.successLight,
      };

  static ComplaintStatus parse(String? v) =>
      ComplaintStatus.values.firstWhere((e) => e.name == v, orElse: () => ComplaintStatus.baru);
}

class Complaint {
  final String id;
  final String code;
  final String wargaId;
  final String wargaName;
  final String topic;
  final String description;
  final String orderCode;
  final ComplaintStatus status;
  final String reply;
  final DateTime createdAt;
  final DateTime? repliedAt;

  const Complaint({
    required this.id,
    required this.code,
    required this.wargaId,
    required this.wargaName,
    required this.topic,
    required this.description,
    this.orderCode = '',
    this.status = ComplaintStatus.baru,
    this.reply = '',
    required this.createdAt,
    this.repliedAt,
  });

  static const List<String> topics = [
    'Driver terlambat / tidak datang',
    'Poin belum masuk',
    'Berat timbangan tidak sesuai',
    'Masalah penukaran hadiah',
    'Pelayanan petugas',
    'Saran & masukan',
    'Lainnya',
  ];

  Complaint copyWith({ComplaintStatus? status, String? reply, DateTime? repliedAt}) {
    return Complaint(
      id: id,
      code: code,
      wargaId: wargaId,
      wargaName: wargaName,
      topic: topic,
      description: description,
      orderCode: orderCode,
      status: status ?? this.status,
      reply: reply ?? this.reply,
      createdAt: createdAt,
      repliedAt: repliedAt ?? this.repliedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'wargaId': wargaId,
        'wargaName': wargaName,
        'topic': topic,
        'description': description,
        'orderCode': orderCode,
        'status': status.name,
        'reply': reply,
        'createdAt': createdAt.toIso8601String(),
        'repliedAt': repliedAt?.toIso8601String(),
      };

  factory Complaint.fromJson(Map<String, dynamic> j) => Complaint(
        id: j['id'] as String,
        code: j['code'] as String? ?? '',
        wargaId: j['wargaId'] as String? ?? '',
        wargaName: j['wargaName'] as String? ?? '',
        topic: j['topic'] as String? ?? '',
        description: j['description'] as String? ?? '',
        orderCode: j['orderCode'] as String? ?? '',
        status: ComplaintStatusX.parse(j['status'] as String?),
        reply: j['reply'] as String? ?? '',
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
        repliedAt: j['repliedAt'] == null ? null : DateTime.tryParse(j['repliedAt'] as String),
      );
}

// ─── Notifikasi ─────────────────────────────────────────────────────────────

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type; // order, points, reward, complaint, info
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.type = 'info',
    this.isRead = false,
    required this.createdAt,
  });

  IconData get icon => switch (type) {
        'order' => Icons.local_shipping_rounded,
        'points' => Icons.stars_rounded,
        'reward' => Icons.card_giftcard_rounded,
        'complaint' => Icons.support_agent_rounded,
        _ => Icons.campaign_rounded,
      };

  Color get color => switch (type) {
        'order' => AppColors.primary,
        'points' => AppColors.goldDark,
        'reward' => AppColors.soil,
        'complaint' => AppColors.info,
        _ => AppColors.primaryDark,
      };

  AppNotification markRead() => AppNotification(
        id: id,
        userId: userId,
        title: title,
        body: body,
        type: type,
        isRead: true,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'type': type,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'] as String,
        userId: j['userId'] as String? ?? '',
        title: j['title'] as String? ?? '',
        body: j['body'] as String? ?? '',
        type: j['type'] as String? ?? 'info',
        isRead: j['isRead'] as bool? ?? false,
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

// ─── Pengumuman desa ────────────────────────────────────────────────────────

class Announcement {
  final String id;
  final String title;
  final String body;
  final bool isActive;
  final bool isPinned;
  final DateTime createdAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    this.isActive = true,
    this.isPinned = false,
    required this.createdAt,
  });

  Announcement copyWith({String? title, String? body, bool? isActive, bool? isPinned}) {
    return Announcement(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      isActive: isActive ?? this.isActive,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'isActive': isActive,
        'isPinned': isPinned,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
        id: j['id'] as String,
        title: j['title'] as String? ?? '',
        body: j['body'] as String? ?? '',
        isActive: j['isActive'] as bool? ?? true,
        isPinned: j['isPinned'] as bool? ?? false,
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}
