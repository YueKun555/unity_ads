import 'dart:io';

enum Env {
  dev,
  test,
  release,
}

class AppConfig {
  /// 环境
  static Env env = Env.dev;

  static String get gdApiKey {
    if (Platform.isIOS) {
      return "";
    } else if (Platform.isAndroid) {
      return "20824a2f383a9372ee92c1dd903adebc";
    } else {
      return "";
    }
  }

  static String get gameId {
    if (Platform.isIOS) {
      return "4200012";
    } else if (Platform.isAndroid) {
      return "4200013";
    } else {
      return "";
    }
  }
}
