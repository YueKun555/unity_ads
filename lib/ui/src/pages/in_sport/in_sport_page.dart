import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../data/data.dart';
import '../../../../data/src/managers/managers.dart';
import '../pages.dart';
import '../../../../generated/l10n.dart';

class InSportPage extends StatefulWidget {
  final SportType sportType;

  InSportPage({
    @required this.sportType,
  });

  @override
  _InSportPageState createState() => _InSportPageState();
}

class _InSportPageState extends State<InSportPage> {
  bool _isShow = false;

  int _countDown = 3;

  String _countDownString = "3";

  Timer _timer;

  SportManager _sportManager = SportManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 300), _ready);
    });
  }

  void _ready() {
    _sportManager.sportType = widget.sportType;
    _sportManager.weight = double.parse(DataRepository.user.weight);
    _startCountDown();
  }

  void _startCountDown() {
    _sportManager.prepare();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _countDown--;
      if (_countDown < 0) {
        _timer.cancel();
        _sportManager.startSport();
        setState(() {
          _isShow = true;
        });
      } else if (_countDown == 0) {
        setState(() {
          _countDownString = "Go";
        });
      } else {
        setState(() {
          _countDownString = "$_countDown";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: _isShow
              ? AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(widget.sportType.localName(context: context)),
                )
              : null,
          body: _isShow
              ? _Body(
                  manager: _sportManager,
                )
              : _CountDownWidget(
                  title: _countDownString,
                ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}

class _CountDownWidget extends StatelessWidget {
  final String title;

  _CountDownWidget({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).primaryColor,
      child: Text(
        '$title',
        style: TextStyle(
          color: Colors.white,
          fontSize: 150.0,
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final SportManager manager;

  _Body({
    this.manager,
  });

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  bool _isUpload = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: _DataRow(
                distanceStream: widget.manager.distanceStream,
                paceStream: widget.manager.paceStream,
                durationStream: widget.manager.durationStream,
                kcalStream: widget.manager.kcalStream,
              ),
            ),
            _MapRow(),
            _ControlRow(
              isUpload: _isUpload,
              stateStream: widget.manager.stateStream,
              pauseCallback: () {
                widget.manager.pauseSport();
              },
              continueCallback: () {
                widget.manager.continueSport();
              },
              stopCallback: () {
                _stopClick(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _stopClick({
    BuildContext context,
  }) {
    if (widget.manager.sportModel.distance > 100) {
      widget.manager.stopSport();
      _uploadSportData(
        model: widget.manager.sportModel,
      );
    } else {
      _showAlert();
    }
  }

  void _uploadSportData({
    SportModel model,
  }) async {
    try {
      setState(() {
        _isUpload = true;
      });
      await DataRepository.uploadSportData(model: model);
      _toDetailPage(context: context, model: model);
    } catch (e) {
      _showMessage(message: "数据保存失败，请重试！");
    } finally {
      setState(() {
        _isUpload = false;
      });
    }
  }

  void _showMessage({
    String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text('运动距离太短，无法保存数据'),
          actions: [
            CupertinoDialogAction(
              child: Text('退出运动'),
              onPressed: () {
                widget.manager.stopSport();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('继续运动'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _toDetailPage({
    BuildContext context,
    SportModel model,
  }) {
    final route = MaterialPageRoute(builder: (context) {
      return SportDetailPage(
        model: model,
      );
    });
    Navigator.of(context).pushReplacement(route);
  }
}

class _DataRow extends StatelessWidget {
  final Stream<String> distanceStream;
  final Stream<String> paceStream;
  final Stream<String> durationStream;
  final Stream<String> kcalStream;

  _DataRow({
    this.distanceStream,
    this.paceStream,
    this.durationStream,
    this.kcalStream,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
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
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<String>(
                    stream: distanceStream,
                    initialData: "0.00",
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return Text(
                        snapshot.data ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      );
                    },
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
          ),
          Divider(),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80.0,
                child: Column(
                  children: [
                    StreamBuilder<String>(
                      stream: paceStream,
                      initialData: "--",
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return Text(
                          snapshot.data ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        );
                      },
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
                    StreamBuilder<String>(
                      stream: durationStream,
                      initialData: "00:00:00",
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return Text(
                          snapshot.data ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        );
                      },
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
                    StreamBuilder<String>(
                      stream: kcalStream,
                      initialData: "0.00",
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return Text(
                          snapshot.data ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        );
                      },
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

class _MapRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
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
      child: InkWell(
        onTap: () {
          _toMapPage(context: context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.green,
              size: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  void _toMapPage({
    BuildContext context,
  }) {
    final route = MaterialPageRoute(builder: (context) {
      return MapPage();
    });
    Navigator.of(context).push(route);
  }
}

class _ControlRow extends StatelessWidget {
  final bool isUpload;
  final Stream<bool> stateStream;

  final VoidCallback pauseCallback;
  final VoidCallback continueCallback;
  final VoidCallback stopCallback;

  _ControlRow({
    this.isUpload,
    this.stateStream,
    this.pauseCallback,
    this.continueCallback,
    this.stopCallback,
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
      child: isUpload
          ? _upload()
          : StreamBuilder<bool>(
              stream: stateStream,
              initialData: true,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _children(
                    context: context,
                    isInSport: snapshot.data ?? false,
                  ),
                );
              },
            ),
    );
  }

  Widget _upload() {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          CupertinoActivityIndicator(),
          SizedBox(
            height: 10.0,
          ),
          Text('正在保存数据...'),
        ],
      ),
    );
  }

  List<Widget> _children({
    BuildContext context,
    bool isInSport,
  }) {
    List<Widget> widgets = [];
    if (!isInSport) {
      widgets.add(
        InkWell(
          onTap: () {
            continueCallback();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              color: Theme.of(context).primaryColor,
            ),
            width: 80.0,
            height: 80.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  '继续',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      );
      widgets.add(
        InkWell(
          onTap: () {
            stopCallback();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              color: Colors.red,
            ),
            width: 80.0,
            height: 80.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  '停止',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      widgets.add(
        InkWell(
          onTap: () {
            pauseCallback();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              color: Color(0xFFFFDC00),
            ),
            width: 80.0,
            height: 80.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  '暂停',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}
