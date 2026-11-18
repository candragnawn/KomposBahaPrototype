import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/common/photo_picker.dart';

/// Timbang & periksa kompos di TPS 3R, lalu berikan poin.
class VerifyScreen extends StatefulWidget {
  final String orderId;
  const VerifyScreen({super.key, required this.orderId});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _kg = TextEditingController();
  CompostQuality? _quality;
  final Set<String> _checks = {};
  String? _photo;
  bool _submitted = false;

  static const _checklist = [
    ('Sudah matang', 'Cokelat kehitaman, berbau tanah'),
    ('Tidak becek', 'Tidak meneteskan air saat digenggam'),
    ('Bebas plastik', 'Tidak ada sampah anorganik'),
  ];

  @override
  void dispose() {
    _kg.dispose();
    super.dispose();
  }

  double? get _weight => Fmt.parseKg(_kg.text);

  Future<void> _submit(PickupOrder o) async {
    setState(() => _submitted = true);
    final w = _weight;
    if (w == null || w <= 0 || _quality == null) {
      showKbSnack(context, 'Isi berat timbangan dan pilih kualitas.', error: true);
      return;
    }
    final app = context.read<AppProvider>();
    final (pts, bonus) = app.calculatePoints(w, _quality!);
    final ok = await showConfirmDialog(
      context,
      title: 'Berikan ${Fmt.number(pts + bonus)} poin?',
      message: '${o.wargaName}\nBerat ${Fmt.kg(w)} kg · Kualitas ${_quality!.label}\n\nPoin langsung masuk ke saldo warga dan tidak bisa dibatalkan.',
      confirmLabel: 'Ya, berikan poin',
      icon: Icons.verified_rounded,
    );
    if (!ok || !mounted) return;
    final err = app.verifyOrder(
      orderId: o.id,
      officialKg: w,
      quality: _quality!,
      checklist: _checks.toList(),
      photoPath: _photo,
    );
    if (err != null) {
      showKbSnack(context, err, error: true);
      return;
    }
    showKbSnack(context, 'Berhasil! ${Fmt.number(pts + bonus)} poin dikirim ke ${o.wargaName}.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final o = app.orderById(widget.orderId);
    if (o == null || o.status != OrderStatus.diantar) {
      return Scaffold(
        appBar: const KbAppBar(title: 'Timbang kompos'),
        body: KbScrollPage(children: [
          EmptyState(
            icon: Icons.task_alt_rounded,
            title: o == null ? 'Data tidak ditemukan' : 'Setoran sudah diproses',
            message: o == null ? 'Setoran ini tidak tersedia.' : 'Status saat ini: ${o.status.label}.',
          ),
        ]),
      );
    }
    final s = app.settings;
    final w = _weight;
    final preview = (w != null && w > 0 && _quality != null) ? app.calculatePoints(w, _quality!) : null;

    return Scaffold(
      appBar: KbAppBar(title: 'Timbang ${o.code}', subtitle: o.wargaName),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(label: 'Simpan & berikan poin', icon: Icons.verified_rounded, onPressed: () => _submit(o)),
      ]),
      body: KbScrollPage(
        children: [
          KbCard(
            child: Column(
              children: [
                InfoRow(icon: Icons.person_rounded, label: 'Warga', value: o.wargaName),
                InfoRow(icon: Icons.location_city_rounded, label: 'Banjar', value: o.banjar),
                InfoRow(icon: Icons.scale_rounded, label: 'Perkiraan warga', value: '±${Fmt.kg(o.estimatedKg)} kg'),
                InfoRow(icon: Icons.local_shipping_rounded, label: 'Driver', value: o.driverName ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: PhotoPreview(label: 'Foto dari warga', path: o.photoWarga)),
              const SizedBox(width: 12),
              Expanded(child: PhotoPreview(label: 'Foto saat diambil', path: o.photoPickup)),
            ],
          ),
          const SizedBox(height: 24),

          Text('1. Berat hasil timbangan', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _kg,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Contoh: 12,5',
              suffixText: 'kg',
              suffixStyle: AppTypography.titleMedium,
              errorText: _submitted && (w == null || w <= 0) ? 'Isi berat timbangan' : null,
            ),
          ),
          const SizedBox(height: 24),

          Text('2. Pemeriksaan mutu', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          for (final c in _checklist) ...[
            ChoiceTile(
              label: c.$1,
              description: c.$2,
              selected: _checks.contains(c.$1),
              onTap: () => setState(() {
                if (!_checks.remove(c.$1)) _checks.add(c.$1);
                if (_checks.length == _checklist.length) _quality ??= CompostQuality.baik;
              }),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 16),

          Text('3. Kualitas kompos', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          ChoiceTile(
            label: 'Baik',
            description: 'Poin penuh (${s.pointsPerKg} poin/kg) + bonus ${s.bonusPoints} jika ≥ ${Fmt.kg(s.bonusMinKg)} kg',
            icon: Icons.sentiment_very_satisfied_rounded,
            selected: _quality == CompostQuality.baik,
            onTap: () => setState(() => _quality = CompostQuality.baik),
          ),
          const SizedBox(height: 8),
          ChoiceTile(
            label: 'Cukup',
            description: '${s.cukupPercent}% dari poin penuh, tanpa bonus',
            icon: Icons.sentiment_neutral_rounded,
            selected: _quality == CompostQuality.cukup,
            onTap: () => setState(() => _quality = CompostQuality.cukup),
          ),
          if (_submitted && _quality == null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Pilih kualitas kompos', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ),
          const SizedBox(height: 8),
          Text(
            'Jika kompos tidak layak (tercampur plastik / busuk / becek), kembali dan pilih "Tolak kompos".',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 24),

          PhotoPickerTile(
            label: '4. Foto di TPS 3R',
            isRequired: false,
            path: _photo,
            onPicked: (p) => setState(() => _photo = p),
            onRemove: () => setState(() => _photo = null),
          ),

          if (preview != null)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Poin yang akan diberikan', style: AppTypography.bodyMedium.copyWith(color: AppColors.goldText)),
                  Text(
                    '+${Fmt.number(preview.$1 + preview.$2)} poin',
                    style: AppTypography.displayMedium.copyWith(color: AppColors.dark),
                  ),
                  Text(
                    'Poin dasar ${Fmt.number(preview.$1)}${preview.$2 > 0 ? ' + bonus ${preview.$2}' : ''}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.goldText),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
