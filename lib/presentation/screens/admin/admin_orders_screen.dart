import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/order_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';

/// Semua setoran dengan pencarian & filter (Admin).
class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final _search = TextEditingController();
  int _status = 0;
  String _banjar = 'Semua banjar';
  int _limit = 30;

  static const _statusFilters = <(String, List<OrderStatus>?)>[
    ('Semua', null),
    ('Menunggu', [OrderStatus.menunggu]),
    ('Ditugaskan', [OrderStatus.ditugaskan]),
    ('Dijemput', [OrderStatus.dijemput]),
    ('Di TPS', [OrderStatus.diantar]),
    ('Selesai', [OrderStatus.selesai]),
    ('Gagal/Ditolak', [OrderStatus.gagal, OrderStatus.ditolak, OrderStatus.dibatalkan]),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();

    final q = _search.text.trim().toLowerCase();
    final statuses = _statusFilters[_status].$2;
    final all = [...app.orders]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final filtered = all.where((o) {
      if (statuses != null && !statuses.contains(o.status)) return false;
      if (_banjar != 'Semua banjar' && o.banjar != _banjar) return false;
      if (q.isNotEmpty &&
          !o.code.toLowerCase().contains(q) &&
          !o.wargaName.toLowerCase().contains(q) &&
          !(o.driverName ?? '').toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();
    final shown = filtered.take(_limit).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Semua Setoran',
          subtitle: '${filtered.length} dari ${all.length} setoran',
          userName: u.name,
          notifCount: app.unreadCount(u.id),
          onNotifTap: () => NotificationsScreen.open(context),
        ),
        SliverToBoxAdapter(
          child: KbResponsive(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _search,
                    style: AppTypography.bodyLarge,
                    onChanged: (_) => setState(() => _limit = 30),
                    decoration: InputDecoration(
                      hintText: 'Cari kode, nama warga, atau driver',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Hapus pencarian',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => setState(() => _search.clear()),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  KbFilterChips(
                    labels: _statusFilters.map((e) => e.$1).toList(),
                    index: _status,
                    onChanged: (i) => setState(() {
                      _status = i;
                      _limit = 30;
                    }),
                  ),
                  const SizedBox(height: 12),
                  KbSelectField<String>(
                    label: 'Banjar',
                    value: _banjar,
                    options: ['Semua banjar', ...app.settings.banjarList],
                    labelOf: (b) => b,
                    icon: Icons.location_city_rounded,
                    onChanged: (v) => setState(() => _banjar = v),
                  ),
                  if (shown.isEmpty)
                    const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Tidak ditemukan',
                      message: 'Coba ubah kata kunci atau filter.',
                    )
                  else ...[
                    for (final o in shown) ...[
                      OrderCard(order: o, showWarga: true, onTap: () => OrderDetailScreen.open(context, o.id)),
                      const SizedBox(height: 12),
                    ],
                    if (filtered.length > shown.length)
                      TextButton.icon(
                        onPressed: () => setState(() => _limit += 30),
                        icon: const Icon(Icons.expand_more_rounded, color: AppColors.primary),
                        label: Text('Tampilkan lebih banyak (${filtered.length - shown.length} lagi)'),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
