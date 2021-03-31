import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:tinawork/src/api/forgot-password/api-forgot-password.dart';
import 'package:tinawork/src/screens/auth/forgot_password/change_password.dart';
import 'package:tuple/tuple.dart';

class VerifyCode extends StatefulWidget {
  final email;
  VerifyCode(this.email);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VerifyCode(this.email);
  }
}

class _VerifyCode extends State<VerifyCode> {
  final email;
  _VerifyCode(this.email);

  final codeController = TextEditingController();
  final codeFieldKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _showDialogNotify(String title,String errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorMessage ?? ''),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _reSendVerifyCode() async {
    try {
      Tuple2<Response, bool> result = await ApiForgotPassword.sendEmail(this.email);

      if (result.item2) {
        if (result.item1?.statusCode == 204) {
          _showDialogNotify('Lấy mã xác thực', 'Mã xác thực đã được gửi tới địa chỉ email của bạn');
        }
        else {
          _showDialogNotify('Lưu ý!', jsonDecode(result.item1?.body)['errorMessageDesc']);
        }
      }
      else {
        _showDialogNotify('Lưu ý!', 'Vui lòng kiểm tra hoặc bật kết nối mạng');
      }
    }
    on SocketException catch (e) {
      _showDialogNotify('Lưu ý!', 'Vui lòng kiểm tra kết nối mạng');
    }
    on Error catch (e) {
      _showDialogNotify('Lưu ý!', 'Có lỗi xảy ra');
    }
  }

  _sendVerifyCode() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      Tuple2<Response, bool> result = await ApiForgotPassword.sendVerifyCode(this.email, codeController.text);
      Future.delayed(Duration(milliseconds: 200), (){
        setState(() {
          _isLoading = false;
        });
      });

      if (result.item2) {
        if (result.item1?.statusCode == 200) {
          if (jsonDecode(result.item1?.body)['result']) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(this.email, jsonDecode(result.item1?.body)['newOtpCode'])));
          }
          else {
            _showDialogNotify('Lưu ý!', 'Mã xác thực không đúng');
          }
        }
        else {
          _showDialogNotify('Lưu ý!', jsonDecode(result.item1?.body)['errorMessageDesc']);
        }
      }
      else {
        _showDialogNotify('Lưu ý!', 'Vui lòng kiểm tra hoặc bật kết nối mạng');
      }
    }
    on SocketException catch (e) {
      _showDialogNotify('Lưu ý!', 'Kiểm tra kết nối mạng');
    }
    on Error catch (e) {
      _showDialogNotify('Lưu ý!', 'Có lỗi xảy ra');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: KeyboardDismisser(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: heightScreen * 0.3,
                  child: Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Container(
                  width: widthScreen * 0.8,
                  child: Form(
                    key: codeFieldKey,
                    child: TextFormField(
                      controller: codeController,
                      onFieldSubmitted: (value) {
                        if (codeFieldKey.currentState.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          _sendVerifyCode();
                        }
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'required';
                        }
                        else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Nhập mã xác thực',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        prefixIcon: Icon(Icons.qr_code, color: Colors.black,),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(50),
                  height: 136,
                  child: !_isLoading ? SizedBox(
                    width: widthScreen * 0.3,
                    child: ElevatedButton(
                        onPressed: () {
                          if (codeFieldKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _sendVerifyCode();
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)
                                )
                            )
                        ),
                        child: Text(
                          'Gửi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                          ),
                        )),
                  ) : new CircularProgressIndicator()
                ),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh),
                        TextButton(
                          onPressed: () {
                            _reSendVerifyCode();
                          },
                          child: Text(
                            'Gửi lại mã xác thực',
                            style: TextStyle(
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}