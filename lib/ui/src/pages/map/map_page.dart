import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import '../../../../data/data.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  AMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('地图'),
      ),
      body: AMapWidget(
        apiKey: AMapApiKey(
          androidKey: AppConfig.gdApiKey,
          iosKey: AppConfig.gdApiKey,
        ),
        myLocationStyleOptions: MyLocationStyleOptions(
          true,
          circleFillColor: Colors.transparent,
          circleStrokeColor: Colors.transparent,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onLocationChanged: (location) {
          print(location);
          if (_mapController != null &&
              location != null &&
              location.latLng != null) {
            _mapController.moveCamera(CameraUpdate.newLatLng(location.latLng));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.disponse();
    super.dispose();
  }
}
