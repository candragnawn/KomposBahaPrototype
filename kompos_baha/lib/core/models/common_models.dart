class LedgerItem {
  final String date;
  final String description;
  final String points;
  final String balanceAfter;

  const LedgerItem({
    required this.date,
    required this.description,
    required this.points,
    required this.balanceAfter,
  });
}

class UserItem {
  final String name;
  final String role;
  final String banjar;
  final String phone;
  final String verificationStatus;

  const UserItem({
    required this.name,
    required this.role,
    required this.banjar,
    required this.phone,
    required this.verificationStatus,
  });
}

class ComplaintItem {
  final String id;
  final String residentName;
  final String topic;
  final String date;
  final String status;
  final String description;
  final String? reply;

  const ComplaintItem({
    required this.id,
    required this.residentName,
    required this.topic,
    required this.date,
    required this.status,
    required this.description,
    this.reply,
  });

  ComplaintItem copyWith({
    String? id,
    String? residentName,
    String? topic,
    String? date,
    String? status,
    String? description,
    String? reply,
  }) {
    return ComplaintItem(
      id: id ?? this.id,
      residentName: residentName ?? this.residentName,
      topic: topic ?? this.topic,
      date: date ?? this.date,
      status: status ?? this.status,
      description: description ?? this.description,
      reply: reply ?? this.reply,
    );
  }
}

