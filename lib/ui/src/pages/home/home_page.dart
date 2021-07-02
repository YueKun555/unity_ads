import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../data/data.dart';
import '../../../../route_observer.dart';
import '../pages.dart';
import '../../../../generated/l10n.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );

  HomeModel _model = HomeModel(
    isShowMoney: false,
  );

  bool _isAdEnabled = true;

  ///消息订单对象
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    AdManager.manager.initAd();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _refreshController.requestRefresh();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    routeObserver.unsubscribe(this); //取消订阅
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).sport),
        actions: (_model != null && _model.isShowMoney)
            ? [
                IconButton(
                  icon: Icon(Icons.money),
                  onPressed: _toMoneyPage,
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SmartRefresher(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    switch (index) {
                      // case 0:
                      //   return _SportsRow(
                      //     sportTypes: _model.sportTypes,
                      //     tapCallback: (type) {
                      //       _toSportPage(context: context, sportType: type);
                      //     },
                      //   );
                      // case 1:
                      //   return _DataRow(
                      //     distance: _model.distanceString,
                      //     kcal: _model.kcalString,
                      //   );
                      case 0:
                        if (Platform.isIOS) {
                          return Container();
                        }
                        return _AdRow(isEnabled: _isAdEnabled);
                      default:
                        return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRefresh() async {
    try {
      var model = await DataRepository.home();
      setState(() {
        _model = model;
      });
    } catch (e) {
      _showMessage(message: S.of(context).networkFailure);
    } finally {
      _refreshController.refreshCompleted();
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

  void _toMoneyPage() {
    final route = MaterialPageRoute(builder: (context) {
      return MoneyPage();
    });
    Navigator.of(context).push(route);
  }

  void _toSportPage({
    @required BuildContext context,
    @required SportType sportType,
  }) async {
    final route = MaterialPageRoute(builder: (context) {
      return SportPage(
        sportType: sportType,
      );
    });
    Navigator.of(context).push(route);
  }
}

class _SportsRow extends StatelessWidget {
  final List<SportType> sportTypes;

  final ValueChanged<SportType> tapCallback;

  _SportsRow({
    this.sportTypes,
    this.tapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Container(
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
        child: Wrap(
          runSpacing: 10.0,
          children: _children(context: context),
        ),
      ),
    );
  }

  List<Widget> _children({
    BuildContext context,
  }) {
    return sportTypes.map((e) {
      return InkWell(
        onTap: () {
          tapCallback(e);
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 2.0,
            right: 2.0,
          ),
          width: (MediaQuery.of(context).size.width - 60.0) / 4.0,
          child: Column(
            children: [
              Icon(
                e.iconCodePoint,
                color: Theme.of(context).primaryColor,
                size: 40.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                e.localName(context: context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _DataRow extends StatelessWidget {
  final String distance;

  final String kcal;

  _DataRow({
    @required this.distance,
    @required this.kcal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          _toSportRecordPage(context: context);
        },
        child: Container(
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      S.of(context).sportData,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).totalKm),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          distance ?? "--",
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(S.of(context).km),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).totalCal),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          kcal ?? "--",
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(S.of(context).cal),
                      ],
                    ),
                  ],
                ),
              ),
              Transform.rotate(
                angle: pi,
                child: Icon(Icons.arrow_back_ios_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toSportRecordPage({
    @required BuildContext context,
  }) {
    final route = MaterialPageRoute(builder: (context) {
      return SportRecordPage();
    });
    Navigator.of(context).push(route);
  }
}

class _AdRow extends StatelessWidget {
  final bool isEnabled;

  final Error error;

  _AdRow({
    @required this.isEnabled,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Container(
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
        child: Column(
          children: [
            Text(
              S.of(context).ad,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            isEnabled
                ? ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                            AdManager().loadAd();
                          }
                        : null,
                    child: Container(
                      height: 45.0,
                      alignment: Alignment.center,
                      child: Text(
                        S.of(context).lookAd,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CupertinoActivityIndicator(),
                  ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
