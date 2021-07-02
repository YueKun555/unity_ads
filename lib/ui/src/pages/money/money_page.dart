import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../data/data.dart';
import '../pages.dart';

class MoneyPage extends StatefulWidget {
  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );

  MoneyModel _model;

  bool _isSubmit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('赚钱'),
      ),
      body: SmartRefresher(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _model == null ? 0 : 2,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _EnergyRow(
                  energy: _model.energy,
                  message: _model.message,
                  adCallback: _toAdPage,
                );
              case 1:
                return _MoneyRow(
                  money: _model.money,
                  isSubmit: _isSubmit,
                  extractCallback: _extractCallback,
                  recordCallback: _recordCallback,
                  bindCallback: _bindCallback,
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    try {
      var model = await DataRepository.energys();
      setState(() {
        _model = model;
      });
    } catch (e) {
      _showMessage(message: "网络异常，请重试！");
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

  void _extractCallback() async {
    if (_model.cardUser != null && _model.cardNumber != null) {
      try {
        setState(() {
          _isSubmit = true;
        });
        await DataRepository.extractMoney();
        setState(() {
          _model.money = 0;
        });
        _refreshController.requestRefresh();
      } catch (e) {
        _showMessage(message: "网络异常，请重试！");
      } finally {
        setState(() {
          _isSubmit = false;
        });
      }
    } else {
      _bindCallback();
    }
  }

  void _recordCallback() {
    final route = MaterialPageRoute(builder: (context) {
      return ExtractMoneyRecordPage();
    });
    Navigator.of(context).push(route);
  }

  void _bindCallback() async {
    final route = MaterialPageRoute(builder: (context) {
      return BindCardPage(
        name: _model.cardUser,
        number: _model.cardNumber,
      );
    });
    var result = await Navigator.of(context).push(route);
    if (result == true) {
      _refreshController.requestRefresh();
    }
  }

  void _toAdPage() async {}

  @override
  void dispose() {
    super.dispose();
  }
}

class _EnergyRow extends StatelessWidget {
  final int energy;

  final String message;

  final VoidCallback adCallback;

  _EnergyRow({
    @required this.energy,
    @required this.message,
    this.adCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
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
            SizedBox(
              height: 10.0,
            ),
            Text(
              '能量',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$energy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              message,
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  final int money;
  final bool isSubmit;
  final VoidCallback extractCallback;
  final VoidCallback recordCallback;
  final VoidCallback bindCallback;
  _MoneyRow({
    @required this.money,
    @required this.isSubmit,
    this.extractCallback,
    this.recordCallback,
    this.bindCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
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
            SizedBox(
              height: 10.0,
            ),
            Text(
              '现金',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$money",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  TextSpan(text: " 元"),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: (money > 0 && !isSubmit)
                  ? () {
                      if (extractCallback != null) {
                        extractCallback();
                      }
                    }
                  : null,
              child: Container(
                height: 45.0,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('提现'),
                    isSubmit
                        ? Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: CupertinoActivityIndicator(),
                          )
                        : Container(),
                  ],
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.isEmpty) {
                      return Colors.white;
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (recordCallback != null) {
                  recordCallback();
                }
              },
              child: Container(
                height: 45.0,
                alignment: Alignment.center,
                child: Text('提现记录'),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.isEmpty) {
                      return Colors.white;
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (bindCallback != null) {
                  bindCallback();
                }
              },
              child: Container(
                height: 45.0,
                alignment: Alignment.center,
                child: Text('绑定'),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.isEmpty) {
                      return Colors.white;
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
