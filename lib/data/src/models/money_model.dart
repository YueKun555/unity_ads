import 'package:flutter/material.dart';

class MoneyModel {
  int energy;
  String message;
  int money;
  String cardUser;
  String cardNumber;

  MoneyModel({
    @required this.energy,
    @required this.money,
    @required this.message,
  });

  static MoneyModel formJson({Map<String, dynamic> json}) {
    return MoneyModel(
      energy: json['energy'],
      money: json['money'],
      message: json['message'],
    );
  }
}
