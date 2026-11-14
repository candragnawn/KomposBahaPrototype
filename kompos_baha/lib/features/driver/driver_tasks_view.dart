import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';
import '../../shared_widgets/app_badge.dart';
import '../../shared_widgets/illustrations.dart';

class DriverTasksView extends StatefulWidget {
  final VoidCallback onOpenDetail;

  const DriverTasksView({super.key, required this.onOpenDetail});

  @override
  State<DriverTasksView> createState() => _DriverTasksViewState();
}

class _DriverTasksViewState extends State<DriverTasksView> {
  bool _isReady = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo,', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  Text(
                    'Kadek Dwi Arta',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Text('Siap tugas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink)),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isReady,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) => setState(() => _isReady = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.mintBorder),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hari ini', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                      SizedBox(height: 2),
                      Text(
                        '3 tugas · 35 kg',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.ink),
                      ),
                      SizedBox(height: 2),
                      Text('18 Oktober 2026', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                ),
                PickupTruckIllustration(width: 80, height: 60),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Banjar Group 1
          const Text(
            'Banjar Baha Kelod • 08.00 - 10.00',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.muted),
          ),
          const SizedBox(height: 10),

          _buildTaskCard(
            name: 'Ni Luh Ayu Wulandari',
            address: 'Jl. Baha No. 7',
            weight: '12 kg • 08.00 - 10.00',
            onTap: widget.onOpenDetail,
          ),
          const SizedBox(height: 8),
          _buildTaskCard(
            name: 'I Made Sukarta',
            address: 'Gg. Melati No. 3',
            weight: '8 kg • 08.00 - 10.00',
            onTap: widget.onOpenDetail,
          ),

          const SizedBox(height: 20),

          // Banjar Group 2
          const Text(
            'Banjar Baha Kaja • 10.00 - 12.00',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          _buildTaskCard(
            name: 'Ni Kadek Sari',
            address: 'Jl. Baha Kaja No. 22',
            weight: '15 kg • 10.00 - 12.00',
            onTap: widget.onOpenDetail,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required String name,
    required String address,
    required String weight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(address, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 2),
                Text(weight, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
            const AppBadge(label: 'Driver ditugaskan'),
          ],
        ),
      ),
    );
  }
}

