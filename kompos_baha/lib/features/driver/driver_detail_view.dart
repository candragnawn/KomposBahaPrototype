import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/models/offer_stage.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_badge.dart';
import '../../shared_widgets/app_button.dart';

class DriverDetailView extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const DriverDetailView({super.key, required this.onBack});

  @override
  ConsumerState<DriverDetailView> createState() => _DriverDetailViewState();
}

class _DriverDetailViewState extends ConsumerState<DriverDetailView> {
  bool _pickupPhoto = false;
  bool _failed = false;

  void _showFailDialog() {
    String reason = 'Warga tidak di tempat';
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Laporkan gagal jemput'),
              content: DropdownButtonFormField<String>(
                initialValue: reason,
                decoration: const InputDecoration(labelText: 'Alasan kendala'),
                items: const [
                  DropdownMenuItem(value: 'Warga tidak di tempat', child: Text('Warga tidak di tempat')),
                  DropdownMenuItem(value: 'Kompos tidak sesuai', child: Text('Kompos tidak sesuai')),
                  DropdownMenuItem(value: 'Alamat tidak ditemukan', child: Text('Alamat tidak ditemukan')),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (v) {
                  if (v != null) setDialogState(() => reason = v);
                },
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Kembali')),
                AppButton(
                  label: 'Simpan laporan',
                  variant: ButtonVariant.danger,
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => _failed = true);
                    ref.read(appStateProvider.notifier).failDriverPickup('KB-0412', reason);
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
    final state = ref.watch(appStateProvider);
    final stage = state.stage;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(LucideIcons.arrowLeft), onPressed: widget.onBack),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KB-0412', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  Text('Detail penjemputan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
                ],
              ),
              const Spacer(),
              AppBadge(label: _failed ? 'Gagal jemput' : (stage == OfferStage.none ? 'Driver ditugaskan' : stage.displayStatus)),
            ],
          ),
          const SizedBox(height: 20),

          // Resident Address Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alamat warga', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 4),
                const Text('Ni Luh Ayu Wulandari', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink)),
                const SizedBox(height: 2),
                const Text('Jl. Baha No. 7, Banjar Baha Kelod', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Hubungi warga',
                  icon: LucideIcons.phone,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Route Map Simulation Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.mintBorder),
            ),
            child: const Column(
              children: [
                Icon(LucideIcons.map, size: 28, color: AppColors.primaryGreen),
                SizedBox(height: 6),
                Text('Rute navigasi penjemputan', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                SizedBox(height: 2),
                Text('1,8 km • sekitar 7 menit', style: TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Resident Notes & Photo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Catatan warga', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                SizedBox(height: 4),
                Text('Kompos disimpan di karung putih dekat pintu samping.', style: TextStyle(fontSize: 13, color: AppColors.ink)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(LucideIcons.camera, size: 16, color: AppColors.primaryGreen),
                    SizedBox(width: 6),
                    Text('Foto kompos dari warga terlampir', style: TextStyle(fontSize: 12, color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stage Action Progression
          if (stage == OfferStage.none || stage == OfferStage.assigned) ...[
            AppButton(
              label: 'Mulai jemput',
              variant: ButtonVariant.primary,
              wide: true,
              onPressed: () {
                ref.read(appStateProvider.notifier).setStage(OfferStage.pickup);
              },
            ),
          ] else if (stage == OfferStage.pickup) ...[
            InkWell(
              onTap: () => setState(() => _pickupPhoto = true),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _pickupPhoto ? AppColors.primaryGreen : AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_pickupPhoto ? LucideIcons.checkCircle : LucideIcons.camera, color: _pickupPhoto ? AppColors.primaryGreen : AppColors.muted),
                    const SizedBox(width: 8),
                    Text(
                      _pickupPhoto ? 'Foto pengambilan ditambahkan' : 'Tambah foto pengambilan (wajib)',
                      style: TextStyle(color: _pickupPhoto ? AppColors.primaryGreen : AppColors.muted, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Konfirmasi sudah diambil',
              variant: ButtonVariant.primary,
              wide: true,
              onPressed: _pickupPhoto
                  ? () {
                      ref.read(appStateProvider.notifier).setStage(OfferStage.collected);
                    }
                  : null,
            ),
          ] else if (stage == OfferStage.collected) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Kompos sudah diambil. Antar ke TPS 3R Desa Baha.', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Konfirmasi sudah diantar ke TPS 3R',
              variant: ButtonVariant.primary,
              wide: true,
              onPressed: () {
                ref.read(appStateProvider.notifier).setStage(OfferStage.delivered);
                widget.onBack();
              },
            ),
          ],

          const SizedBox(height: 12),
          AppButton(
            label: 'Gagal jemput',
            variant: ButtonVariant.danger,
            wide: true,
            onPressed: _showFailDialog,
          ),
        ],
      ),
    );
  }
}

