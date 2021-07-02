import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/data.dart';
import '../../../../generated/l10n.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _phone = "";

  String _password = "";

  String _repeatPassword = "";

  bool _isSubmit = false;

  bool get _submitEnabled {
    return _phone.length == 11 &&
        _password.length > 0 &&
        _password == _repeatPassword &&
        !_isSubmit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).register),
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
              TextField(
                onChanged: (value) {
                  setState(() {
                    _repeatPassword = value;
                  });
                },
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: S.of(context).repeatInputPassword,
                  filled: true,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: _submitEnabled ? _submit : null,
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
                      Text(S.of(context).register),
                      _isSubmit
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

  void _submit() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        _isSubmit = true;
      });
      await DataRepository.register(
        phone: _phone,
        password: _password,
      );
      _back();
    } catch (e) {
      _showMessage(message: "注册失败，请重试！");
    } finally {
      setState(() {
        _isSubmit = false;
      });
    }
  }

  void _back() {
    Navigator.of(context).pop();
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
