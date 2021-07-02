class HttpApi {
  static String get _host {
    return "https://sport.yuekun.net";
  }

  static String get register {
    return "$_host/authorizations/register";
  }

  static String get login {
    return "$_host/authorizations/login";
  }

  static String get userInfo {
    return "$_host/users/info";
  }

  static String get homepage {
    return "$_host/homepage";
  }

  static String get sports {
    return "$_host/sports";
  }

  static String get energys {
    return "$_host/energys";
  }

  static String get moneysExtract {
    return "$_host/moneys/extract";
  }

  static String get privacy {
    return "$_host/privacy.html";
  }
}
