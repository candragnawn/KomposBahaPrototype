import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_button.dart';

class AdminPointsView extends StatefulWidget {
  const AdminPointsView({super.key});

  @override
  State<AdminPointsView> createState() => _AdminPointsViewState();
}

class _AdminPointsViewState extends State<AdminPointsView> {
  int _tabIndex = 0; // 0: Tarif poin, 1: Katalog hadiah, 2: Penukaran

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Poin dan Hadiah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 16),
        // Tabs
        Row(
          children: [
            _buildTabButton('Tarif poin dan ongkos', 0),
            const SizedBox(width: 8),
            _buildTabButton('Katalog hadiah', 1),
            const SizedBox(width: 8),
            _buildTabButton('Persetujuan penukaran', 2),
          ],
        ),
        const SizedBox(height: 20),

        if (_tabIndex == 0) ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMint,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.mintBorder),
                  ),
                  child: const Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tarif aktif saat ini', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                          SizedBox(height: 4),
                          Text('10 poin / kg', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                          SizedBox(height: 2),
                          Text('Berlaku sejak 1 Oktober 2026', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Aturan bonus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Tambahan 20 poin untuk setoran kualitas Baik dengan berat minimal 15 kg.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                const SizedBox(height: 20),
                const Text('Riwayat versi tarif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Versi')),
                    DataColumn(label: Text('Tarif')),
                    DataColumn(label: Text('Aturan Bonus')),
                    DataColumn(label: Text('Tanggal Efektif')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('v2.1', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text('10 poin/kg')),
                      DataCell(Text('+20 poin ≥ 15 kg')),
                      DataCell(Text('1 Okt 2026')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('v2.0')),
                      DataCell(Text('8 poin/kg')),
                      DataCell(Text('Tidak ada')),
                      DataCell(Text('1 Jul 2026')),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ] else if (_tabIndex == 1) ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nama Hadiah')),
                DataColumn(label: Text('Stok')),
                DataColumn(label: Text('Harga Poin')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Tindakan')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Bibit cabai', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('12')),
                  const DataCell(Text('200 poin')),
                  const DataCell(Text('Aktif')),
                  DataCell(AppButton(label: 'Ubah', onPressed: () {})),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Polybag 10 pcs', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('8')),
                  const DataCell(Text('150 poin')),
                  const DataCell(Text('Aktif')),
                  DataCell(AppButton(label: 'Ubah', onPressed: () {})),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Beras 5 kg', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('5')),
                  const DataCell(Text('600 poin')),
                  const DataCell(Text('Aktif')),
                  DataCell(AppButton(label: 'Ubah', onPressed: () {})),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Kopi Baha 250 g', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('0')),
                  const DataCell(Text('350 poin')),
                  const DataCell(Text('Nonaktif')),
                  DataCell(AppButton(label: 'Ubah', onPressed: () {})),
                ]),
              ],
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Kode Klaim')),
                DataColumn(label: Text('Warga')),
                DataColumn(label: Text('Hadiah')),
                DataColumn(label: Text('Poin')),
                DataColumn(label: Text('Tanggal')),
                DataColumn(label: Text('Tindakan')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('KBH-8468', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('Ni Made Suriati')),
                  const DataCell(Text('Sekop kebun')),
                  const DataCell(Text('600')),
                  const DataCell(Text('18 Okt 2026')),
                  DataCell(
                    Row(
                      children: [
                        AppButton(label: 'Setujui', variant: ButtonVariant.primary, onPressed: () {}),
                        const SizedBox(width: 8),
                        AppButton(label: 'Tolak', variant: ButtonVariant.danger, onPressed: () {}),
                      ],
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('KBH-8461', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('I Ketut Merta')),
                  const DataCell(Text('Beras lokal 2 kg')),
                  const DataCell(Text('1.000')),
                  const DataCell(Text('17 Okt 2026')),
                  DataCell(
                    Row(
                      children: [
                        AppButton(label: 'Setujui', variant: ButtonVariant.primary, onPressed: () {}),
                        const SizedBox(width: 8),
                        AppButton(label: 'Tolak', variant: ButtonVariant.danger, onPressed: () {}),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTabButton(String label, int index) {
    final active = _tabIndex == index;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? AppColors.primaryGreen : Colors.white,
        foregroundColor: active ? Colors.white : AppColors.ink,
        side: BorderSide(color: active ? AppColors.primaryGreen : AppColors.border),
      ),
      onPressed: () => setState(() => _tabIndex = index),
      child: Text(label),
    );
  }
}

