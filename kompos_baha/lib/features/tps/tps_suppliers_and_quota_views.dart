import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_button.dart';

class TpsSuppliersView extends StatelessWidget {
  const TpsSuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('I Wayan Sudarta', 'Baha Kelod', '3', '38 kg', '12,7 kg', '380'),
      ('Ni Luh Ayu Wulandari', 'Baha Kaja', '4', '45 kg', '11,3 kg', '450'),
      ('I Ketut Merta', 'Baha Tengah', '3', '41 kg', '13,7 kg', '410'),
      ('Putu Eka Pramana', 'Baha Kelod', '2', '23 kg', '11,5 kg', '230'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Oktober 2026', style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 2),
        const Text('Rekap Pemasok', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Warga', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Banjar', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Jumlah Setoran', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Total (kg)', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Rata-rata', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Poin Diberikan', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: rows.map((r) {
              return DataRow(
                cells: [
                  DataCell(Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text(r.$2)),
                  DataCell(Text(r.$3)),
                  DataCell(Text(r.$4, style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(r.$5)),
                  DataCell(Text(r.$6, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen))),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class TpsQuotaView extends StatelessWidget {
  const TpsQuotaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pengaturan kuota', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kuota penerimaan harian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              const Text('Atur batas kompos yang dapat diterima TPS 3R per hari.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: '500',
                decoration: const InputDecoration(labelText: 'Kuota Senin–Jumat (kg)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: '300',
                decoration: const InputDecoration(labelText: 'Kuota Sabtu (kg)'),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Simpan pengaturan',
                variant: ButtonVariant.primary,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

