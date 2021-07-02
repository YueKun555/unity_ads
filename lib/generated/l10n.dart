// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign in`
  String get login {
    return Intl.message(
      'Sign in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Please input mobile phone number`
  String get inputPhone {
    return Intl.message(
      'Please input mobile phone number',
      name: 'inputPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please input a password`
  String get inputPassword {
    return Intl.message(
      'Please input a password',
      name: 'inputPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please repeat the password`
  String get repeatInputPassword {
    return Intl.message(
      'Please repeat the password',
      name: 'repeatInputPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please read it carefully and agree`
  String get loginProtocolTips {
    return Intl.message(
      'Please read it carefully and agree',
      name: 'loginProtocolTips',
      desc: '',
      args: [],
    );
  }

  /// `《User privacy protocol》`
  String get loginProtocol {
    return Intl.message(
      '《User privacy protocol》',
      name: 'loginProtocol',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please try again!`
  String get loginFailure {
    return Intl.message(
      'Login failed, please try again!',
      name: 'loginFailure',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed, please try again!`
  String get registerFailure {
    return Intl.message(
      'Registration failed, please try again!',
      name: 'registerFailure',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sport {
    return Intl.message(
      'Sports',
      name: 'sport',
      desc: '',
      args: [],
    );
  }

  /// `Network exception, please try again!`
  String get networkFailure {
    return Intl.message(
      'Network exception, please try again!',
      name: 'networkFailure',
      desc: '',
      args: [],
    );
  }

  /// `Sports Data`
  String get sportData {
    return Intl.message(
      'Sports Data',
      name: 'sportData',
      desc: '',
      args: [],
    );
  }

  /// `Movement:`
  String get totalKm {
    return Intl.message(
      'Movement:',
      name: 'totalKm',
      desc: '',
      args: [],
    );
  }

  /// `KM`
  String get km {
    return Intl.message(
      'KM',
      name: 'km',
      desc: '',
      args: [],
    );
  }

  /// `Consume:`
  String get totalCal {
    return Intl.message(
      'Consume:',
      name: 'totalCal',
      desc: '',
      args: [],
    );
  }

  /// `kcal`
  String get cal {
    return Intl.message(
      'kcal',
      name: 'cal',
      desc: '',
      args: [],
    );
  }

  /// `Ads`
  String get ad {
    return Intl.message(
      'Ads',
      name: 'ad',
      desc: '',
      args: [],
    );
  }

  /// `Watch creative ads`
  String get lookAd {
    return Intl.message(
      'Watch creative ads',
      name: 'lookAd',
      desc: '',
      args: [],
    );
  }

  /// `start`
  String get start {
    return Intl.message(
      'start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `duration`
  String get duration {
    return Intl.message(
      'duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `pace`
  String get pace {
    return Intl.message(
      'pace',
      name: 'pace',
      desc: '',
      args: [],
    );
  }

  /// `mintes`
  String get mintes {
    return Intl.message(
      'mintes',
      name: 'mintes',
      desc: '',
      args: [],
    );
  }

  /// `mintes/KM`
  String get mintesKm {
    return Intl.message(
      'mintes/KM',
      name: 'mintesKm',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy`
  String get accuracy {
    return Intl.message(
      'Accuracy',
      name: 'accuracy',
      desc: '',
      args: [],
    );
  }

  /// `Sport Record`
  String get sportRecord {
    return Intl.message(
      'Sport Record',
      name: 'sportRecord',
      desc: '',
      args: [],
    );
  }

  /// `metres`
  String get metres {
    return Intl.message(
      'metres',
      name: 'metres',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get Running {
    return Intl.message(
      'Running',
      name: 'Running',
      desc: '',
      args: [],
    );
  }

  /// `Cycling`
  String get Cycling {
    return Intl.message(
      'Cycling',
      name: 'Cycling',
      desc: '',
      args: [],
    );
  }

  /// `Walk`
  String get Walk {
    return Intl.message(
      'Walk',
      name: 'Walk',
      desc: '',
      args: [],
    );
  }

  /// `climb`
  String get Climb {
    return Intl.message(
      'climb',
      name: 'Climb',
      desc: '',
      args: [],
    );
  }

  /// `Basic Data`
  String get basicData {
    return Intl.message(
      'Basic Data',
      name: 'basicData',
      desc: '',
      args: [],
    );
  }

  /// `Please enter weight (kg)`
  String get inputWeight {
    return Intl.message(
      'Please enter weight (kg)',
      name: 'inputWeight',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}