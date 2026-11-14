import 'package:flutter/material.dart';
import '../../app/constants/app_colors.dart';

class DriverProfileView extends StatelessWidget {
  const DriverProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Profil driver', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.ink)),
          const SizedBox(height: 24),
          const Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primaryGreen,
              child: Text('KD', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('Kadek Dwi Arta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('Driver terverifikasi · Desa Baha', style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                _ProfileItem(label: 'Nomor telepon', value: '0812 8842 1976'),
                Divider(height: 20, color: AppColors.border),
                _ProfileItem(label: 'Kendaraan armada', value: 'DK 4821 FI'),
                Divider(height: 20, color: AppColors.border),
                _ProfileItem(label: 'Tugas bulan ini', value: '42 selesai'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
      ],
    );
  }
}

