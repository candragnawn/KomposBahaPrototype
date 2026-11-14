import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kompos_baha/core/models/role.dart';
import 'package:kompos_baha/core/models/offer_stage.dart';
import 'package:kompos_baha/core/providers/app_state_provider.dart';

void main() {
  group('AppStateNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is correct', () {
      final state = container.read(appStateProvider);
      expect(state.role, isNull);
      expect(state.wargaLoggedIn, isFalse);
      expect(state.stage, OfferStage.none);
      expect(state.points, 1240);
      expect(state.orders.isNotEmpty, isTrue);
      expect(state.rewards.isNotEmpty, isTrue);
    });

    test('Set and clear role', () {
      final notifier = container.read(appStateProvider.notifier);
      notifier.setRole(UserRole.warga);
      expect(container.read(appStateProvider).role, UserRole.warga);

      notifier.setRole(null);
      expect(container.read(appStateProvider).role, isNull);
    });

    test('Add offer generates unique code and prepends order', () {
      final notifier = container.read(appStateProvider.notifier);
      final initialCount = container.read(appStateProvider).orders.length;

      final code = notifier.addOffer(
        estimatedWeight: '15',
        address: 'Jl. Melati No. 5',
        timeSlot: '08.00 - 10.00',
        notes: 'Ditaruh di depan gerbang',
      );

      final state = container.read(appStateProvider);
      expect(state.orders.length, initialCount + 1);
      expect(state.orders.first.code, code);
      expect(state.orders.first.estimatedWeight, '15');
      expect(state.stage, OfferStage.waiting);
    });

    test('Redeem reward deducts points and decrements stock', () {
      final notifier = container.read(appStateProvider.notifier);
      final initialPoints = container.read(appStateProvider).points;
      final reward = container.read(appStateProvider).rewards.first;

      final success = notifier.redeemReward(reward.name);
      expect(success, isTrue);

      final state = container.read(appStateProvider);
      expect(state.points, initialPoints - reward.price);
      final updatedReward = state.rewards.firstWhere((r) => r.name == reward.name);
      expect(updatedReward.stock, reward.stock - 1);
      expect(state.ledger.first.description, 'Tukar ${reward.name}');
    });

    test('Assign driver updates order status', () {
      final notifier = container.read(appStateProvider.notifier);
      notifier.assignDriverToOrder('KB-0412', 'Kadek Dwi Arta');

      final order = container.read(appStateProvider).orders.firstWhere((o) => o.code == 'KB-0412');
      expect(order.driverName, 'Kadek Dwi Arta');
      expect(order.status, 'Driver ditugaskan');
      expect(container.read(appStateProvider).stage, OfferStage.assigned);
    });

    test('Verify order credits points and updates status', () {
      final notifier = container.read(appStateProvider.notifier);
      final initialPoints = container.read(appStateProvider).points;

      notifier.verifyOrder('KB-0412', '12', 'Baik');

      final order = container.read(appStateProvider).orders.firstWhere((o) => o.code == 'KB-0412');
      expect(order.status, 'Poin diberikan');
      expect(order.officialWeight, '12');
      expect(order.pointsEarned, 120); // 12 * 10
      expect(container.read(appStateProvider).points, initialPoints + 120);
    });
  });
}
