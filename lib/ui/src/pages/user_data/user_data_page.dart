import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../data/src/repositories/data_repository.dart';
import '../../../../generated/l10n.dart';

class UserDataPage extends StatefulWidget {
  @override
  _UserDataPageState createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  /// 体重
  String _weight = DataRepository.user.weight ?? "";

  bool _isSubmit = false;

  TextEditingController _nameEditingController =
      TextEditingController(text: DataRepository.user.weight);

  bool get _isSubmitEnabled {
    return _weight.length > 0 && double.parse(_weight) > 0 && !_isSubmit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).basicData),
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
                controller: _nameEditingController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true),
                ],
                decoration: InputDecoration(
                  hintText: S.of(context).inputWeight,
                  filled: true,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: _isSubmitEnabled ? _submit : null,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).save),
                      _isSubmit
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: CupertinoActivityIndicator(),
                            )
                          : Container(),
                    ],
                  ),
                ),
              )
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
      await DataRepository.uploadUserData(weight: _weight);
      _back();
    } catch (e) {
      _showMessage(message: "保存失败，请重试！");
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
