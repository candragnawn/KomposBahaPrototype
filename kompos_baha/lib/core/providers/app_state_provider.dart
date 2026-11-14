import 'package:flutter_riverpod/legacy.dart';
import '../models/role.dart';
import '../models/offer_stage.dart';
import '../models/pickup_order.dart';
import '../models/reward_item.dart';
import '../models/common_models.dart';

class AppState {
  final UserRole? role;
  final bool wargaLoggedIn;
  final OfferStage stage;
  final int points;
  final List<PickupOrder> orders;
  final List<RewardItem> rewards;
  final List<LedgerItem> ledger;
  final List<UserItem> users;
  final List<ComplaintItem> complaints;

  const AppState({
    this.role,
    this.wargaLoggedIn = false,
    this.stage = OfferStage.none,
    this.points = 1240,
    this.orders = const [],
    this.rewards = const [],
    this.ledger = const [],
    this.users = const [],
    this.complaints = const [],
  });

  AppState copyWith({
    UserRole? role,
    bool clearRole = false,
    bool? wargaLoggedIn,
    OfferStage? stage,
    int? points,
    List<PickupOrder>? orders,
    List<RewardItem>? rewards,
    List<LedgerItem>? ledger,
    List<UserItem>? users,
    List<ComplaintItem>? complaints,
  }) {
    return AppState(
      role: clearRole ? null : (role ?? this.role),
      wargaLoggedIn: wargaLoggedIn ?? this.wargaLoggedIn,
      stage: stage ?? this.stage,
      points: points ?? this.points,
      orders: orders ?? this.orders,
      rewards: rewards ?? this.rewards,
      ledger: ledger ?? this.ledger,
      users: users ?? this.users,
      complaints: complaints ?? this.complaints,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier()
      : super(
          AppState(
            orders: _initialOrders,
            rewards: _initialRewards,
            ledger: _initialLedger,
            users: _initialUsers,
            complaints: _initialComplaints,
          ),
        );

  static const List<PickupOrder> _initialOrders = [
    PickupOrder(
      code: 'KB-0412',
      residentName: 'Ni Luh Ayu Wulandari',
      banjar: 'Baha Kelod',
      address: 'Jl. Baha No. 7, Banjar Baha Kelod',
      driverName: 'Kadek Dwi Arta',
      estimatedWeight: '12',
      officialWeight: '11,5',
      quality: 'Baik',
      status: 'Driver ditugaskan',
      date: '18 Okt 2026',
      timeSlot: '08.00–10.00',
      notes: 'Kompos disimpan di karung putih dekat pintu samping.',
      photoResident: true,
    ),
    PickupOrder(
      code: 'KB-0415',
      residentName: 'Ni Kadek Sari',
      banjar: 'Baha Kaja',
      address: 'Jl. Baha Kaja No. 22',
      estimatedWeight: '15',
      status: 'Menunggu konfirmasi',
      date: '18 Okt 2026',
      timeSlot: '10.00–12.00',
    ),
    PickupOrder(
      code: 'KB-0409',
      residentName: 'I Wayan Sudarta',
      banjar: 'Baha Kelod',
      address: 'Jl. Baha No. 18, Banjar Baha Kelod',
      driverName: 'Kadek Dwi Arta',
      estimatedWeight: '8',
      officialWeight: '8,2',
      quality: 'Baik',
      status: 'Poin diberikan',
      date: '14 Okt 2026',
      timeSlot: '08.00–10.00',
      pointsEarned: 82,
    ),
    PickupOrder(
      code: 'KB-0405',
      residentName: 'I Made Sukarta',
      banjar: 'Baha Tengah',
      address: 'Gg. Melati No. 3',
      driverName: 'I Ketut Budi',
      estimatedWeight: '10',
      status: 'Ditolak TPS',
      date: '9 Okt 2026',
      timeSlot: '10.00–12.00',
      rejectionReason: 'Tercampur sampah plastik',
    ),
    PickupOrder(
      code: 'KB-0401',
      residentName: 'Putu Eka Pramana',
      banjar: 'Baha Kelod',
      address: 'Jl. Baha No. 12',
      driverName: 'Kadek Dwi Arta',
      estimatedWeight: '9',
      status: 'Gagal jemput',
      date: '2 Okt 2026',
      timeSlot: '08.00–10.00',
      failureReason: 'Warga tidak di tempat',
    ),
  ];

  static const List<RewardItem> _initialRewards = [
    RewardItem(name: 'Bibit cabai', price: 200, stock: 12, tone: 'green'),
    RewardItem(name: 'Polybag 10 pcs', price: 150, stock: 8, tone: 'amber'),
    RewardItem(name: 'Beras 5 kg', price: 600, stock: 5, tone: 'cream'),
    RewardItem(name: 'Kopi Baha 250 g', price: 350, stock: 0, tone: 'coffee', status: 'Nonaktif'),
  ];

  static const List<LedgerItem> _initialLedger = [
    LedgerItem(date: '14 Okt', description: 'Setoran KB-0409', points: '+82', balanceAfter: '1.240'),
    LedgerItem(date: '10 Okt', description: 'Tukar Bibit cabai', points: '−200', balanceAfter: '1.158'),
    LedgerItem(date: '3 Okt', description: 'Setoran KB-0400', points: '+95', balanceAfter: '1.358'),
  ];

  static const List<UserItem> _initialUsers = [
    UserItem(
      name: 'I Wayan Sudarta',
      role: 'Warga',
      banjar: 'Baha Kelod',
      phone: '0812 3456 7812',
      verificationStatus: 'Poin diberikan',
    ),
    UserItem(
      name: 'Ni Luh Ayu Wulandari',
      role: 'Warga',
      banjar: 'Baha Kaja',
      phone: '0813 7788 1209',
      verificationStatus: 'Menunggu konfirmasi',
    ),
    UserItem(
      name: 'Kadek Dwi Arta',
      role: 'Driver',
      banjar: 'Baha Kelod',
      phone: '0812 8842 1976',
      verificationStatus: 'Poin diberikan',
    ),
    UserItem(
      name: 'Komang Adi Putra',
      role: 'Driver',
      banjar: 'Baha Tengah',
      phone: '0819 4612 8401',
      verificationStatus: 'Poin diberikan',
    ),
  ];

  static const List<ComplaintItem> _initialComplaints = [
    ComplaintItem(
      id: 'PGD-018',
      residentName: 'Ni Luh Ayu Wulandari',
      topic: 'Driver terlambat',
      date: '18 Okt 2026',
      status: 'Menunggu konfirmasi',
      description: 'Penjemputan dijadwalkan pukul 09.00–11.00, tetapi driver belum tiba sampai pukul 12.30.',
    ),
    ComplaintItem(
      id: 'PGD-017',
      residentName: 'I Made Ariasa',
      topic: 'Poin belum masuk',
      date: '17 Okt 2026',
      status: 'Diterima TPS 3R',
      description: 'Kompos sudah disetor kemarin sore tetapi saldo mutasi poin belum bertambah.',
    ),
  ];

  void setRole(UserRole? role) {
    if (role == null) {
      state = state.copyWith(clearRole: true);
    } else {
      state = state.copyWith(role: role);
    }
  }

  void setWargaLoggedIn(bool loggedIn) {
    state = state.copyWith(wargaLoggedIn: loggedIn);
  }

  void setStage(OfferStage stage) {
    state = state.copyWith(stage: stage);
  }

  void setPoints(int points) {
    state = state.copyWith(points: points);
  }

  String addOffer({
    required String estimatedWeight,
    required String address,
    required String timeSlot,
    String? notes,
  }) {
    final code = 'KB-${1000 + (DateTime.now().millisecondsSinceEpoch % 9000)}';
    final newOrder = PickupOrder(
      code: code,
      residentName: 'I Wayan Sudarta',
      banjar: 'Baha Kelod',
      address: address,
      estimatedWeight: estimatedWeight,
      status: 'Menunggu konfirmasi',
      date: 'Hari ini',
      timeSlot: timeSlot,
      notes: notes,
      photoResident: true,
    );

    state = state.copyWith(
      orders: [newOrder, ...state.orders],
      stage: OfferStage.waiting,
    );
    return code;
  }

  bool redeemReward(String rewardName) {
    final index = state.rewards.indexWhere((r) => r.name == rewardName);
    if (index == -1) return false;
    final reward = state.rewards[index];
    if (reward.stock <= 0 || state.points < reward.price) return false;

    final nextPoints = state.points - reward.price;
    final updatedRewards = [...state.rewards];
    updatedRewards[index] = reward.copyWith(stock: reward.stock - 1);

    final nextLedger = [
      LedgerItem(
        date: 'Hari ini',
        description: 'Tukar $rewardName',
        points: '−${reward.price}',
        balanceAfter: nextPoints.toString(),
      ),
      ...state.ledger,
    ];

    state = state.copyWith(
      points: nextPoints,
      rewards: updatedRewards,
      ledger: nextLedger,
    );
    return true;
  }

  void assignDriverToOrder(String code, String driverName) {
    final updatedOrders = state.orders.map((o) {
      if (o.code == code) {
        return o.copyWith(driverName: driverName, status: 'Driver ditugaskan');
      }
      return o;
    }).toList();

    state = state.copyWith(
      orders: updatedOrders,
      stage: code == 'KB-0412' ? OfferStage.assigned : state.stage,
    );
  }

  void verifyOrder(String code, String officialWeight, String quality) {
    final numWeight = double.tryParse(officialWeight.replaceAll(',', '.')) ?? 0;
    final earned = (numWeight * 10).round();
    final nextBal = state.points + earned;

    final updatedOrders = state.orders.map((o) {
      if (o.code == code) {
        return o.copyWith(
          officialWeight: officialWeight,
          quality: quality,
          status: 'Poin diberikan',
          pointsEarned: earned,
          photoProof: true,
        );
      }
      return o;
    }).toList();

    final nextLedger = [
      LedgerItem(
        date: 'Hari ini',
        description: 'Setoran $code',
        points: '+$earned',
        balanceAfter: nextBal.toString(),
      ),
      ...state.ledger,
    ];

    state = state.copyWith(
      orders: updatedOrders,
      points: nextBal,
      ledger: nextLedger,
      stage: code == 'KB-0412' ? OfferStage.verified : state.stage,
    );
  }

  void rejectOrder(String code, String reason) {
    final updatedOrders = state.orders.map((o) {
      if (o.code == code) {
        return o.copyWith(status: 'Ditolak TPS', rejectionReason: reason);
      }
      return o;
    }).toList();
    state = state.copyWith(orders: updatedOrders);
  }

  void failDriverPickup(String code, String reason) {
    final updatedOrders = state.orders.map((o) {
      if (o.code == code) {
        return o.copyWith(status: 'Gagal jemput', failureReason: reason);
      }
      return o;
    }).toList();
    state = state.copyWith(orders: updatedOrders);
  }

  void respondComplaint(String id, String reply) {
    final updated = state.complaints.map((c) {
      if (c.id == id) {
        return c.copyWith(status: 'Diterima TPS 3R', reply: reply);
      }
      return c;
    }).toList();
    state = state.copyWith(complaints: updated);
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

