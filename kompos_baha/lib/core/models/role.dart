enum UserRole {
  warga,
  driver,
  tps,
  admin,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.warga:
        return 'Warga';
      case UserRole.driver:
        return 'Driver';
      case UserRole.tps:
        return 'TPS 3R';
      case UserRole.admin:
        return 'Admin Desa';
    }
  }

  String get detail {
    switch (this) {
      case UserRole.warga:
        return 'Setor kompos dan tukar poin';
      case UserRole.driver:
        return 'Kelola tugas penjemputan';
      case UserRole.tps:
        return 'Timbang dan verifikasi kompos';
      case UserRole.admin:
        return 'Pantau layanan desa';
    }
  }
}

