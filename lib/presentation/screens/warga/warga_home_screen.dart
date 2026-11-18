import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/services/contact_service.dart';
import '../../providers/app_provider.dart';
import '../../widgets/common/home_widgets.dart';
import '../../widgets/common/kb_app_bar.dart';
import '../../widgets/common/kb_widgets.dart';
import '../../widgets/order/order_widgets.dart';
import '../common/announcements_screen.dart';
import '../common/notifications_screen.dart';
import '../common/order_detail_screen.dart';
import '../shell/role_shell.dart';
import 'complaint_screens.dart';
import 'guide_screen.dart';

class WargaHomeScreen extends StatelessWidget {
  const WargaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final u = app.currentUser;
    if (u == null) return const SizedBox.shrink();
    final shell = ShellScope.maybeOf(context);
    final now = DateTime.now();
    final active = app.activeOrdersOfWarga(u.id);
    final monthKg = app.totalKgOfWarga(u.id, month: now);
    final announcements = app.activeAnnouncements;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        KbSliverHeader(
          title: 'Om Swastyastu!',
          subtitle: '${Fmt.greeting()}, ${u.name}',
          userName: u.name,
          notifCount: app.unreadCount(u.id),
          onNotifTap: () => NotificationsScreen.open(context),
          onAvatarTap: () => shell?.goTo(4),
        ),
        SliverToBoxAdapter(
          child: KbResponsive(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Hero ──
                  HeroBanner(
                    imagePath: AppAssets.hero,
                    fallbackSvg: AppAssets.compostBin,
                    tag: '♻  Hari ini',
                    title: 'Setor kompos,\ndapat poin',
                    subtitle: 'Driver desa siap menjemput kompos langsung ke rumah Anda.',
                    buttonLabel: 'Setor sekarang',
                    onTap: () => shell?.goTo(1),
                  ),
                  const SizedBox(height: 24),

                  // ── Statistik cepat ──
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.stars_rounded,
                          iconColor: AppColors.goldDark,
                          iconBg: AppColors.goldLight,
                          value: Fmt.number(u.points),
                          label: 'Saldo poin',
                          onTap: () => shell?.goTo(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.eco_rounded,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.primarySurface,
                          value: '${Fmt.kg(monthKg)} kg',
                          label: 'Kompos ${Fmt.monthShort(now.month)}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.local_shipping_rounded,
                          iconColor: AppColors.soil,
                          iconBg: AppColors.soilLight,
                          value: '${app.completedCountOfWarga(u.id)}x',
                          label: 'Setoran selesai',
                          onTap: () => shell?.goTo(3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Layanan ──
                  const SectionHeader(title: 'Layanan', subtitle: 'Pilih yang ingin Anda lakukan'),
                  Row(
                    children: [
                      Expanded(
                        child: CategoryCard(
                          label: 'Setor\nKompos',
                          imagePath: AppAssets.catSetor,
                          fallbackSvg: AppAssets.compostBin,
                          bgColor: AppColors.categorySetor,
                          textColor: AppColors.primaryDark,
                          onTap: () => shell?.goTo(1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CategoryCard(
                          label: 'Tukar\nHadiah',
                          imagePath: AppAssets.catHadiah,
                          fallbackSvg: AppAssets.giftBox,
                          bgColor: AppColors.categoryHadiah,
                          textColor: AppColors.goldText,
                          onTap: () => shell?.goTo(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CategoryCard(
                          label: 'Riwayat\nPoin',
                          imagePath: AppAssets.catRiwayat,
                          fallbackSvg: AppAssets.ledgerCoin,
                          bgColor: AppColors.categoryRiwayat,
                          textColor: AppColors.soil,
                          onTap: () => shell?.goTo(3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Penjemputan aktif ──
                  SectionHeader(
                    title: 'Penjemputan aktif',
                    actionLabel: active.isEmpty ? null : 'Semua',
                    onAction: () => shell?.goTo(3),
                  ),
                  if (active.isEmpty)
                    EmptyState(
                      icon: Icons.local_shipping_outlined,
                      title: 'Belum ada penjemputan',
                      message: 'Kompos Anda sudah siap? Ajukan setoran dan driver akan datang menjemput.',
                      actionLabel: 'Setor kompos',
                      onAction: () => shell?.goTo(1),
                    )
                  else
                    for (final o in active) ...[
                      OrderCard(order: o, onTap: () => OrderDetailScreen.open(context, o.id)),
                      const SizedBox(height: 12),
                    ],
                  const SizedBox(height: 16),

                  // ── Info & bantuan ──
                  const SectionHeader(title: 'Info & Bantuan', subtitle: 'Panduan, pengumuman, dan pengaduan'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                    children: [
                      MenuImageCard(
                        title: 'Panduan Kompos',
                        subtitle: 'Cara membuat kompos yang diterima',
                        icon: Icons.menu_book_rounded,
                        imagePath: AppAssets.menuPanduan,
                        accent: AppColors.primary,
                        badge: 'PENTING',
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideScreen())),
                      ),
                      MenuImageCard(
                        title: 'Pengumuman',
                        subtitle: '${announcements.length} info dari desa',
                        icon: Icons.campaign_rounded,
                        imagePath: AppAssets.menuPengumuman,
                        accent: AppColors.goldDark,
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                      ),
                      MenuImageCard(
                        title: 'Pengaduan',
                        subtitle: 'Sampaikan keluhan & saran',
                        icon: Icons.support_agent_rounded,
                        imagePath: AppAssets.menuPengaduan,
                        accent: AppColors.soil,
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComplaintListScreen())),
                      ),
                      MenuImageCard(
                        title: 'Hubungi Desa',
                        subtitle: 'Telepon / WhatsApp Admin',
                        icon: Icons.call_rounded,
                        imagePath: AppAssets.menuBantuan,
                        accent: AppColors.primaryDark,
                        onTap: () => ContactService.whatsapp(app.settings.adminPhone,
                            message: 'Halo Admin Desa, saya ${u.name} warga Banjar ${u.banjar}.'),
                      ),
                    ],
                  ),

                  // ── Pengumuman terbaru ──
                  if (announcements.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: 'Kabar desa',
                      actionLabel: 'Semua',
                      onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                    ),
                    AnnouncementCard(announcement: announcements.first),
                  ],
                  const SizedBox(height: 28),

                  HelpBanner(
                    title: 'Butuh bantuan?',
                    subtitle: 'Admin Desa siap membantu lewat WhatsApp.',
                    buttonLabel: 'Chat Admin',
                    onTap: () => ContactService.whatsapp(app.settings.adminPhone,
                        message: 'Halo Admin Desa, saya ${u.name} butuh bantuan soal Kompos Baha.'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tarif saat ini: ${app.settings.pointsPerKg} poin/kg · Bonus ${app.settings.bonusPoints} poin untuk setoran ≥ ${Fmt.kg(app.settings.bonusMinKg)} kg',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
