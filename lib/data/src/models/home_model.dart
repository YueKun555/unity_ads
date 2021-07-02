import '../models/models.dart';

class HomeModel {
  final List<SportType> sportTypes = [
    SportTypeOutdoorRunning(),
    SportTypeCycling(),
    SportTypeWalk(),
    SportTypeclimbing(),
  ];

  bool isShowMoney;

  final double distance;

  final double kcal;

  HomeModel({
    this.isShowMoney,
    this.distance,
    this.kcal,
  });

  static HomeModel formJson({Map<String, dynamic> json}) {
    return HomeModel(
      isShowMoney: json['isShowMoney'],
      distance: double.parse(json['distance'].toString()),
      kcal: double.parse(json['kcal'].toString()),
    );
  }

  String get distanceString {
    return this.distance != null
        ? (this.distance / 1000).toStringAsFixed(2)
        : "--";
  }

  String get kcalString {
    return this.kcal != null ? this.kcal.toStringAsFixed(1) : "--";
  }
}
