import 'package:intl/intl.dart';

class ExtractMoneyRecordModel {
  int money;
  String status;
  String cardUser;
  String cardNumber;
  DateTime createdAt;

  ExtractMoneyRecordModel({
    this.money,
    this.status,
    this.cardUser,
    this.cardNumber,
    this.createdAt,
  });

  static ExtractMoneyRecordModel formJson({Map<String, dynamic> json}) {
    return ExtractMoneyRecordModel(
      money: json['number'],
      status: json['status'],
      cardUser: json['cardUser'],
      cardNumber: json['cardNumber'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
    );
  }

  String get createTimeString {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(this.createdAt);
    return formattedDate;
  }

  String get stateString {
    if (this.status == "ing") {
      return "处理中";
    } else if (this.status == "success") {
      return "已完成";
    } else if (this.status == "failure") {
      return "失败";
    } else {
      return "";
    }
  }
}
