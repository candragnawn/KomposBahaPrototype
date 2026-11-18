import 'package:flutter_test/flutter_test.dart';
import 'package:kompos_baha/core/utils/formatters.dart';
import 'package:kompos_baha/data/models/order_model.dart';
import 'package:kompos_baha/data/models/reward_model.dart';
import 'package:kompos_baha/data/models/user_model.dart';
import 'package:kompos_baha/data/seed/seed_data.dart';
import 'package:kompos_baha/data/services/database_service.dart';
import 'package:kompos_baha/presentation/providers/app_provider.dart';

Future<AppProvider> _fresh([MemoryDatabaseService? db]) async {
  final app = AppProvider(database: db ?? MemoryDatabaseService());
  await app.init();
  return app;
}

void main() {
  test('Format angka & berat Indonesia', () {
    expect(Fmt.number(12840), '12.840');
    expect(Fmt.number(1000), '1.000');
    expect(Fmt.kg(12.5), '12,5');
    expect(Fmt.kg(8), '8');
    expect(Fmt.parseKg('11,5'), 11.5);
    expect(Fmt.initials('I Wayan Sudarta'), 'WS');
  });

  test('Akun bawaan tersedia & login dengan PIN', () async {
    final app = await _fresh();
    expect(await app.login(DefaultAccounts.adminPhone, '000000'), isNotNull);
    expect(await app.login(DefaultAccounts.adminPhone, DefaultAccounts.pin), isNull);
    expect(app.currentUser?.role, UserRole.admin);
    await app.logout();
    expect(app.currentUser, isNull);
  });

  test('Alur lengkap: setor → tugaskan → jemput → antar → timbang → poin → tukar', () async {
    final db = MemoryDatabaseService();
    final app = await _fresh(db);

    // 1. Warga daftar
    expect(
      await app.register(name: 'Ni Made Tes', phone: '0812 9999 0001', pin: '112233', banjar: 'Baha Kelod', address: 'Jl. Tes 1'),
      isNull,
    );
    final warga = app.currentUser!;
    expect(warga.role, UserRole.warga);

    // 2. Warga setor kompos
    final date = app.availablePickupDates().first;
    final created = app.createOrder(
      estimatedKg: 16,
      pickupDate: date,
      timeSlot: app.settings.timeSlots.first,
      address: 'Jl. Tes 1',
      notes: 'Di depan rumah',
      photoPath: '/tmp/foto.jpg',
    );
    expect(created.isOk, isTrue, reason: created.error);
    final orderId = created.data!.id;
    expect(app.orderById(orderId)!.status, OrderStatus.menunggu);

    // Tanpa foto → ditolak validasi
    expect(
      app.createOrder(estimatedKg: 5, pickupDate: date, timeSlot: '08.00 - 10.00', address: 'x', notes: '', photoPath: null).isOk,
      isFalse,
    );

    // 3. TPS menugaskan driver
    await app.logout();
    expect(await app.login(DefaultAccounts.tpsPhone, DefaultAccounts.pin), isNull);
    final driver = app.activeDrivers.first;
    expect(app.assignDriver(orderId, driver.id), isNull);
    expect(app.orderById(orderId)!.status, OrderStatus.ditugaskan);

    // 4. Driver menjemput & mengantar
    await app.logout();
    expect(await app.login(driver.phone, DefaultAccounts.pin), isNull);
    expect(app.confirmDelivered(orderId), isNotNull); // belum boleh
    expect(app.startPickup(orderId), isNull);
    expect(app.confirmCollected(orderId, null), isNotNull); // foto wajib
    expect(app.confirmCollected(orderId, '/tmp/ambil.jpg'), isNull);
    expect(app.confirmDelivered(orderId), isNull);
    expect(app.orderById(orderId)!.status, OrderStatus.diantar);

    // 5. TPS menimbang: 16 kg kualitas Baik → 160 + bonus 20
    await app.logout();
    expect(await app.login(DefaultAccounts.tpsPhone, DefaultAccounts.pin), isNull);
    expect(
      app.verifyOrder(orderId: orderId, officialKg: 16, quality: CompostQuality.baik, checklist: const ['Sudah matang']),
      isNull,
    );
    final done = app.orderById(orderId)!;
    expect(done.status, OrderStatus.selesai);
    expect(done.totalPoints, 180);
    expect(app.userById(warga.id)!.points, 180);
    expect(app.ledgerOf(warga.id).first.delta, 180);

    // 6. Warga menukar hadiah
    await app.logout();
    expect(await app.login('081299990001', '112233'), isNull);
    final reward = app.activeRewards.firstWhere((r) => r.price <= 180);
    final stockBefore = reward.stock;
    final red = app.redeem(reward.id);
    expect(red.isOk, isTrue, reason: red.error);
    expect(app.currentUser!.points, 180 - reward.price);
    expect(app.rewardById(reward.id)!.stock, stockBefore - 1);

    // 7. Admin menyerahkan hadiah
    await app.logout();
    expect(await app.login(DefaultAccounts.adminPhone, DefaultAccounts.pin), isNull);
    final found = app.findRedemptionByCode(red.data!.code.toLowerCase());
    expect(found, isNotNull);
    expect(app.completeRedemption(found!.id), isNull);
    expect(app.redemptions.firstWhere((r) => r.id == found.id).status, RedemptionStatus.diambil);

    // 8. Data tersimpan & bisa dimuat ulang
    await app.flush();
    final reloaded = await _fresh(db);
    expect(reloaded.orderById(orderId)!.status, OrderStatus.selesai);
    expect(reloaded.userById(warga.id)!.points, 180 - reward.price);
  });

  test('Kuota harian membatasi setoran', () async {
    final app = await _fresh();
    await app.login(DefaultAccounts.adminPhone, DefaultAccounts.pin);
    expect(app.updateSettings(app.settings.copyWith(dailyQuotaKg: 10)), isNull);
    await app.logout();
    await app.register(name: 'Warga Kuota', phone: '081277770000', pin: '123123', banjar: 'Baha Kaja', address: 'Jl. A');
    final date = app.availablePickupDates().first;
    final r = app.createOrder(
      estimatedKg: 12,
      pickupDate: date,
      timeSlot: app.settings.timeSlots.first,
      address: 'Jl. A',
      notes: '',
      photoPath: '/tmp/a.jpg',
    );
    expect(r.isOk, isFalse);
  });

  test('Batal tukar mengembalikan poin & stok', () async {
    final app = await _fresh();
    await app.login(DefaultAccounts.adminPhone, DefaultAccounts.pin);
    expect(app.loadDemoData(), greaterThan(0));
    final demo = app.userByPhone(DefaultAccounts.demoWargaPhone)!;
    expect(app.adjustPoints(demo.id, 500, 'Bonus tes'), isNull);
    await app.logout();
    expect(await app.login(DefaultAccounts.demoWargaPhone, DefaultAccounts.pin), isNull);
    final before = app.currentUser!.points;
    final reward = app.activeRewards.firstWhere((r) => r.price <= before && r.stock > 0);
    final red = app.redeem(reward.id).data!;
    expect(app.currentUser!.points, before - reward.price);
    expect(app.cancelRedemption(red.id), isNull);
    expect(app.currentUser!.points, before);
  });
}
