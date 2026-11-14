import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_badge.dart';
import '../../shared_widgets/app_button.dart';

class AdminComplaintsView extends StatefulWidget {
  const AdminComplaintsView({super.key});

  @override
  State<AdminComplaintsView> createState() => _AdminComplaintsViewState();
}

class _AdminComplaintsViewState extends State<AdminComplaintsView> {
  void _openComplaintDetail(String id, String resident, String topic, String desc) {
    final replyController = TextEditingController();
    bool sent = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$id · $topic', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              content: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pelapor: $resident', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(desc, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: replyController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Balasan resmi pemerintah desa'),
                    ),
                  ],
                ),
              ),
              actions: [
                AppButton(
                  label: sent ? 'Terkirim!' : 'Kirim balasan',
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    setDialogState(() => sent = true);
                    Future.delayed(const Duration(milliseconds: 700), () {
                      if (ctx.mounted) Navigator.pop(ctx);
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pengaduan Warga', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
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
                DataColumn(label: Text('Nomor')),
                DataColumn(label: Text('Pelapor')),
                DataColumn(label: Text('Topik')),
                DataColumn(label: Text('Tanggal')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Tindakan')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('PGD-018', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('Ni Luh Ayu Wulandari')),
                  const DataCell(Text('Driver terlambat')),
                  const DataCell(Text('18 Okt 2026')),
                  const DataCell(AppBadge(label: 'Menunggu konfirmasi')),
                  DataCell(
                    AppButton(
                      label: 'Tanggapi',
                      onPressed: () => _openComplaintDetail(
                        'PGD-018',
                        'Ni Luh Ayu Wulandari',
                        'Driver terlambat',
                        'Penjemputan dijadwalkan pukul 09.00 - 11.00, tetapi driver belum tiba sampai pukul 12.30.',
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('PGD-017', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('I Made Ariasa')),
                  const DataCell(Text('Poin belum masuk')),
                  const DataCell(Text('17 Okt 2026')),
                  const DataCell(AppBadge(label: 'Diterima TPS 3R')),
                  DataCell(
                    AppButton(
                      label: 'Tanggapi',
                      onPressed: () => _openComplaintDetail(
                        'PGD-017',
                        'I Made Ariasa',
                        'Poin belum masuk',
                        'Kompos sudah disetor kemarin sore tetapi saldo mutasi poin belum bertambah.',
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AdminReportsView extends StatelessWidget {
  const AdminReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Laporan Bulanan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
            Row(
              children: [
                AppButton(label: 'Ekspor PDF', onPressed: () {}),
                const SizedBox(width: 8),
                AppButton(label: 'Ekspor CSV', onPressed: () {}),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kompos terserap', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    SizedBox(height: 4),
                    Text('1.284 kg', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
                    Text('124 transaksi', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Poin diterbitkan', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    SizedBox(height: 4),
                    Text('12.840', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                    Text('senilai setoran terverifikasi', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Poin ditukar', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    SizedBox(height: 4),
                    Text('8.460', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
                    Text('66% dari poin terbit', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
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
              columns: [
                DataColumn(label: Text('Banjar')),
                DataColumn(label: Text('Total (kg)')),
                DataColumn(label: Text('Setoran')),
                DataColumn(label: Text('Warga Aktif')),
                DataColumn(label: Text('Poin Terbit')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('Baha Kelod', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('486 kg')),
                  DataCell(Text('44')),
                  DataCell(Text('68')),
                  DataCell(Text('4.860')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Baha Kaja', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('421 kg')),
                  DataCell(Text('41')),
                  DataCell(Text('62')),
                  DataCell(Text('4.210')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Baha Tengah', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text('377 kg')),
                  DataCell(Text('39')),
                  DataCell(Text('56')),
                  DataCell(Text('3.770')),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

