enum OfferStage {
  none,
  waiting,
  assigned,
  pickup,
  collected,
  delivered,
  verified,
}

extension OfferStageExtension on OfferStage {
  String get displayStatus {
    switch (this) {
      case OfferStage.none:
        return '';
      case OfferStage.waiting:
        return 'Menunggu konfirmasi';
      case OfferStage.assigned:
        return 'Driver ditugaskan';
      case OfferStage.pickup:
      case OfferStage.collected:
        return 'Dalam penjemputan';
      case OfferStage.delivered:
        return 'Diterima TPS 3R';
      case OfferStage.verified:
        return 'Poin diberikan';
    }
  }

  int get stepIndex {
    switch (this) {
      case OfferStage.none:
      case OfferStage.waiting:
        return 0;
      case OfferStage.assigned:
        return 1;
      case OfferStage.pickup:
      case OfferStage.collected:
        return 2;
      case OfferStage.delivered:
        return 3;
      case OfferStage.verified:
        return 4;
    }
  }
}

