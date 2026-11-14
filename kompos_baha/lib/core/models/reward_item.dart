class RewardItem {
  final String name;
  final int price;
  final int stock;
  final String tone;
  final String status;

  const RewardItem({
    required this.name,
    required this.price,
    required this.stock,
    required this.tone,
    this.status = 'Aktif',
  });

  RewardItem copyWith({
    String? name,
    int? price,
    int? stock,
    String? tone,
    String? status,
  }) {
    return RewardItem(
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      tone: tone ?? this.tone,
      status: status ?? this.status,
    );
  }
}

