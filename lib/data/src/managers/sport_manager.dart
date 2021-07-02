import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_tts/flutter_tts.dart';
import '../../data.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:location/location.dart';

enum SportStatus {
  start,
  pause,
}

class SportManager {
  FlutterTts _tts = FlutterTts();

  Location _locationManager = Location();

  StreamSubscription<LocationData> _locationSubscription;

  SportType sportType;

  double weight;

  int _startDate = 0;

  List<LocationModel> _locations = [];

  int _duration = 0;

  Timer _durationTimer;

  BehaviorSubject<String> _durantionBehaviorSubject = BehaviorSubject<String>();

  Stream<String> get durationStream => _durantionBehaviorSubject.stream;

  double _speakDistance = 1.0;

  double _distance = 0.0;

  BehaviorSubject<String> _distanceBehaviorSubject = BehaviorSubject<String>();

  Stream<String> get distanceStream => _distanceBehaviorSubject.stream;

  BehaviorSubject<String> _paceBehaviorSubject = BehaviorSubject<String>();

  Stream<String> get paceStream => _paceBehaviorSubject.stream;

  bool _isInSport = false;

  BehaviorSubject<bool> _stateController = BehaviorSubject<bool>();

  Stream<bool> get stateStream => _stateController.stream;

  double _kcal = 0.0;

  BehaviorSubject<String> _kcalBehaviorSubject = BehaviorSubject<String>();

  Stream<String> get kcalStream => _kcalBehaviorSubject.stream;

  SportManager() {
    _initLocationManager();
  }

  void prepare() async {
    _tts.speak("3");
    _tts.speak("2");
    _tts.speak("1");
    _tts.speak("开始运动");
  }

  void _initLocationManager() {
    _locationManager.enableBackgroundMode(enable: true);
    _locationManager.changeSettings(
      interval: 5,
      distanceFilter: 5.0,
    );
    _locationSubscription = _locationManager.onLocationChanged.listen((event) {
      _onLocationChanged(data: event);
    });
  }

  void startSport() {
    _startDate = DateTime.now().toUtc().millisecondsSinceEpoch;
    _isInSport = true;
    _stateController.add(_isInSport);
    _startDurationTimer();
  }

  void pauseSport() {
    _isInSport = false;
    _stateController.add(_isInSport);
    _tts.speak('运动已暂停！');
    _stopDurationTimer();
    _paceBehaviorSubject.add("--");
  }

  void continueSport() {
    _isInSport = true;
    _stateController.add(_isInSport);
    _tts.speak('继续运动！');
    _startDurationTimer();
  }

  void stopSport() {
    _tts.speak('结束运动！');
    _locationSubscription.cancel();
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _duration++;
      var hour = (_duration ~/ 3600).toString().padLeft(2, "0");
      var mintes = (_duration % 3600 ~/ 60).toString().padLeft(2, "0");
      var second = (_duration % 60).toString().padLeft(2, "0");
      var durantion = "$hour:$mintes:$second";
      _durantionBehaviorSubject.add(durantion);
      _pace();
    });
  }

  void _stopDurationTimer() {
    if (_durationTimer != null) {
      _durationTimer?.cancel();
      _durationTimer = null;
    }
  }

  _onLocationChanged({
    LocationData data,
  }) {
    final location = LocationModel.formLocationData(
      status: _isInSport ? 1 : 0,
      data: data,
    );
    // 过滤精度
    if (location.accuracy < 50.0 && location.speed > 0) {
      _locations.add(location);
      _sum();
    }
  }

  void _sum() {
    if (_isInSport && _locations.length > 1) {
      final pre = _locations[_locations.length - 2];
      final last = _locations.last;
      final distance = AMapTools.distanceBetween(
        LatLng(
          last.latitude,
          last.longitude,
        ),
        LatLng(
          pre.latitude,
          pre.longitude,
        ),
      );
      _distance += distance.abs();
      var distanceString = (_distance / 1000).toStringAsFixed(2);
      _distanceBehaviorSubject.add(distanceString);
      if (_distance / 1000 > _speakDistance) {
        _tts.speak("你已运动$_speakDistance公里");
        _speakDistance += 1;
      }
      _sumCal(last.timestamp - pre.timestamp, last.speed);
    }
  }

  void _pace() {
    if (_distance > 0) {
      int pace = _duration ~/ (_distance / 1000);
      var mintes = (pace ~/ 60).toString();
      var second = (pace % 60).toString().padLeft(2, "0");
      var paceString = "$mintes'$second''";
      _paceBehaviorSubject.add(paceString);
    }
  }

  void _sumCal(
    int duration,
    double speed,
  ) {
    var k = 30 / (400 / speed / 60);
    var kcal = this.weight * duration / 1000 / 3600 * k;
    _kcal += kcal;
    _kcalBehaviorSubject.add(_kcal.toStringAsFixed(1));
  }

  SportModel get sportModel {
    return SportModel(
      sportType: this.sportType,
      startDate: this._startDate,
      duration: this._duration,
      distance: this._distance,
      kcal: this._kcal,
      locations: _locations,
    );
  }
}
