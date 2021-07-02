import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

abstract class SportType {
  final String name;

  const SportType({
    this.name,
  });

  String localName({
    BuildContext context,
  }) {
    if (this is SportTypeOutdoorRunning) {
      return S.of(context).Running;
    } else if (this is SportTypeCycling) {
      return S.of(context).Cycling;
    } else if (this is SportTypeWalk) {
      return S.of(context).Walk;
    } else if (this is SportTypeclimbing) {
      return S.of(context).Climb;
    }
    return "";
  }

  IconData get iconCodePoint {
    if (this is SportTypeOutdoorRunning) {
      return Icons.directions_run_outlined;
    } else if (this is SportTypeCycling) {
      return Icons.directions_bike_rounded;
    } else if (this is SportTypeWalk) {
      return Icons.directions_walk_outlined;
    } else if (this is SportTypeclimbing) {
      return Icons.filter_hdr_outlined;
    }
    return null;
  }
}

class SportTypeOutdoorRunning extends SportType {
  const SportTypeOutdoorRunning() : super(name: "outdoorRunning");
}

class SportTypeCycling extends SportType {
  const SportTypeCycling() : super(name: "cycling");
}

class SportTypeWalk extends SportType {
  const SportTypeWalk() : super(name: "walk");
}

class SportTypeclimbing extends SportType {
  const SportTypeclimbing() : super(name: "climbing");
}
