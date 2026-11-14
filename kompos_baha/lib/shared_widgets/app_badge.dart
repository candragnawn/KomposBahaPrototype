import 'package:flutter/material.dart';
import '../app/constants/app_colors.dart';

class AppBadge extends StatelessWidget {
  final String label;

  const AppBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (label) {
      case 'Menunggu konfirmasi':
        bg = AppColors.statusWaitingBg;
        text = AppColors.statusWaitingText;
        break;
      case 'Driver ditugaskan':
        bg = AppColors.statusAssignedBg;
        text = AppColors.statusAssignedText;
        break;
      case 'Dalam penjemputan':
        bg = AppColors.statusPickupBg;
        text = AppColors.statusPickupText;
        break;
      case 'Diterima TPS 3R':
        bg = AppColors.statusReceivedBg;
        text = AppColors.statusReceivedText;
        break;
      case 'Poin diberikan':
        bg = AppColors.statusPointsBg;
        text = AppColors.statusPointsText;
        break;
      case 'Gagal jemput':
      case 'Ditolak TPS':
        bg = AppColors.statusFailedBg;
        text = AppColors.statusFailedText;
        break;
      case 'Dibatalkan':
      case 'Draft':
      default:
        bg = AppColors.statusDraftBg;
        text = AppColors.statusDraftText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

