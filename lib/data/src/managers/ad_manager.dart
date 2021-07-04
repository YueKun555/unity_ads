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

  int _adClickCount = 0;

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
    var placements = [
      "05",
      "5",
      "04",
      "4",
      "03",
      "3",
      "02",
      "2",
      "01",
      "1",
      "unity_standard_placement"
    ];
    for (var placementId in placements) {
      var result = await UnityAds.isReady(placementId: placementId);
      if (result) {
        await UnityAds.showVideoAd(placementId: placementId);
        return;
      }
    }
    _adClickCount++;
    initAd();
    if (_adClickCount > 4) {
      exit(0);
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
