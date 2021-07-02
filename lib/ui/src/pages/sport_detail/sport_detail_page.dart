import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../data/data.dart';
import '../../../../generated/l10n.dart';

class SportDetailPage extends StatefulWidget {
  final SportModel model;

  SportDetailPage({
    this.model,
  });

  @override
  _SportDetailPageState createState() => _SportDetailPageState();
}

class _SportDetailPageState extends State<SportDetailPage> {
  GlobalKey rootWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.sportType.localName(context: context)),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.share),
        //     onPressed: _shareClick,
        //   ),
        // ],
      ),
      body: RepaintBoundary(
        key: rootWidgetKey,
        child: ListView(
          children: [
            _MapRow(
              model: widget.model,
            ),
            _DataRow(
              model: widget.model,
            ),
            _SpeedRow(
              model: widget.model,
            ),
            _AccuracyRow(
              model: widget.model,
            )
          ],
        ),
      ),
    );
  }

  // void _shareClick() async {
  //   // RenderRepaintBoundary boundary =
  //   //     rootWidgetKey.currentContext.findRenderObject();
  //   // var image = await boundary.toImage(pixelRatio: 3.0);
  //   // ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  //   // Uint8List pngBytes = byteData.buffer.asUint8List();
  //   // var file = await _localFile;
  //   // await _writeFile(file, pngBytes);
  //   // Share.shareFiles([file.path], text: widget.model.sportType.localName);
  // }

// // 找到正确的本地路径
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

// // 创建对文件位置的引用
//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return new File('$path/share.png');
//   }

// // 将数据写入文件
//   Future<File> _writeFile(File file, Uint8List bytes) async {
//     // Write the file
//     return file.writeAsBytes(bytes);
//   }
}

class _MapRow extends StatefulWidget {
  final SportModel model;

  _MapRow({
    this.model,
  });

  @override
  __MapRowState createState() => __MapRowState();
}

class __MapRowState extends State<_MapRow> {
  Set<Marker> _markers;

  Set<Polyline> _polylines;

  LatLngBounds _bounds;
  @override
  void initState() {
    super.initState();
    _markers = {
      Marker(
        position: LatLng(
          widget.model.locations.first.latitude,
          widget.model.locations.first.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindowEnable: false,
      ),
      Marker(
        position: LatLng(
          widget.model.locations.last.latitude,
          widget.model.locations.last.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindowEnable: false,
      ),
    };
    _polylines = {
      Polyline(
        width: 5.0,
        color: Colors.green,
        points: widget.model.locations.map(
          (e) {
            return LatLng(
              e.latitude,
              e.longitude,
            );
          },
        ).toList(),
        capType: CapType.round,
      ),
    };

    var minLatitude = widget.model.locations.first.latitude;
    var minLongitude = widget.model.locations.first.longitude;
    var maxLatitude = widget.model.locations.last.latitude;
    var maxLongitude = widget.model.locations.last.longitude;
    widget.model.locations.forEach((element) {
      if (element.latitude < minLatitude) {
        minLatitude = element.latitude;
      }
      if (element.longitude < minLongitude) {
        minLongitude = element.longitude;
      }
      if (element.latitude > maxLatitude) {
        maxLatitude = element.latitude;
      }
      if (element.longitude > maxLongitude) {
        maxLongitude = element.longitude;
      }
    });
    _bounds = LatLngBounds(
      southwest: LatLng(
        minLatitude - 0.01,
        minLongitude - 0.01,
      ),
      northeast: LatLng(
        maxLatitude + 0.01,
        maxLongitude + 0.01,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: AMapWidget(
        limitBounds: _bounds,
        onMapCreated: (controller) {},
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final SportModel model;

  _DataRow({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30.0,
        left: 15.0,
        right: 15.0,
        bottom: 15.0,
      ),
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Column(
        children: [
          Text(model.startTimeString),
          SizedBox(
            height: 20.0,
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  model.distanceString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  S.of(context).km,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80.0,
                child: Column(
                  children: [
                    Text(
                      model.spceString,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      S.of(context).pace,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      model.durationString,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      S.of(context).duration,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80.0,
                child: Column(
                  children: [
                    Text(
                      model.kcalString,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      S.of(context).cal,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

class _SpeedRow extends StatelessWidget {
  final SportModel model;

  _SpeedRow({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Text(
            S.of(context).pace,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 30.0,
                  right: 40.0,
                ),
                height: 300.0,
                child: LineChart(
                  _chartData(),
                ),
              ),
              Positioned(
                left: 0.0,
                child: Text(
                  S.of(context).km,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned(
                right: 0.0,
                bottom: 17.0,
                child: Text(
                  S.of(context).mintes,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _chartData() {
    List<FlSpot> spots = [];

    var maxY = 0.0;
    for (var i = 0; i < model.locations.length; i++) {
      var location = model.locations[i];
      var x = ((location.timestamp - model.locations.first.timestamp) ~/ 1000)
              .toDouble() /
          60.0;
      var y = double.parse((1000 ~/ location.speed / 60).toStringAsFixed(1));
      spots.add(
        FlSpot(
          x,
          y,
        ),
      );
      if (y > maxY) {
        maxY = y;
      }
    }

    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          colors: [
            Colors.green,
          ],
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
      maxY: maxY + 1,
      minY: 0.0,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if (value.toInt() % 4 == 0) {
              return "${value.toInt()}";
            } else {
              return "";
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if (value.toInt() % 4 == 0) {
              return "${value.toInt()}";
            } else {
              return "";
            }
          },
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData:
            LineTouchTooltipData(tooltipBgColor: Colors.transparent),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFCCCCCC),
          ),
          left: BorderSide(
            color: Color(0xFFCCCCCC),
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _AccuracyRow extends StatelessWidget {
  /// SportModel
  final SportModel model;

  /// 构造函数
  _AccuracyRow({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            S.of(context).accuracy,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 30.0,
                  right: 40.0,
                ),
                height: 300.0,
                child: LineChart(
                  _chartData(),
                ),
              ),
              Positioned(
                left: 20.0,
                child: Text(
                  S.of(context).metres,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned(
                right: 0.0,
                bottom: 17.0,
                child: Text(
                  S.of(context).mintes,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _chartData() {
    List<FlSpot> spots = [];

    for (var i = 0; i < model.locations.length; i++) {
      var location = model.locations[i];
      var x =
          ((location.timestamp - model.startDate) ~/ 1000).toDouble() / 60.0;
      spots.add(
        FlSpot(
          x,
          location.altitude,
        ),
      );
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0,
          );
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          colors: const [
            Colors.green,
          ],
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors: [
              Colors.green,
            ],
          ),
        ),
      ],
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          // margin: 10,
          getTitles: (value) {
            if (value.toInt() % 4 == 0) {
              return "${value.toInt()}";
            } else {
              return "";
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          // margin: 10,
          getTitles: (value) {
            if (value.toInt() % 4 == 0) {
              return "${value.toInt()}";
            } else {
              return "";
            }
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFCCCCCC),
          ),
          left: BorderSide(
            color: Color(0xFFCCCCCC),
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
