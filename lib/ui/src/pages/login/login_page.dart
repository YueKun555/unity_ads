import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/data.dart';
import '../../../../data/src/repositories/http_api.dart';
import '../pages.dart';
import '../../../../generated/l10n.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _phone = "";

  String _password = "";

  bool _isLogin = false;

  bool _isAgree = false;

  bool get _submitEnabled {
    return _phone.length == 11 && _password.length > 0 && !_isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
        actions: [
          TextButton(
            onPressed: _toRegisterPage,
            child: Text(
              S.of(context).register,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: S.of(context).inputPhone,
                  filled: true,
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: S.of(context).inputPassword,
                  filled: true,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  CupertinoSwitch(
                      value: _isAgree,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() {
                          _isAgree = value;
                        });
                      }),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _toWebPage();
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: S.of(context).loginProtocolTips),
                            TextSpan(
                              text: S.of(context).loginProtocol,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: _submitEnabled ? _login : null,
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
                child: Container(
                  height: 45.0,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).login),
                      _isLogin
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: CupertinoActivityIndicator(),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toRegisterPage() {
    var route = MaterialPageRoute(builder: (context) {
      return RegisterPage();
    });
    Navigator.of(context).push(route);
  }

  void _login() async {
    if (!_isAgree) {
      _showMessage(
        message: S.of(context).loginProtocolTips + S.of(context).loginProtocol,
      );
      return;
    }

    try {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        _isLogin = true;
      });
      await DataRepository.login(
        phone: _phone,
        password: _password,
      );
      _toHomePage();
    } catch (e) {
      _showMessage(message: S.of(context).registerFailure);
    } finally {
      setState(() {
        _isLogin = false;
      });
    }
  }

  void _toHomePage() {
    var route = MaterialPageRoute(builder: (context) {
      return HomePage();
    });
    Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
  }

  void _toWebPage() {
    final router = MaterialPageRoute(
      builder: (context) => WebPage(
        title: S.of(context).loginProtocol,
        urlString: HttpApi.privacy,
      ),
    );
    Navigator.of(context).push(router);
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
