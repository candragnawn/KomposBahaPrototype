import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_badge.dart';
import '../../shared_widgets/app_button.dart';

class TpsIncomingView extends ConsumerStatefulWidget {
  const TpsIncomingView({super.key});

  @override
  ConsumerState<TpsIncomingView> createState() => _TpsIncomingViewState();
}

class _TpsIncomingViewState extends ConsumerState<TpsIncomingView> {
  void _openVerificationDialog(String code) {
    final weightController = TextEditingController(text: '11.5');
    String quality = 'Baik';
    bool c1 = true;
    bool c2 = true;
    bool c3 = true;
    bool showReject = false;
    String rejectReason = 'Tercampur sampah anorganik';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final numWeight = double.tryParse(weightController.text.replaceAll(',', '.')) ?? 0;
            final calculatedPoints = (numWeight * 10).round();

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(code, style: const TextStyle(fontSize: 12, color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                      const Text('Verifikasi Kompos Masuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 440,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppBadge(label: 'Diterima TPS 3R'),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Warga: Ni Luh Ayu Wulandari', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                Text('Banjar: Baha Kelod', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Driver: Kadek Dwi Arta', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                                Text('Estimasi: 12 kg', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Berat resmi timbangan (kg)'),
                        onChanged: (v) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: quality,
                        decoration: const InputDecoration(labelText: 'Kualitas kompos'),
                        items: const [
                          DropdownMenuItem(value: 'Baik', child: Text('Baik')),
                          DropdownMenuItem(value: 'Cukup', child: Text('Cukup')),
                          DropdownMenuItem(value: 'Kurang', child: Text('Kurang')),
                        ],
                        onChanged: (v) {
                          if (v != null) setDialogState(() => quality = v);
                        },
                      ),
                      const SizedBox(height: 14),
                      const Text('Pemeriksaan mutu:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Tidak tercampur plastik / anorganik', style: TextStyle(fontSize: 13)),
                        value: c1,
                        activeColor: AppColors.primaryGreen,
                        onChanged: (v) => setDialogState(() => c1 = v ?? false),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Kadar air sesuai (tidak becek)', style: TextStyle(fontSize: 13)),
                        value: c2,
                        activeColor: AppColors.primaryGreen,
                        onChanged: (v) => setDialogState(() => c2 = v ?? false),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Sudah matang & tidak berbau busuk', style: TextStyle(fontSize: 13)),
                        value: c3,
                        activeColor: AppColors.primaryGreen,
                        onChanged: (v) => setDialogState(() => c3 = v ?? false),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMint,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.mintBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Poin yang akan diberikan:', style: TextStyle(fontSize: 13, color: AppColors.ink)),
                            Text(
                              '+$calculatedPoints poin',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryGreen),
                            ),
                          ],
                        ),
                      ),
                      if (showReject) ...[
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: rejectReason,
                          decoration: const InputDecoration(labelText: 'Alasan penolakan'),
                          items: const [
                            DropdownMenuItem(value: 'Tercampur sampah anorganik', child: Text('Tercampur sampah anorganik')),
                            DropdownMenuItem(value: 'Kompos belum matang', child: Text('Kompos belum matang')),
                            DropdownMenuItem(value: 'Kadar air terlalu tinggi', child: Text('Kadar air terlalu tinggi')),
                          ],
                          onChanged: (v) {
                            if (v != null) setDialogState(() => rejectReason = v);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                if (!showReject) ...[
                  AppButton(
                    label: 'Tolak',
                    variant: ButtonVariant.danger,
                    onPressed: () => setDialogState(() => showReject = true),
                  ),
                  AppButton(
                    label: 'Terima dan berikan poin',
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      Navigator.pop(ctx);
                      ref.read(appStateProvider.notifier).verifyOrder(code, weightController.text, quality);
                    },
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () => setDialogState(() => showReject = false),
                    child: const Text('Batal'),
                  ),
                  AppButton(
                    label: 'Konfirmasi penolakan',
                    variant: ButtonVariant.danger,
                    onPressed: () {
                      Navigator.pop(ctx);
                      ref.read(appStateProvider.notifier).rejectOrder(code, rejectReason);
                    },
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Operasional', style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 2),
        const Text('Kompos Masuk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('Kode', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Warga', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Banjar', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Estimasi', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: state.orders.map((order) {
              return DataRow(
                onSelectChanged: (_) => _openVerificationDialog(order.code),
                cells: [
                  DataCell(Text(order.code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen))),
                  DataCell(Text(order.residentName)),
                  DataCell(Text(order.banjar)),
                  DataCell(Text(order.driverName ?? '-')),
                  DataCell(Text('${order.estimatedWeight} kg')),
                  DataCell(AppBadge(label: order.status)),
                  DataCell(
                    AppButton(
                      label: 'Timbang / Verifikasi',
                      onPressed: () => _openVerificationDialog(order.code),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

