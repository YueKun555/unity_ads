import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../data/data.dart';
import '../pages.dart';
import '../../../../generated/l10n.dart';

class SportRecordPage extends StatefulWidget {
  @override
  _SportRecordPageState createState() => _SportRecordPageState();
}

class _SportRecordPageState extends State<SportRecordPage> {
  RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );

  List<SportModel> _records = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).sportRecord),
      ),
      body: SmartRefresher(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: 15.0,
          ),
          itemCount: _records.length,
          itemBuilder: (context, index) {
            return _DataRow(
              model: _records[index],
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    try {
      var response = await DataRepository.sportRecord();
      setState(() {
        _records.clear();
        _records.addAll(response);
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
        top: 20.0,
        left: 15.0,
        right: 15.0,
      ),
      child: InkWell(
        onTap: () {
          _toDetailPage(context: context, model: model);
        },
        child: Container(
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                    Positioned(
                      right: 0,
                      child: Transform.rotate(
                        angle: pi,
                        child: Icon(Icons.arrow_back_ios_outlined),
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
        ),
      ),
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
    Navigator.of(context).push(route);
  }
}
