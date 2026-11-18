import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/user_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';

// ─── Tarif poin ─────────────────────────────────────────────────────────────

class PointRateScreen extends StatefulWidget {
  final bool readOnly;
  const PointRateScreen({super.key, this.readOnly = false});

  @override
  State<PointRateScreen> createState() => _PointRateScreenState();
}

class _PointRateScreenState extends State<PointRateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _perKg;
  late final TextEditingController _bonusMin;
  late final TextEditingController _bonus;
  late final TextEditingController _cukup;

  @override
  void initState() {
    super.initState();
    final s = context.read<AppProvider>().settings;
    _perKg = TextEditingController(text: '${s.pointsPerKg}');
    _bonusMin = TextEditingController(text: Fmt.kg(s.bonusMinKg));
    _bonus = TextEditingController(text: '${s.bonusPoints}');
    _cukup = TextEditingController(text: '${s.cukupPercent}');
    for (final c in [_perKg, _bonusMin, _bonus, _cukup]) {
      c.addListener(_onChanged);
    }
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _perKg.dispose();
    _bonusMin.dispose();
    _bonus.dispose();
    _cukup.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await showConfirmDialog(
      context,
      title: 'Ubah tarif poin?',
      message: 'Tarif baru berlaku untuk setoran yang ditimbang mulai sekarang. Semua warga akan diberi tahu.',
      confirmLabel: 'Ya, simpan tarif',
    );
    if (!ok || !mounted) return;
    final app = context.read<AppProvider>();
    final next = app.settings.copyWith(
      pointsPerKg: int.parse(_perKg.text),
      bonusMinKg: Fmt.parseKg(_bonusMin.text) ?? app.settings.bonusMinKg,
      bonusPoints: int.tryParse(_bonus.text) ?? 0,
      cukupPercent: int.parse(_cukup.text),
    );
    final err = app.updateSettings(next);
    showKbSnack(context, err ?? 'Tarif poin disimpan', error: err != null);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final s = app.settings;
    final digits = [FilteringTextInputFormatter.digitsOnly];
    final ro = widget.readOnly || app.currentUser?.role != UserRole.admin;

    // Contoh perhitungan
    final perKg = int.tryParse(_perKg.text) ?? s.pointsPerKg;
    final bonusMin = Fmt.parseKg(_bonusMin.text) ?? s.bonusMinKg;
    final bonus = int.tryParse(_bonus.text) ?? s.bonusPoints;
    final cukup = int.tryParse(_cukup.text) ?? s.cukupPercent;
    int example(double kg, CompostQuality q) {
      double base = kg * perKg;
      if (q == CompostQuality.cukup) base = base * cukup / 100;
      return base.round() + ((q == CompostQuality.baik && kg >= bonusMin) ? bonus : 0);
    }

    return Scaffold(
      appBar: const KbAppBar(title: 'Tarif poin'),
      bottomNavigationBar: ro
          ? null
          : KbBottomActionBar(children: [KbButton(label: 'Simpan tarif', icon: Icons.save_rounded, onPressed: _save)]),
      body: Form(
        key: _formKey,
        child: KbScrollPage(
          children: [
            if (ro)
              const InfoBanner(message: 'Tarif hanya dapat diubah oleh Admin Desa.')
            else
              const InfoBanner(message: 'Perubahan tarif tidak memengaruhi poin dari setoran yang sudah ditimbang.'),
            const SizedBox(height: 20),
            KbTextField(
              label: 'Poin per kg (kualitas Baik)',
              controller: _perKg,
              enabled: !ro,
              keyboardType: TextInputType.number,
              inputFormatters: digits,
              prefixIcon: Icons.stars_rounded,
              validator: (v) => Validators.positiveNumber(v, label: 'Poin per kg', max: 10000),
            ),
            KbTextField(
              label: 'Persentase poin kualitas Cukup (%)',
              controller: _cukup,
              enabled: !ro,
              keyboardType: TextInputType.number,
              inputFormatters: digits,
              prefixIcon: Icons.percent_rounded,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 0 || n > 100) return 'Isi angka 0–100';
                return null;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KbTextField(
                    label: 'Bonus minimal (kg)',
                    controller: _bonusMin,
                    enabled: !ro,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => Validators.positiveNumber(v, label: 'Berat', max: 1000),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KbTextField(
                    label: 'Poin bonus',
                    controller: _bonus,
                    enabled: !ro,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                  ),
                ),
              ],
            ),
            KbCard(
              color: AppColors.goldLight,
              borderColor: AppColors.gold.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Contoh perhitungan', style: AppTypography.titleMedium),
                  const SizedBox(height: 6),
                  InfoRow(label: '10 kg · Baik', value: '${Fmt.number(example(10, CompostQuality.baik))} poin'),
                  InfoRow(label: '10 kg · Cukup', value: '${Fmt.number(example(10, CompostQuality.cukup))} poin'),
                  InfoRow(
                    label: '${Fmt.kg(bonusMin)} kg · Baik',
                    value: '${Fmt.number(example(bonusMin, CompostQuality.baik))} poin',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Riwayat tarif'),
            if (s.rateHistory.isEmpty)
              Text('Belum ada riwayat.', style: AppTypography.bodySmall)
            else
              KbMenuGroup(children: [
                for (int i = 0; i < s.rateHistory.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: i == 0 ? AppColors.primary : AppColors.sageLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.history_rounded, color: i == 0 ? Colors.white : AppColors.muted),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${s.rateHistory[i].pointsPerKg} poin/kg · Cukup ${s.rateHistory[i].cukupPercent}%',
                                style: AppTypography.titleSmall,
                              ),
                              Text(
                                'Bonus ${s.rateHistory[i].bonusPoints} (≥ ${Fmt.kg(s.rateHistory[i].bonusMinKg)} kg) · '
                                '${Fmt.date(s.rateHistory[i].effectiveAt)}${s.rateHistory[i].changedBy.isEmpty ? '' : ' · ${s.rateHistory[i].changedBy}'}',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (i == 0) Text('Aktif', style: AppTypography.labelMedium.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ),
              ]),
          ],
        ),
      ),
    );
  }
}

// ─── Kuota, jadwal & data desa ──────────────────────────────────────────────

class QuotaSettingsScreen extends StatefulWidget {
  const QuotaSettingsScreen({super.key});

  @override
  State<QuotaSettingsScreen> createState() => _QuotaSettingsScreenState();
}

class _QuotaSettingsScreenState extends State<QuotaSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _quota;
  late final TextEditingController _maxActive;
  late final TextEditingController _validDays;
  late final TextEditingController _adminPhone;
  late final TextEditingController _office;
  late final TextEditingController _hours;
  late List<String> _slots;
  late List<String> _banjars;
  late Set<int> _days;

  static const _dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    final s = context.read<AppProvider>().settings;
    _quota = TextEditingController(text: Fmt.kg(s.dailyQuotaKg));
    _maxActive = TextEditingController(text: '${s.maxActiveOrders}');
    _validDays = TextEditingController(text: '${s.redemptionValidDays}');
    _adminPhone = TextEditingController(text: s.adminPhone);
    _office = TextEditingController(text: s.officeAddress);
    _hours = TextEditingController(text: s.officeHours);
    _slots = [...s.timeSlots];
    _banjars = [...s.banjarList];
    _days = {...s.serviceDays};
  }

  @override
  void dispose() {
    for (final c in [_quota, _maxActive, _validDays, _adminPhone, _office, _hours]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addItem({required String title, required String hint, required List<String> target}) async {
    final v = await showTextInputDialog(context, title: title, label: title, hint: hint, confirmLabel: 'Tambah', maxLines: 1);
    if (v == null) return;
    final t = v.trim();
    if (t.isEmpty || target.contains(t)) return;
    setState(() => target.add(t));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final app = context.read<AppProvider>();
    final isAdmin = app.currentUser?.role == UserRole.admin;
    final days = _days.toList()..sort();
    final next = app.settings.copyWith(
      dailyQuotaKg: Fmt.parseKg(_quota.text),
      maxActiveOrders: int.tryParse(_maxActive.text),
      redemptionValidDays: int.tryParse(_validDays.text),
      timeSlots: _slots,
      serviceDays: days,
      banjarList: isAdmin ? _banjars : null,
      adminPhone: isAdmin ? Validators.normalizePhone(_adminPhone.text) : null,
      officeAddress: isAdmin ? _office.text.trim() : null,
      officeHours: isAdmin ? _hours.text.trim() : null,
    );
    final err = app.updateSettings(next);
    showKbSnack(context, err ?? 'Pengaturan disimpan', error: err != null);
    if (err == null) Navigator.of(context).pop();
  }

  Widget _chipList(List<String> items, VoidCallback onAdd, String addLabel) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final it in items)
          InputChip(
            label: Text(it, style: AppTypography.labelLarge.copyWith(color: AppColors.primaryDark)),
            onDeleted: items.length <= 1 ? null : () => setState(() => items.remove(it)),
            deleteIcon: const Icon(Icons.close_rounded, size: 20),
            backgroundColor: AppColors.primarySurface,
          ),
        ActionChip(
          avatar: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(addLabel, style: AppTypography.labelLarge.copyWith(color: Colors.white)),
          backgroundColor: AppColors.primary,
          onPressed: onAdd,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isAdmin = app.currentUser?.role == UserRole.admin;
    final digits = [FilteringTextInputFormatter.digitsOnly];

    return Scaffold(
      appBar: const KbAppBar(title: 'Kuota & jadwal'),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(label: 'Simpan pengaturan', icon: Icons.save_rounded, onPressed: _save),
      ]),
      body: Form(
        key: _formKey,
        child: KbScrollPage(
          children: [
            const SectionHeader(title: 'Penerimaan TPS 3R'),
            KbTextField(
              label: 'Kuota penerimaan per hari (kg)',
              helper: 'Warga tidak bisa memilih tanggal yang kuotanya sudah penuh.',
              controller: _quota,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.scale_rounded,
              validator: (v) => Validators.positiveNumber(v, label: 'Kuota', max: 100000),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KbTextField(
                    label: 'Maks. setoran aktif / warga',
                    controller: _maxActive,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    validator: (v) => Validators.positiveNumber(v, label: 'Angka', max: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KbTextField(
                    label: 'Masa berlaku kode hadiah (hari)',
                    controller: _validDays,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    validator: (v) => Validators.positiveNumber(v, label: 'Hari', max: 90),
                  ),
                ),
              ],
            ),
            Text('Hari layanan penjemputan', style: AppTypography.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int d = 1; d <= 7; d++)
                  FilterChip(
                    label: Text(_dayNames[d - 1]),
                    selected: _days.contains(d),
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    labelStyle: AppTypography.labelLarge.copyWith(color: _days.contains(d) ? Colors.white : AppColors.primaryDark),
                    onSelected: (v) => setState(() => v ? _days.add(d) : _days.remove(d)),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Jam penjemputan', style: AppTypography.titleSmall),
            const SizedBox(height: 8),
            _chipList(_slots, () => _addItem(title: 'Tambah jam', hint: 'Contoh: 16.00 - 18.00', target: _slots), 'Tambah jam'),
            if (isAdmin) ...[
              const SizedBox(height: 28),
              const SectionHeader(title: 'Data desa'),
              Text('Daftar banjar', style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              _chipList(_banjars, () => _addItem(title: 'Tambah banjar', hint: 'Contoh: Baha Kauh', target: _banjars), 'Tambah banjar'),
              const SizedBox(height: 20),
              KbTextField(
                label: 'Nomor WhatsApp Admin Desa',
                helper: 'Dipakai untuk tombol "Chat Admin" & lupa PIN.',
                controller: _adminPhone,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.chat_rounded,
                validator: Validators.phone,
              ),
              KbTextField(
                label: 'Alamat kantor desa',
                controller: _office,
                maxLines: 2,
                prefixIcon: Icons.apartment_rounded,
                validator: (v) => Validators.required(v, label: 'Alamat'),
              ),
              KbTextField(
                label: 'Jam layanan kantor',
                controller: _hours,
                prefixIcon: Icons.schedule_rounded,
                validator: (v) => Validators.required(v, label: 'Jam layanan'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
