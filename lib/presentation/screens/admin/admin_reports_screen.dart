import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../tps/tps_recap_screen.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  String? _savedPath;

  Future<void> _copy(AppProvider app) async {
    await Clipboard.setData(ClipboardData(text: app.monthlyCsv(_month)));
    if (!mounted) return;
    showKbSnack(context, 'Laporan disalin. Tempel di Excel / Google Sheets.');
  }

  Future<void> _saveFile(AppProvider app) async {
    try {
      // Android: folder Android/data/id.desabaha.kompos_baha/files (bisa dibuka
      // lewat aplikasi File Manager). Selain Android: folder dokumen aplikasi.
      Directory dir;
      try {
        dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      } catch (_) {
        dir = await getApplicationDocumentsDirectory();
      }
      final name = 'laporan_kompos_baha_${_month.year}_${_month.month.toString().padLeft(2, '0')}.csv';
      final file = File('${dir.path}/$name');
      await file.writeAsString(app.monthlyCsv(_month));
      if (!mounted) return;
      setState(() => _savedPath = file.path);
      showKbSnack(context, 'File laporan tersimpan');
    } catch (e) {
      if (!mounted) return;
      showKbSnack(context, 'Gagal menyimpan file: $e', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final m = app.monthStats(_month);
    final banjar = app.banjarRecap(_month);
    final suppliers = app.supplierRecap(month: _month).take(10).toList();
    final redeemRate = m.pointsIssued == 0 ? 0 : (m.pointsRedeemed / m.pointsIssued * 100).round();

    return Scaffold(
      appBar: const KbAppBar(title: 'Laporan bulanan'),
      bottomNavigationBar: KbBottomActionBar(children: [
        Row(
          children: [
            Expanded(
              child: KbButton(
                label: 'Salin CSV',
                icon: Icons.copy_rounded,
                variant: KbButtonVariant.secondary,
                onPressed: () => _copy(app),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: KbButton(label: 'Simpan file', icon: Icons.download_rounded, onPressed: () => _saveFile(app))),
          ],
        ),
      ]),
      body: KbScrollPage(
        children: [
          MonthSwitcher(
            month: _month,
            onChanged: (d) => setState(() {
              _month = d;
              _savedPath = null;
            }),
          ),
          const SizedBox(height: 16),
          KbCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Ringkasan ${Fmt.monthYear(_month)}', style: AppTypography.titleMedium),
                const SizedBox(height: 6),
                InfoRow(icon: Icons.scale_rounded, label: 'Kompos terserap', value: '${Fmt.kg(m.verifiedKg)} kg'),
                InfoRow(icon: Icons.receipt_long_rounded, label: 'Setoran terverifikasi', value: '${m.verifiedCount}'),
                InfoRow(icon: Icons.groups_rounded, label: 'Warga aktif menyetor', value: '${m.activeWarga}'),
                InfoRow(icon: Icons.person_add_alt_1_rounded, label: 'Warga baru', value: '${m.newWarga}'),
                InfoRow(icon: Icons.stars_rounded, label: 'Poin diterbitkan', value: Fmt.number(m.pointsIssued)),
                InfoRow(icon: Icons.redeem_rounded, label: 'Poin ditukar', value: '${Fmt.number(m.pointsRedeemed)} ($redeemRate%)'),
                InfoRow(icon: Icons.block_rounded, label: 'Ditolak TPS', value: '${m.rejectedCount}', valueColor: AppColors.error),
                InfoRow(icon: Icons.report_rounded, label: 'Gagal jemput', value: '${m.failedCount}', valueColor: AppColors.error),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Per banjar'),
          KbCard(
            child: Column(
              children: [
                for (final r in banjar)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.label, style: AppTypography.titleSmall),
                              Text('${r.count} setoran · ${r.sublabel} · ${Fmt.number(r.points)} poin', style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                        Text('${Fmt.kg(r.kg)} kg', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryDark)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: '10 pemasok teratas'),
          if (suppliers.isEmpty)
            Text('Belum ada setoran terverifikasi bulan ini.', style: AppTypography.bodySmall)
          else
            KbCard(
              child: Column(
                children: [
                  for (int i = 0; i < suppliers.length; i++)
                    InfoRow(label: '${i + 1}. ${suppliers[i].label} (${suppliers[i].sublabel})', value: '${Fmt.kg(suppliers[i].kg)} kg'),
                ],
              ),
            ),
          if (_savedPath != null) ...[
            const SizedBox(height: 16),
            InfoBanner.success(title: 'File tersimpan', message: _savedPath!),
          ],
          const SizedBox(height: 12),
          Text(
            'Format CSV memakai pemisah titik koma (;) agar langsung terbaca di Excel berbahasa Indonesia.',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
