import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'sport_type.dart';
import 'location_model.dart';

class SportModel {
  /// 运动类型
  final SportType sportType;

  final int startDate;

  final int duration;

  final double distance;

  final double kcal;

  /// 位置
  List<LocationModel> locations = [];

  SportModel({
    this.sportType,
    this.startDate,
    this.duration,
    this.distance,
    this.kcal,
    this.locations,
  });

  static SportModel formJson({Map<String, dynamic> json}) {
    List<LocationModel> list = [];
    var unzipString = unzip(json['locations']);
    var locations = jsonDecode(unzipString);
    for (var obj in locations) {
      var model = LocationModel.formJson(json: obj);
      list.add(model);
    }
    return SportModel(
      sportType: _sportType(data: json['sportType']),
      startDate: DateTime.parse(json['startDate']).millisecondsSinceEpoch,
      duration: json['duration'],
      distance: json['distance'],
      kcal: json['kcal'],
      locations: list,
    );
  }

  static SportType _sportType({String data}) {
    return SportTypeOutdoorRunning();
  }

  String get startTimeString {
    var time = DateTime.fromMillisecondsSinceEpoch(this.startDate).toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
    return formattedDate;
  }

  String get distanceString {
    return (this.distance / 1000).toStringAsFixed(2);
  }

  String get spceString {
    int pace = this.duration ~/ (this.distance / 1000);
    var mintes = (pace ~/ 60).toString();
    var second = (pace % 60).toString().padLeft(2, "0");
    var paceString = "$mintes'$second''";
    return paceString;
  }

  String get durationString {
    var hour = (this.duration ~/ 3600).toString().padLeft(2, "0");
    var mintes = (this.duration % 3600 ~/ 60).toString().padLeft(2, "0");
    var second = (this.duration % 60).toString().padLeft(2, "0");
    var durantion = "$hour:$mintes:$second";
    return durantion;
  }

  String get kcalString {
    return this.kcal.toStringAsFixed(1);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sportType'] = this.sportType.name;
    json['startDate'] = DateTime.fromMillisecondsSinceEpoch(this.startDate)
        .toUtc()
        .toIso8601String();
    json['duration'] = this.duration;
    json['distance'] = this.distance;
    json['kcal'] = this.kcal;
    var locationsList = this.locations.map((e) => e.toJson()).toList();
    var jsonString = jsonEncode(locationsList);
    var encodeString = encodeBase64(jsonString);
    json['locations'] = encodeString;
    return json;
  }

  /*
  * Base64加密
  */
  String encodeBase64(String data) {
    var zipString = zip(data);
    return zipString;
  }

  String zip(String data) {
    var content = gzip.encode(data.codeUnits);
    return String.fromCharCodes(content);
  }

  static String unzip(String data) {
    var content = gzip.decode(data.codeUnits);
    return utf8.decode(content);
  }

  /*
  * Base64解密
  */
  String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }
}
