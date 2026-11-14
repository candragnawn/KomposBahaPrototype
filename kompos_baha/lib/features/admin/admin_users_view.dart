import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_badge.dart';
import '../../shared_widgets/app_button.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      ('I Wayan Sudarta', 'Warga', 'Baha Kelod', '0812 3456 7812', 'Poin diberikan', false),
      ('Ni Luh Ayu Wulandari', 'Warga', 'Baha Kaja', '0813 7788 1209', 'Menunggu konfirmasi', true),
      ('Kadek Dwi Arta', 'Driver', 'Baha Kelod', '0812 8842 1976', 'Poin diberikan', false),
      ('Komang Adi Putra', 'Driver', 'Baha Tengah', '0819 4612 8401', 'Poin diberikan', false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pengguna', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
            AppButton(
              label: 'Tambah pengguna',
              variant: ButtonVariant.primary,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Peran', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Banjar', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Telepon', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status Verifikasi', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Tindakan', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: users.map((u) {
                return DataRow(
                  cells: [
                    DataCell(Text(u.$1, style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Text(u.$2)),
                    DataCell(Text(u.$3)),
                    DataCell(Text(u.$4)),
                    DataCell(AppBadge(label: u.$5)),
                    DataCell(
                      AppButton(
                        label: u.$6 ? 'Verifikasi' : 'Detail',
                        variant: u.$6 ? ButtonVariant.primary : ButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

