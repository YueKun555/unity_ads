import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './http_api.dart';
import './http_client.dart';

import '../models/models.dart';

class DataRepository {
  static UserModel user;

  static Future<AccountModel> account() async {
    await Future.delayed(Duration(seconds: 1), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = prefs.getString('user_phone');
    var password = prefs.getString('user_password');
    if (phone != null && password != null) {
      return AccountModel(
        phone: phone,
        password: password,
      );
    }
    return null;
  }

  static Future<bool> saveAccount({
    String phone,
    String password,
  }) async {
    await Future.delayed(Duration(seconds: 1), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_phone', phone);
    prefs.setString('user_password', password);
    return true;
  }

  static Future<bool> register({
    String phone,
    String password,
  }) async {
    await HttpClient().post(path: HttpApi.register, data: {
      "phone": phone,
      "password": password,
    });
    return true;
  }

  static Future<UserModel> login({
    String phone,
    String password,
  }) async {
    var response = await HttpClient().post(path: HttpApi.login, data: {
      "phone": phone,
      "password": password,
    });
    var user = UserModel.formJson(json: response.data);
    await saveAccount(
      phone: phone,
      password: password,
    );
    DataRepository.user = user;
    return user;
  }

  static Future<HomeModel> home() async {
    var response = await HttpClient().get(
      path: HttpApi.homepage,
      query: {
        "userUuid": user.uuid,
      },
    );
    return HomeModel.formJson(json: response.data);
  }

  static Future<bool> uploadUserData({
    String weight,
  }) async {
    await HttpClient().post(path: HttpApi.userInfo, data: {
      "userUuid": user.uuid,
      "weight": weight,
    });
    user.weight = weight;
    return true;
  }

  static Future<bool> uploadSportData({
    SportModel model,
  }) async {
    var data = model.toJson();
    data['userUuid'] = user.uuid;
    await HttpClient().post(
      path: HttpApi.sports,
      data: data,
    );
    return true;
  }

  static Future<List<SportModel>> sportRecord() async {
    var response = await HttpClient().get(
      path: HttpApi.sports,
      query: {
        "userUuid": user.uuid,
      },
    );
    List<SportModel> reocrds = [];
    for (var json in response.data) {
      var model = SportModel.formJson(json: json);
      reocrds.add(model);
    }
    return reocrds;
  }

  static Future<MoneyModel> energys() async {
    var response = await HttpClient().get(
      path: HttpApi.energys,
      query: {
        "userUuid": user.uuid,
      },
    );
    var model = MoneyModel.formJson(json: response.data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    model.cardUser = prefs.getString('card_user');
    model.cardNumber = prefs.getString('card_number');
    return model;
  }

  static Future<bool> createEnergys({
    int number,
  }) async {
    HttpClient().post(
      path: HttpApi.energys,
      data: {
        "userUuid": user.uuid,
        "number": number,
      },
    );
    return true;
  }

  static Future<bool> extractMoney() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await HttpClient().post(
      path: HttpApi.moneysExtract,
      data: {
        "userUuid": user.uuid,
        "cardUser": prefs.getString('card_user'),
        "cardNumber": prefs.getString('card_number'),
      },
    );
    return true;
  }

  static Future<List<ExtractMoneyRecordModel>> extractMoneyRecord() async {
    var response = await HttpClient().get(
      path: HttpApi.moneysExtract,
      query: {
        "userUuid": user.uuid,
      },
    );
    List<ExtractMoneyRecordModel> reocrds = [];
    for (var json in response.data) {
      var model = ExtractMoneyRecordModel.formJson(json: json);
      reocrds.add(model);
    }
    return reocrds;
  }

  static Future<bool> bind({
    @required String user,
    @required String number,
  }) async {
    await Future.delayed(Duration(seconds: 1), () {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("card_user", user);
    prefs.setString("card_number", number);
    return true;
  }
}
