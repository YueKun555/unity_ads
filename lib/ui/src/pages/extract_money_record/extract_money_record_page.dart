import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../data/data.dart';

class ExtractMoneyRecordPage extends StatefulWidget {
  @override
  _ExtractMoneyRecordPageState createState() => _ExtractMoneyRecordPageState();
}

class _ExtractMoneyRecordPageState extends State<ExtractMoneyRecordPage> {
  RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );

  List<ExtractMoneyRecordModel> _records = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('提现记录'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        physics: AlwaysScrollableScrollPhysics(),
        onRefresh: _onRefresh,
        child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: 15.0,
          ),
          itemCount: _records.length,
          itemBuilder: (context, index) {
            return _RecordRow(
              model: _records[index],
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    try {
      var response = await DataRepository.extractMoneyRecord();
      setState(() {
        _records.clear();
        _records.addAll(response);
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
}

class _RecordRow extends StatelessWidget {
  final ExtractMoneyRecordModel model;

  _RecordRow({
    @required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 15.0,
        left: 15.0,
        right: 15.0,
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${model.money}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  TextSpan(
                    text: ' 元',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              model.stateString,
              style: TextStyle(
                color: _statusColor(),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("开户人：${model.cardUser}"),
            SizedBox(
              height: 10.0,
            ),
            Text("卡号：${model.cardNumber}"),
            SizedBox(
              height: 10.0,
            ),
            Text(model.createTimeString),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor() {
    if (model.status == "ing") {
      return Colors.grey;
    } else if (model.status == "success") {
      return Colors.green;
    } else if (model.status == "failure") {
      return Colors.red;
    }
    return Colors.transparent;
  }
}
