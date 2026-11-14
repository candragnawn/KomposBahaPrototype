import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_badge.dart';

class AdminSummaryView extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;

  const AdminSummaryView({super.key, required this.onNavigateToTransactions});

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Kg kompos terserap bulan ini', '1.284 kg', '+12% dari September'),
      ('Warga aktif', '186', 'dari 324 terdaftar'),
      ('Rata-rata penjemputan', '2,4 jam', 'target di bawah 3 jam'),
      ('Poin ditukar', '8.460', 'bulan berjalan'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('25 Oktober 2026', style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 2),
        const Text('Ringkasan Layanan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 20),

        // KPI 4 Cards Grid
        Row(
          children: stats.map((s) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.$1, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(height: 6),
                    Text(s.$2, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
                    const SizedBox(height: 4),
                    Text(s.$3, style: const TextStyle(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Middle Row: Bar Chart & Status Metrics
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar Chart
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kompos per minggu (kg)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('1.284 kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 500,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, meta) {
                                  const titles = ['M1', 'M2', 'M3', 'M4'];
                                  final i = val.toInt();
                                  if (i >= 0 && i < titles.length) {
                                    return Text(titles[i], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 230, color: AppColors.primaryGreen, width: 28, borderRadius: BorderRadius.circular(4))]),
                            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 310, color: AppColors.primaryGreen, width: 28, borderRadius: BorderRadius.circular(4))]),
                            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 286, color: AppColors.primaryGreen, width: 28, borderRadius: BorderRadius.circular(4))]),
                            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 458, color: AppColors.mintAccent, width: 28, borderRadius: BorderRadius.circular(4))]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Status Metric List
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status layanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 16),
                    _MetricItem(label: 'Menunggu driver', count: '3'),
                    Divider(height: 20, color: AppColors.border),
                    _MetricItem(label: 'Dalam penjemputan', count: '4'),
                    Divider(height: 20, color: AppColors.border),
                    _MetricItem(label: 'Menunggu verifikasi', count: '5'),
                    Divider(height: 20, color: AppColors.border),
                    _MetricItem(label: 'Pengaduan terbuka', count: '2'),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Recent Transactions Section
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Transaksi terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton(
                      onPressed: onNavigateToTransactions,
                      child: const Text('Lihat semua', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Kode')),
                  DataColumn(label: Text('Warga')),
                  DataColumn(label: Text('Banjar')),
                  DataColumn(label: Text('Estimasi')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Waktu')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('KB-0415', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text('Ni Kadek Sari')),
                    DataCell(Text('Baha Kaja')),
                    DataCell(Text('15 kg')),
                    DataCell(AppBadge(label: 'Menunggu konfirmasi')),
                    DataCell(Text('18 Okt, 10.00')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('KB-0412', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text('Ni Luh Ayu Wulandari')),
                    DataCell(Text('Baha Kelod')),
                    DataCell(Text('12 kg')),
                    DataCell(AppBadge(label: 'Driver ditugaskan')),
                    DataCell(Text('18 Okt, 08.00')),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String count;

  const _MetricItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
        Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
      ],
    );
  }
}

