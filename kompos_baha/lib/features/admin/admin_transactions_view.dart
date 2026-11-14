import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_badge.dart';

class AdminTransactionsView extends StatefulWidget {
  const AdminTransactionsView({super.key});

  @override
  State<AdminTransactionsView> createState() => _AdminTransactionsViewState();
}

class _AdminTransactionsViewState extends State<AdminTransactionsView> {
  String _status = 'Semua status';
  String _search = '';
  String _banjar = 'Semua banjar';

  final List<(String, String, String, String, String, String)> _allTransactions = const [
    ('KB-0415', 'Ni Kadek Sari', 'Baha Kaja', '15 kg', 'Menunggu konfirmasi', '18 Okt, 10.00'),
    ('KB-0412', 'Ni Luh Ayu Wulandari', 'Baha Kelod', '12 kg', 'Driver ditugaskan', '18 Okt, 08.00'),
    ('KB-0322', 'I Ketut Merta', 'Baha Tengah', '14 - 16 kg', 'Dalam penjemputan', 'Hari ini, 09.00'),
    ('KB-0321', 'Putu Eka Pramana', 'Baha Kelod', '9 - 11 kg', 'Diterima TPS 3R', 'Kemarin, 15.20'),
    ('KB-0320', 'Ni Made Suriati', 'Baha Kaja', '12 - 14 kg', 'Menunggu konfirmasi', 'Besok, 09.00'),
    ('KB-0319', 'I Made Ariasa', 'Baha Tengah', '7 - 9 kg', 'Driver ditugaskan', 'Besok, 13.00'),
    ('KB-0317', 'Ni Kadek Purnami', 'Baha Kelod', '10 - 12 kg', 'Gagal jemput', '23 Mar, 10.30'),
    ('KB-0316', 'I Nyoman Budi', 'Baha Kaja', '6 - 8 kg', 'Ditolak TPS', '22 Mar, 16.10'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _allTransactions.where((t) {
      final matchesStatus = _status == 'Semua status' || t.$5 == _status;
      final matchesBanjar = _banjar == 'Semua banjar' || t.$3 == _banjar;
      final matchesSearch = _search.isEmpty ||
          t.$2.toLowerCase().contains(_search.toLowerCase()) ||
          t.$1.toLowerCase().contains(_search.toLowerCase());
      return matchesStatus && matchesBanjar && matchesSearch;
    }).toList();

    final isMobile = MediaQuery.of(context).size.width < 700;

    final statusDropdown = DropdownButtonFormField<String>(
      initialValue: _status,
      decoration: const InputDecoration(labelText: 'Status'),
      items: const [
        DropdownMenuItem(value: 'Semua status', child: Text('Semua status')),
        DropdownMenuItem(value: 'Menunggu konfirmasi', child: Text('Menunggu konfirmasi')),
        DropdownMenuItem(value: 'Driver ditugaskan', child: Text('Driver ditugaskan')),
        DropdownMenuItem(value: 'Dalam penjemputan', child: Text('Dalam penjemputan')),
        DropdownMenuItem(value: 'Diterima TPS 3R', child: Text('Diterima TPS 3R')),
        DropdownMenuItem(value: 'Gagal jemput', child: Text('Gagal jemput')),
        DropdownMenuItem(value: 'Ditolak TPS', child: Text('Ditolak TPS')),
      ],
      onChanged: (v) {
        if (v != null) setState(() => _status = v);
      },
    );

    final banjarDropdown = DropdownButtonFormField<String>(
      initialValue: _banjar,
      decoration: const InputDecoration(labelText: 'Banjar'),
      items: const [
        DropdownMenuItem(value: 'Semua banjar', child: Text('Semua banjar')),
        DropdownMenuItem(value: 'Baha Kelod', child: Text('Baha Kelod')),
        DropdownMenuItem(value: 'Baha Kaja', child: Text('Baha Kaja')),
        DropdownMenuItem(value: 'Baha Tengah', child: Text('Baha Tengah')),
      ],
      onChanged: (v) {
        if (v != null) setState(() => _banjar = v);
      },
    );

    final searchField = TextField(
      decoration: const InputDecoration(
        labelText: 'Cari warga atau kode',
        hintText: 'Ketik nama / kode...',
      ),
      onChanged: (v) => setState(() => _search = v),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Transaksi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 16),
        // Filter Controls
        if (isMobile) ...[
          statusDropdown,
          const SizedBox(height: 10),
          banjarDropdown,
          const SizedBox(height: 10),
          searchField,
        ] else ...[
          Row(
            children: [
              Expanded(child: statusDropdown),
              const SizedBox(width: 12),
              Expanded(child: banjarDropdown),
              const SizedBox(width: 12),
              Expanded(child: searchField),
            ],
          ),
        ],
        const SizedBox(height: 20),
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
                DataColumn(label: Text('Kode', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Warga', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Banjar', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Estimasi', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Waktu', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: filtered.map((t) {
                return DataRow(
                  cells: [
                    DataCell(Text(t.$1, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen))),
                    DataCell(Text(t.$2)),
                    DataCell(Text(t.$3)),
                    DataCell(Text(t.$4)),
                    DataCell(AppBadge(label: t.$5)),
                    DataCell(Text(t.$6)),
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
