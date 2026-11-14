class PickupOrder {
  final String code;
  final String residentName;
  final String banjar;
  final String address;
  final String? driverName;
  final String estimatedWeight;
  final String? officialWeight;
  final String? quality;
  final String status;
  final String date;
  final String timeSlot;
  final String? notes;
  final bool photoResident;
  final bool photoPickup;
  final bool photoProof;
  final int? pointsEarned;
  final String? rejectionReason;
  final String? failureReason;

  const PickupOrder({
    required this.code,
    required this.residentName,
    required this.banjar,
    required this.address,
    this.driverName,
    required this.estimatedWeight,
    this.officialWeight,
    this.quality,
    required this.status,
    required this.date,
    required this.timeSlot,
    this.notes,
    this.photoResident = false,
    this.photoPickup = false,
    this.photoProof = false,
    this.pointsEarned,
    this.rejectionReason,
    this.failureReason,
  });

  PickupOrder copyWith({
    String? code,
    String? residentName,
    String? banjar,
    String? address,
    String? driverName,
    String? estimatedWeight,
    String? officialWeight,
    String? quality,
    String? status,
    String? date,
    String? timeSlot,
    String? notes,
    bool? photoResident,
    bool? photoPickup,
    bool? photoProof,
    int? pointsEarned,
    String? rejectionReason,
    String? failureReason,
  }) {
    return PickupOrder(
      code: code ?? this.code,
      residentName: residentName ?? this.residentName,
      banjar: banjar ?? this.banjar,
      address: address ?? this.address,
      driverName: driverName ?? this.driverName,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      officialWeight: officialWeight ?? this.officialWeight,
      quality: quality ?? this.quality,
      status: status ?? this.status,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      notes: notes ?? this.notes,
      photoResident: photoResident ?? this.photoResident,
      photoPickup: photoPickup ?? this.photoPickup,
      photoProof: photoProof ?? this.photoProof,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}

