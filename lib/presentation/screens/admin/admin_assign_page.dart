import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../tps/tps_assign_screen.dart';

/// Halaman penugasan driver untuk Admin (memakai layar yang sama dengan TPS).
class AdminAssignPage extends StatelessWidget {
  const AdminAssignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.surface,
      appBar: KbAppBar(title: 'Penugasan driver'),
      body: TpsAssignScreen(embedded: true),
    );
  }
}
