import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/id_generator.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/reward_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';

// ─── Katalog hadiah ─────────────────────────────────────────────────────────

class AdminRewardsScreen extends StatelessWidget {
  const AdminRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final list = [...app.rewards]
      ..sort((a, b) {
        if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
        return a.price.compareTo(b.price);
      });

    return Scaffold(
      appBar: const KbAppBar(title: 'Katalog hadiah'),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(
          label: 'Tambah hadiah',
          icon: Icons.add_rounded,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RewardFormScreen())),
        ),
      ]),
      body: KbScrollPage(
        children: [
          if (list.isEmpty)
            const EmptyState(icon: Icons.card_giftcard_rounded, title: 'Belum ada hadiah', message: 'Tambahkan hadiah pertama.')
          else
            for (final r in list) ...[
              KbCard(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RewardFormScreen(reward: r))),
                color: r.isActive ? null : AppColors.sageLight,
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: r.toneLight, borderRadius: BorderRadius.circular(16)),
                      child: Icon(r.icon, color: r.tone, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.name, style: AppTypography.titleSmall),
                          Text('${Fmt.number(r.price)} poin · ${Reward.categoryLabel(r.category)}', style: AppTypography.bodySmall),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              StatusPill(
                                label: 'Stok ${r.stock}',
                                color: r.stock <= 2 ? AppColors.error : AppColors.success,
                                background: r.stock <= 2 ? AppColors.errorLight : AppColors.successLight,
                              ),
                              if (!r.isActive)
                                const StatusPill(label: 'Nonaktif', color: AppColors.muted, background: AppColors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.mutedLight),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class RewardFormScreen extends StatefulWidget {
  final Reward? reward;
  const RewardFormScreen({super.key, this.reward});

  @override
  State<RewardFormScreen> createState() => _RewardFormScreenState();
}

class _RewardFormScreenState extends State<RewardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.reward?.name ?? '');
  late final TextEditingController _desc = TextEditingController(text: widget.reward?.description ?? '');
  late final TextEditingController _price = TextEditingController(text: widget.reward?.price.toString() ?? '');
  late final TextEditingController _stock = TextEditingController(text: widget.reward?.stock.toString() ?? '');
  late String _category = widget.reward?.category ?? 'bibit';
  late bool _active = widget.reward?.isActive ?? true;

  bool get _isEdit => widget.reward != null;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    _stock.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final base = widget.reward;
    final r = base == null
        ? Reward(
            id: IdGen.id(),
            name: _name.text.trim(),
            description: _desc.text.trim(),
            price: int.parse(_price.text),
            stock: int.parse(_stock.text),
            category: _category,
            isActive: _active,
            createdAt: DateTime.now(),
          )
        : base.copyWith(
            name: _name.text.trim(),
            description: _desc.text.trim(),
            price: int.parse(_price.text),
            stock: int.parse(_stock.text),
            category: _category,
            isActive: _active,
          );
    final err = context.read<AppProvider>().upsertReward(r);
    if (err != null) {
      showKbSnack(context, err, error: true);
      return;
    }
    showKbSnack(context, 'Hadiah disimpan');
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus hadiah ini?',
      message: 'Jika hadiah sudah pernah ditukar, hadiah hanya akan dinonaktifkan.',
      danger: true,
      confirmLabel: 'Ya, hapus',
    );
    if (!ok || !mounted) return;
    final msg = context.read<AppProvider>().deleteReward(widget.reward!.id);
    showKbSnack(context, msg);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final digits = [FilteringTextInputFormatter.digitsOnly];
    return Scaffold(
      appBar: KbAppBar(
        title: _isEdit ? 'Ubah hadiah' : 'Tambah hadiah',
        trailing: _isEdit
            ? IconButton(
                tooltip: 'Hapus',
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 28),
                onPressed: _delete,
              )
            : null,
      ),
      bottomNavigationBar: KbBottomActionBar(children: [
        KbButton(label: 'Simpan', icon: Icons.save_rounded, onPressed: _save),
      ]),
      body: Form(
        key: _formKey,
        child: KbScrollPage(
          children: [
            KbTextField(
              label: 'Nama hadiah',
              hint: 'Contoh: Bibit cabai (5 pohon)',
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => Validators.required(v, label: 'Nama hadiah'),
            ),
            KbTextField(
              label: 'Keterangan (opsional)',
              controller: _desc,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KbTextField(
                    label: 'Harga (poin)',
                    controller: _price,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    validator: (v) => Validators.positiveNumber(v, label: 'Harga', max: 1000000),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KbTextField(
                    label: 'Stok',
                    controller: _stock,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    validator: (v) => (v == null || v.isEmpty) ? 'Stok wajib diisi' : null,
                  ),
                ),
              ],
            ),
            Text('Kategori', style: AppTypography.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in Reward.categories)
                  ChoiceChip(
                    label: Text(Reward.categoryLabel(c)),
                    selected: _category == c,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    labelStyle: AppTypography.labelLarge.copyWith(color: _category == c ? Colors.white : AppColors.primaryDark),
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ChoiceTile(
              label: _active ? 'Tampil di katalog warga' : 'Disembunyikan dari warga',
              description: 'Ketuk untuk mengubah',
              icon: _active ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              selected: _active,
              onTap: () => setState(() => _active = !_active),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Penukaran (serahkan hadiah) ────────────────────────────────────────────

class AdminRedemptionsScreen extends StatefulWidget {
  const AdminRedemptionsScreen({super.key});

  @override
  State<AdminRedemptionsScreen> createState() => _AdminRedemptionsScreenState();
}

class _AdminRedemptionsScreenState extends State<AdminRedemptionsScreen> {
  final _code = TextEditingController();
  int _filter = 0;
  String? _foundId;
  String? _notFound;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _check() {
    FocusScope.of(context).unfocus();
    final r = context.read<AppProvider>().findRedemptionByCode(_code.text);
    setState(() {
      _foundId = r?.id;
      _notFound = r == null ? 'Kode "${_code.text.trim().toUpperCase()}" tidak ditemukan.' : null;
    });
  }

  Future<void> _complete(Redemption r) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Serahkan ${r.rewardName}?',
      message: 'Kepada ${r.wargaName}\nKode ${r.code}\n\nPastikan Anda sudah memeriksa KTP warga.',
      confirmLabel: 'Ya, hadiah diserahkan',
      icon: Icons.handshake_rounded,
    );
    if (!ok || !mounted) return;
    final err = context.read<AppProvider>().completeRedemption(r.id);
    showKbSnack(context, err ?? 'Hadiah berhasil diserahkan', error: err != null);
    if (err == null) {
      setState(() {
        _code.clear();
        _foundId = null;
      });
    }
  }

  Future<void> _cancel(Redemption r) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Batalkan penukaran?',
      message: '${Fmt.number(r.price)} poin dikembalikan ke ${r.wargaName} dan stok hadiah ditambah kembali.',
      danger: true,
      confirmLabel: 'Ya, batalkan',
    );
    if (!ok || !mounted) return;
    final err = context.read<AppProvider>().cancelRedemption(r.id);
    showKbSnack(context, err ?? 'Penukaran dibatalkan', error: err != null);
  }

  Widget _card(Redemption r) {
    return KbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(r.code, style: AppTypography.titleLarge.copyWith(letterSpacing: 2, color: AppColors.primaryDark)),
              ),
              StatusPill(label: r.status.label, color: r.status.color, background: r.status.background),
            ],
          ),
          const SizedBox(height: 6),
          Text(r.rewardName, style: AppTypography.titleMedium),
          Text('${r.wargaName} · ${Fmt.number(r.price)} poin', style: AppTypography.bodySmall),
          Text(
            r.status == RedemptionStatus.menunggu
                ? 'Berlaku sampai ${Fmt.date(r.expiresAt)}'
                : '${r.status.label} ${r.completedAt == null ? '' : Fmt.dateTime(r.completedAt!)}${r.handledBy.isEmpty ? '' : ' · ${r.handledBy}'}',
            style: AppTypography.bodySmall,
          ),
          if (r.status == RedemptionStatus.menunggu) ...[
            const SizedBox(height: 12),
            KbButton(label: 'Serahkan hadiah', icon: Icons.handshake_rounded, compact: true, onPressed: () => _complete(r)),
            const SizedBox(height: 8),
            KbButton(
              label: 'Batalkan & kembalikan poin',
              compact: true,
              variant: KbButtonVariant.ghost,
              onPressed: () => _cancel(r),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    Redemption? found;
    for (final r in app.redemptions) {
      if (r.id == _foundId) found = r;
    }
    final all = [...app.redemptions]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final list = switch (_filter) {
      0 => all.where((r) => r.status == RedemptionStatus.menunggu).toList(),
      1 => all.where((r) => r.status == RedemptionStatus.diambil).toList(),
      _ => all.where((r) => r.status == RedemptionStatus.kedaluwarsa || r.status == RedemptionStatus.dibatalkan).toList(),
    };

    return Scaffold(
      appBar: const KbAppBar(title: 'Serahkan hadiah'),
      body: KbScrollPage(
        children: [
          KbCard(
            color: AppColors.goldLight,
            borderColor: AppColors.gold.withValues(alpha: 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Cek kode dari warga', style: AppTypography.titleMedium),
                const SizedBox(height: 10),
                TextField(
                  controller: _code,
                  textCapitalization: TextCapitalization.characters,
                  style: AppTypography.titleLarge.copyWith(letterSpacing: 2),
                  textAlign: TextAlign.center,
                  onSubmitted: (_) => _check(),
                  decoration: const InputDecoration(hintText: 'TKR-XXXX', prefixIcon: Icon(Icons.qr_code_rounded)),
                ),
                const SizedBox(height: 10),
                KbButton(label: 'Cek kode', icon: Icons.search_rounded, onPressed: _check),
                if (_notFound != null) ...[const SizedBox(height: 10), InfoBanner.error(message: _notFound!)],
              ],
            ),
          ),
          if (found != null) ...[
            const SizedBox(height: 16),
            _card(found),
          ],
          const SizedBox(height: 24),
          KbSegmented(
            labels: const ['Menunggu', 'Diambil', 'Lainnya'],
            index: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 16),
          if (list.isEmpty)
            const EmptyState(icon: Icons.confirmation_number_outlined, title: 'Kosong', message: 'Tidak ada data penukaran.')
          else
            for (final r in list) ...[_card(r), const SizedBox(height: 12)],
        ],
      ),
    );
  }
}
