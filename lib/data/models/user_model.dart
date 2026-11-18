import 'package:flutter/material.dart';

enum UserRole { warga, driver, tps, admin }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.warga => 'Warga',
        UserRole.driver => 'Driver',
        UserRole.tps => 'Petugas TPS 3R',
        UserRole.admin => 'Admin Desa',
      };

  String get description => switch (this) {
        UserRole.warga => 'Setor kompos & tukar poin',
        UserRole.driver => 'Jemput kompos dari rumah warga',
        UserRole.tps => 'Timbang & periksa kompos',
        UserRole.admin => 'Kelola layanan Kompos Baha',
      };

  IconData get icon => switch (this) {
        UserRole.warga => Icons.home_rounded,
        UserRole.driver => Icons.local_shipping_rounded,
        UserRole.tps => Icons.scale_rounded,
        UserRole.admin => Icons.admin_panel_settings_rounded,
      };

  static UserRole parse(String? v) =>
      UserRole.values.firstWhere((e) => e.name == v, orElse: () => UserRole.warga);
}

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String pinHash;
  final UserRole role;
  final String banjar;
  final String address;
  final int points;
  final bool isActive;
  final bool isAvailable; // khusus driver: siap bertugas
  final String vehicle; // khusus driver: nomor kendaraan
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.pinHash,
    required this.role,
    this.banjar = '',
    this.address = '',
    this.points = 0,
    this.isActive = true,
    this.isAvailable = true,
    this.vehicle = '',
    required this.createdAt,
  });

  AppUser copyWith({
    String? name,
    String? phone,
    String? pinHash,
    UserRole? role,
    String? banjar,
    String? address,
    int? points,
    bool? isActive,
    bool? isAvailable,
    String? vehicle,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      pinHash: pinHash ?? this.pinHash,
      role: role ?? this.role,
      banjar: banjar ?? this.banjar,
      address: address ?? this.address,
      points: points ?? this.points,
      isActive: isActive ?? this.isActive,
      isAvailable: isAvailable ?? this.isAvailable,
      vehicle: vehicle ?? this.vehicle,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'pinHash': pinHash,
        'role': role.name,
        'banjar': banjar,
        'address': address,
        'points': points,
        'isActive': isActive,
        'isAvailable': isAvailable,
        'vehicle': vehicle,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as String,
        name: j['name'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        pinHash: j['pinHash'] as String? ?? '',
        role: UserRoleX.parse(j['role'] as String?),
        banjar: j['banjar'] as String? ?? '',
        address: j['address'] as String? ?? '',
        points: (j['points'] as num?)?.toInt() ?? 0,
        isActive: j['isActive'] as bool? ?? true,
        isAvailable: j['isAvailable'] as bool? ?? true,
        vehicle: j['vehicle'] as String? ?? '',
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}
