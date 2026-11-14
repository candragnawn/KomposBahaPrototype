import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompostBinIllustration extends StatelessWidget {
  final double width;
  final double height;

  const CompostBinIllustration({super.key, this.width = 160, this.height = 132});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/illustrations/compost_bin.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class PickupTruckIllustration extends StatelessWidget {
  final double width;
  final double height;

  const PickupTruckIllustration({super.key, this.width = 180, this.height = 112});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/illustrations/pickup_truck.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class GiftBoxIllustration extends StatelessWidget {
  final double width;
  final double height;

  const GiftBoxIllustration({super.key, this.width = 140, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/illustrations/gift_box.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class LedgerCoinIllustration extends StatelessWidget {
  final double width;
  final double height;

  const LedgerCoinIllustration({super.key, this.width = 140, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/illustrations/ledger_coin.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

