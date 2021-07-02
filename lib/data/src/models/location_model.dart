import 'package:location/location.dart';

class LocationModel {
  final int status;
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final double accuracy;
  final double bearing;
  final int timestamp;

  LocationModel({
    this.status,
    this.latitude,
    this.longitude,
    this.altitude,
    this.speed,
    this.accuracy,
    this.bearing,
    this.timestamp,
  });

  factory LocationModel.formJson({
    Map<String, dynamic> json,
  }) {
    return LocationModel(
      status: json['status'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      speed: json['speed'],
      accuracy: json['accuracy'],
      bearing: json['bearing'],
      timestamp: json['timestamp'],
    );
  }

  factory LocationModel.formLocation({
    int status,
    Map<String, dynamic> location,
  }) {
    return LocationModel(
      status: status,
      latitude: double.parse(location['latitude']),
      longitude: double.parse(location['longitude']),
      altitude: location['altitude'],
      speed: location['speed'],
      accuracy: location['accuracy'],
      bearing: location['bearing'],
      timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
  }

  factory LocationModel.formLocationData({
    int status,
    LocationData data,
  }) {
    return LocationModel(
      status: status,
      latitude: data.latitude,
      longitude: data.longitude,
      altitude: data.altitude,
      speed: data.speed,
      accuracy: data.accuracy,
      bearing: data.heading,
      timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['status'] = this.status;
    json['latitude'] = this.latitude;
    json['longitude'] = this.longitude;
    json['altitude'] = this.altitude;
    json['speed'] = this.speed;
    json['accuracy'] = this.accuracy;
    json['bearing'] = this.bearing;
    json['timestamp'] = this.timestamp;
    return json;
  }
}
