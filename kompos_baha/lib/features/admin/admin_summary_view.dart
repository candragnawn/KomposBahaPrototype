import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_badge.dart';

class AdminSummaryView extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;

  const AdminSummaryView({
    super.key,
    required this.onNavigateToTransactions,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Total organik terserap', '1.284 kg', '+12% vs bln lalu'),
      ('Warga aktif menyetor', '48 KK', '32% dari target'),
      ('SLA Jemput warga', '42 mnt', 'Target < 60 mnt'),
      ('Poin beredar', '12.450', 'Rp 1.245.000'),
    ];

    final isMobile = MediaQuery.of(context).size.width < 750;

    final chartWidget = Container(
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
                        return const Text('');
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 280, color: AppColors.primaryGreen, width: 24, borderRadius: BorderRadius.circular(4))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 340, color: AppColors.primaryGreen, width: 24, borderRadius: BorderRadius.circular(4))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 310, color: AppColors.primaryGreen, width: 24, borderRadius: BorderRadius.circular(4))]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 410, color: const Color(0xFF19B28D), width: 24, borderRadius: BorderRadius.circular(4))]),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final metricsWidget = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status setoran aktif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          _MetricItem(label: 'Menunggu konfirmasi', count: '4'),
          Divider(height: 20, color: AppColors.border),
          _MetricItem(label: 'Driver ditugaskan', count: '2'),
          Divider(height: 20, color: AppColors.border),
          _MetricItem(label: 'Dalam penjemputan', count: '1'),
          Divider(height: 20, color: AppColors.border),
          _MetricItem(label: 'Diterima TPS 3R', count: '6'),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ringkasan Eksekutif', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 16),

        // KPI Stat Cards
        LayoutBuilder(
          builder: (context, constraints) {
            if (isMobile) {
              final cardWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: stats.map((s) {
                  return SizedBox(
                    width: cardWidth,
                    child: Container(
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
                          Text(s.$2, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
                          const SizedBox(height: 4),
                          Text(s.$3, style: const TextStyle(fontSize: 11, color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }

            return Row(
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
            );
          },
        ),

        const SizedBox(height: 24),

        // Middle Row: Bar Chart & Status Metrics
        if (isMobile) ...[
          chartWidget,
          const SizedBox(height: 16),
          metricsWidget,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: chartWidget),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: metricsWidget),
            ],
          ),
        ],

        const SizedBox(height: 24),

        // Recent Transactions Table
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
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
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
        Text(count, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
      ],
    );
  }
}
