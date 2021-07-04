import 'package:flutter/material.dart';
import '../../../../data/data.dart';
import '../pages.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          child: Image.asset(
            'assets/images/launch.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  void _autoLogin() async {
    // var account = await DataRepository.account();
    // if (account == null) {
    //   _toLoginPage();
    // } else {
    //   _login(
    //     account: account,
    //   );
    // }
    _login(
      account: AccountModel(phone: "18910434687", password: "123456"),
    );
  }

  void _login({
    @required AccountModel account,
  }) async {
    Future.delayed(Duration(seconds: 1), _toHomePage);
  }

  // void _toLoginPage() {
  //   var route = MaterialPageRoute(builder: (context) {
  //     return LoginPage();
  //   });
  //   Navigator.of(context).pushReplacement(route);
  // }

  void _toHomePage() {
    var user = UserModel(uuid: "E6DB3EA9-B606-4D1D-8B64-6D2C757C337B");
    DataRepository.user = user;
    var route = MaterialPageRoute(builder: (context) {
      return HomePage();
    });
    Navigator.of(context).pushReplacement(route);
  }
}
