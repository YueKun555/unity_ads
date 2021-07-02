import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../data/data.dart';
import '../pages.dart';
import '../../../../generated/l10n.dart';

class SportPage extends StatefulWidget {
  final SportType sportType;

  SportPage({
    @required this.sportType,
  });

  @override
  _SportPageState createState() => _SportPageState();
}

class _SportPageState extends State<SportPage> {
  AMapController _mapController;

  bool _isLoad = false;

  @override
  void initState() {
    super.initState();
    Permission.location.request();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 300), () {
        _load();
      });
    });
  }

  void _load() {
    setState(() {
      _isLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sportType.localName(context: context)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _toUserDataPage,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: _isLoad
                        ? AMapWidget(
                            apiKey: AMapApiKey(
                              androidKey: AppConfig.gdApiKey,
                              iosKey: AppConfig.gdApiKey,
                            ),
                            myLocationStyleOptions: MyLocationStyleOptions(
                              true,
                              circleFillColor: Colors.transparent,
                              circleStrokeColor: Colors.transparent,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed),
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            onLocationChanged: (location) {
                              print(location);
                              if (_mapController != null &&
                                  location != null &&
                                  location.latLng != null) {
                                _mapController.moveCamera(
                                    CameraUpdate.newLatLng(location.latLng));
                              }
                            },
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 50,
                    child: InkWell(
                      onTap: () {
                        _startClick();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        width: 100.0,
                        height: 100.0,
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startClick() {
    if (DataRepository.user.weight != null) {
      _check();
    } else {
      _toUserDataPage();
    }
  }

  void _check() async {
    var result = await Permission.location.isGranted;
    if (result) {
      _toInSportPage();
    } else {
      result = await Permission.location.isPermanentlyDenied;
      if (result) {
        _showAlert();
      } else {
        await [
          Permission.location,
        ].request();
        _check();
      }
    }
  }

  void _showAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text('当前定位权限不可用，请打开定位权限'),
          actions: [
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('设置'),
              onPressed: () {
                AppSettings.openLocationSettings();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _toUserDataPage() {
    final route = MaterialPageRoute(builder: (context) {
      return UserDataPage();
    });
    Navigator.of(context).push(route);
  }

  void _toInSportPage() {
    final route = MaterialPageRoute(builder: (context) {
      return InSportPage(
        sportType: widget.sportType,
      );
    });
    Navigator.of(context).pushReplacement(route);
  }

  @override
  void dispose() {
    _mapController?.disponse();
    super.dispose();
  }
}
