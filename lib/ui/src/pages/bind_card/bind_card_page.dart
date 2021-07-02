import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/data.dart';

class BindCardPage extends StatefulWidget {
  /// 名称
  final String name;

  /// 卡号
  final String number;

  BindCardPage({
    this.name,
    this.number,
  });

  @override
  _BindCardPageState createState() => _BindCardPageState();
}

class _BindCardPageState extends State<BindCardPage> {
  String _user = "";

  String _number = "";

  bool _isSubmit = false;

  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _numberEditingController = TextEditingController();

  bool get _submitEnabled {
    return _user.length > 0 && _number.length > 0 && !_isSubmit;
  }

  @override
  void initState() {
    super.initState();
    _user = widget.name ?? "";
    _nameEditingController.text = _user;

    _number = widget.number ?? "";
    _numberEditingController.text = _number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('绑定银行卡'),
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
                controller: _numberEditingController,
                onChanged: (value) {
                  setState(() {
                    _number = value;
                  });
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: "请输入银行卡号",
                  filled: true,
                ),
              ),
              TextField(
                controller: _nameEditingController,
                onChanged: (value) {
                  setState(() {
                    _user = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "请输入开户人名称",
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
                      Text('保存'),
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
      await DataRepository.bind(
        user: _user,
        number: _number,
      );
      _back();
    } catch (e) {
      _showMessage(message: "绑定失败，请重试！");
    } finally {
      setState(() {
        _isSubmit = false;
      });
    }
  }

  void _back() {
    Navigator.of(context).pop(true);
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
