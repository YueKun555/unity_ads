import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sports/data/data.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class AdManager {
  bool get isLoading => _isLoading;

  bool _isLoading = false;

  // 工厂模式
  factory AdManager() => _getInstance();

  static AdManager get manager => _getInstance();

  static AdManager _instance;

  VoidCallback onCloseCallback;

  ValueChanged<Error> errorCallback;

  AdManager._internal();

  Timer _exitTimer;

  int _clickCount = 0;

  int _adClickCount = 0;

  List<String> _placements = [];

  static AdManager _getInstance() {
    if (_instance == null) {
      _instance = new AdManager._internal();
    }
    return _instance;
  }

  void initAd() async {
    UnityAds.init(
      gameId: AppConfig.gameId,
      listener: (state, messgae) {
        print("--- $state ---");
        print("--- $messgae ---");
        switch (state) {
          case UnityAdState.ready:
            var placementId = messgae["placementId"].toString();
            if (int.parse(placementId) != null) {
              if (!_placements.contains(placementId)) {
                _placements.add(placementId);
                _placements.sort((a, b) {
                  var inta = int.parse(a);
                  var intb = int.parse(b);
                  return inta > intb ? inta : intb;
                });
                print(_placements);
              }
            }
            break;
          case UnityAdState.error:
            break;
          case UnityAdState.started:
            _startTimer();
            break;
          case UnityAdState.complete:
            _cancelTimer();
            break;
          case UnityAdState.skipped:
            _cancelTimer();
            break;
        }
      },
    );
  }

  void loadAd() async {
    if (_placements.isNotEmpty) {
      await UnityAds.showVideoAd(placementId: _placements.last);
      _placements.removeLast();
    } else {
      _adClickCount++;
      initAd();
      if (_adClickCount > 2) {
        exit(0);
      }
    }
  }

  void _startTimer() {
    _cancelTimer();
    _exitTimer = Timer.periodic(Duration(seconds: 45), (timer) {
      exit(0);
    });
  }

  void _cancelTimer() {
    if (_exitTimer != null) {
      _exitTimer.cancel();
      _exitTimer = null;
    }
  }
}
