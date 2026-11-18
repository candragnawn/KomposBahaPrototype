import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Hadiah yang bisa ditukar dengan poin.
class Reward {
  final String id;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String category; // bibit, pupuk, sembako, alat, lainnya
  final bool isActive;
  final DateTime createdAt;

  const Reward({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.stock,
    this.category = 'lainnya',
    this.isActive = true,
    required this.createdAt,
  });

  bool get isAvailable => isActive && stock > 0;

  static const List<String> categories = ['bibit', 'pertanian', 'sembako', 'alat', 'lainnya'];

  static String categoryLabel(String c) => switch (c) {
        'bibit' => 'Bibit tanaman',
        'pertanian' => 'Perlengkapan tani',
        'sembako' => 'Sembako',
        'alat' => 'Alat kebun',
        _ => 'Lainnya',
      };

  IconData get icon => switch (category) {
        'bibit' => Icons.spa_rounded,
        'pertanian' => Icons.grass_rounded,
        'sembako' => Icons.rice_bowl_rounded,
        'alat' => Icons.handyman_rounded,
        _ => Icons.card_giftcard_rounded,
      };

  Color get tone => switch (category) {
        'bibit' => AppColors.primary,
        'pertanian' => AppColors.primaryDark,
        'sembako' => AppColors.goldDark,
        'alat' => AppColors.soil,
        _ => AppColors.soilMedium,
      };

  Color get toneLight => switch (category) {
        'bibit' => AppColors.primarySurface,
        'pertanian' => AppColors.sageLight,
        'sembako' => AppColors.goldLight,
        'alat' => AppColors.soilLight,
        _ => AppColors.soilLight,
      };

  Reward copyWith({
    String? name,
    String? description,
    int? price,
    int? stock,
    String? category,
    bool? isActive,
  }) {
    return Reward(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Reward.fromJson(Map<String, dynamic> j) => Reward(
        id: j['id'] as String,
        name: j['name'] as String? ?? '',
        description: j['description'] as String? ?? '',
        price: (j['price'] as num?)?.toInt() ?? 0,
        stock: (j['stock'] as num?)?.toInt() ?? 0,
        category: j['category'] as String? ?? 'lainnya',
        isActive: j['isActive'] as bool? ?? true,
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

enum RedemptionStatus { menunggu, diambil, kedaluwarsa, dibatalkan }

extension RedemptionStatusX on RedemptionStatus {
  String get label => switch (this) {
        RedemptionStatus.menunggu => 'Siap diambil',
        RedemptionStatus.diambil => 'Sudah diambil',
        RedemptionStatus.kedaluwarsa => 'Kedaluwarsa',
        RedemptionStatus.dibatalkan => 'Dibatalkan',
      };

  Color get color => switch (this) {
        RedemptionStatus.menunggu => AppColors.goldText,
        RedemptionStatus.diambil => AppColors.success,
        RedemptionStatus.kedaluwarsa => AppColors.error,
        RedemptionStatus.dibatalkan => AppColors.muted,
      };

  Color get background => switch (this) {
        RedemptionStatus.menunggu => AppColors.goldLight,
        RedemptionStatus.diambil => AppColors.successLight,
        RedemptionStatus.kedaluwarsa => AppColors.errorLight,
        RedemptionStatus.dibatalkan => AppColors.sageLight,
      };

  static RedemptionStatus parse(String? v) => RedemptionStatus.values
      .firstWhere((e) => e.name == v, orElse: () => RedemptionStatus.menunggu);
}

/// Penukaran poin menjadi hadiah.
class Redemption {
  final String id;
  final String code;
  final String wargaId;
  final String wargaName;
  final String rewardId;
  final String rewardName;
  final int price;
  final RedemptionStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? completedAt;
  final String handledBy;

  const Redemption({
    required this.id,
    required this.code,
    required this.wargaId,
    required this.wargaName,
    required this.rewardId,
    required this.rewardName,
    required this.price,
    this.status = RedemptionStatus.menunggu,
    required this.createdAt,
    required this.expiresAt,
    this.completedAt,
    this.handledBy = '',
  });

  Redemption copyWith({RedemptionStatus? status, DateTime? completedAt, String? handledBy}) {
    return Redemption(
      id: id,
      code: code,
      wargaId: wargaId,
      wargaName: wargaName,
      rewardId: rewardId,
      rewardName: rewardName,
      price: price,
      status: status ?? this.status,
      createdAt: createdAt,
      expiresAt: expiresAt,
      completedAt: completedAt ?? this.completedAt,
      handledBy: handledBy ?? this.handledBy,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'wargaId': wargaId,
        'wargaName': wargaName,
        'rewardId': rewardId,
        'rewardName': rewardName,
        'price': price,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'handledBy': handledBy,
      };

  factory Redemption.fromJson(Map<String, dynamic> j) => Redemption(
        id: j['id'] as String,
        code: j['code'] as String? ?? '',
        wargaId: j['wargaId'] as String? ?? '',
        wargaName: j['wargaName'] as String? ?? '',
        rewardId: j['rewardId'] as String? ?? '',
        rewardName: j['rewardName'] as String? ?? '',
        price: (j['price'] as num?)?.toInt() ?? 0,
        status: RedemptionStatusX.parse(j['status'] as String?),
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
        expiresAt: DateTime.tryParse(j['expiresAt'] as String? ?? '') ?? DateTime.now(),
        completedAt: j['completedAt'] == null ? null : DateTime.tryParse(j['completedAt'] as String),
        handledBy: j['handledBy'] as String? ?? '',
      );
}
