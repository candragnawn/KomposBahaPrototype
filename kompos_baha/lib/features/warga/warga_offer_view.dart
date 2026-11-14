import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../app/constants/app_colors.dart';
import '../../core/models/offer_stage.dart';
import '../../core/providers/app_state_provider.dart';
import '../../shared_widgets/app_badge.dart';
import '../../shared_widgets/app_button.dart';
import '../../shared_widgets/status_timeline.dart';

class WargaOfferView extends ConsumerStatefulWidget {
  final bool isDetail;
  final VoidCallback onBack;
  final VoidCallback onOpenDetail;

  const WargaOfferView({
    super.key,
    required this.isDetail,
    required this.onBack,
    required this.onOpenDetail,
  });

  @override
  ConsumerState<WargaOfferView> createState() => _WargaOfferViewState();
}

class _WargaOfferViewState extends ConsumerState<WargaOfferView> {
  final _weightController = TextEditingController(text: '12');
  final _notesController = TextEditingController(
    text: 'Kompos disimpan di karung putih dekat pintu samping.',
  );
  String _timeSlot = '08.00 - 10.00';
  bool _photoAdded = false;
  String _error = '';
  bool _isLoading = false;
  String? _newOfferCode;

  void _submitOffer() {
    if (!_photoAdded) {
      setState(() => _error = 'Foto kompos wajib ditambahkan.');
      return;
    }
    setState(() {
      _error = '';
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        final code = ref.read(appStateProvider.notifier).addOffer(
              estimatedWeight: _weightController.text,
              address: 'Jl. Baha No. 18, Banjar Baha Kelod',
              timeSlot: _timeSlot,
              notes: _notesController.text,
            );
        setState(() {
          _isLoading = false;
          _newOfferCode = code;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);

    if (widget.isDetail) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.arrowLeft, color: AppColors.ink),
                  onPressed: widget.onBack,
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Detail pesanan', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    Text(
                      'KB-0412',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink),
                    ),
                  ],
                ),
                const Spacer(),
                AppBadge(
                  label: state.stage == OfferStage.none
                      ? 'Poin diberikan'
                      : state.stage.displayStatus,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Timeline Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusTimelineWidget(stage: state.stage == OfferStage.none ? OfferStage.verified : state.stage),
                  const Divider(height: 24, color: AppColors.border),
                  const Text(
                    '14 Okt 2026 • 15.42 WITA',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Driver Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surfaceMint,
                    child: Text('KD', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Driver penjemput', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        Text(
                          'Kadek Dwi Arta',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.phone, color: AppColors.primaryGreen),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // TPS Verification Result Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceMint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.mintBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil verifikasi TPS 3R',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Berat resmi:', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                      Text('8,2 kg', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kualitas:', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                      Text('Baik', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Poin diperoleh:', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                      Text('+82 poin', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),

            if (state.stage == OfferStage.waiting || state.stage == OfferStage.assigned) ...[
              const SizedBox(height: 20),
              AppButton(
                label: 'Batalkan penawaran',
                variant: ButtonVariant.danger,
                wide: true,
                onPressed: () {
                  ref.read(appStateProvider.notifier).setStage(OfferStage.none);
                  widget.onBack();
                },
              ),
            ],
          ],
        ),
      );
    }

    // Create Offer View
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: AppColors.ink),
                onPressed: widget.onBack,
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Setor kompos', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  Text(
                    'Buat penawaran',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.mintBorder),
            ),
            child: const Text(
              'Poin diberikan setelah berat dan kualitas disahkan TPS 3R.',
              style: TextStyle(color: AppColors.ink, fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),

          // Form fields
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Estimasi berat (kg)',
              helperText: 'Berat resmi ditentukan saat penimbangan',
            ),
          ),
          const SizedBox(height: 16),

          // Upload Box
          InkWell(
            onTap: () {
              setState(() {
                _photoAdded = true;
                _error = '';
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _error.isNotEmpty ? AppColors.error : AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _photoAdded ? LucideIcons.checkCircle : LucideIcons.camera,
                    color: _photoAdded ? AppColors.primaryGreen : AppColors.muted,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _photoAdded ? 'Foto kompos-sudarta.jpg ditambahkan' : 'Tambahkan foto kompos (wajib)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _photoAdded ? AppColors.primaryGreen : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(_error, style: const TextStyle(color: AppColors.error, fontSize: 12)),
          ],
          const SizedBox(height: 16),

          const TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Alamat penjemputan',
              hintText: 'Jl. Baha No. 18, Banjar Baha Kelod',
            ),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: _timeSlot,
            decoration: const InputDecoration(labelText: 'Jam siap'),
            items: const [
              DropdownMenuItem(value: '08.00 - 10.00', child: Text('08.00 - 10.00')),
              DropdownMenuItem(value: '10.00 - 12.00', child: Text('10.00 - 12.00')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _timeSlot = v);
            },
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Catatan untuk driver'),
          ),
          const SizedBox(height: 24),

          AppButton(
            label: _isLoading ? 'Mengirim penawaran...' : 'Kirim penawaran',
            variant: ButtonVariant.primary,
            wide: true,
            isLoading: _isLoading,
            onPressed: _submitOffer,
          ),

          if (_newOfferCode != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.statusPointsBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryGreen),
              ),
              child: Column(
                children: [
                  const Icon(LucideIcons.checkCircle2, color: AppColors.primaryGreen, size: 36),
                  const SizedBox(height: 8),
                  const Text('Penawaran terkirim', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Kode: $_newOfferCode', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen)),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Lihat status',
                    variant: ButtonVariant.primary,
                    wide: true,
                    onPressed: widget.onOpenDetail,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

