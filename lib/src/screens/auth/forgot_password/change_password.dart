import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:tinawork/src/api/forgot-password/api-forgot-password.dart';
import 'package:tinawork/src/screens/auth/login/login.dart';
import 'package:tuple/tuple.dart';

class ChangePassword extends StatefulWidget {
  final email;
  final code;
  ChangePassword(this.email, this.code);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangePassword(this.email, this.code);
  }
}

class _ChangePassword extends State<ChangePassword> {
  final email;
  final code;
  _ChangePassword(this.email, this.code);

  bool _newPassVisible = false;
  bool _reTypePassVisible = false;
  bool _isLoading = false;
  final newPassController = TextEditingController();
  final reTypePassController = TextEditingController();
  FocusNode retypeFocus = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  _changePassword(newPassword) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      Tuple2<Response, bool> result = await ApiForgotPassword.changePassword(this.email, this.code, reTypePassController.text);
      Future.delayed(Duration(milliseconds: 200), (){
        setState(() {
          _isLoading = false;
        });
      });

      if (result.item2) {
        if (result.item1?.statusCode == 204) {
          await _showDialogNotify('Đổi mật khẩu', 'Thành công');
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: widthScreen * 0.8,
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              retypeFocus.requestFocus();
                            },
                            enabled: !_isLoading,
                            controller: newPassController,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: !_newPassVisible,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Require';
                              }
                              else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Nhập mật khẩu mới',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _newPassVisible = !_newPassVisible;
                                    });
                                  },
                                  icon: _newPassVisible ?
                                  Icon(Icons.visibility, color: Colors.black,) :
                                  Icon(Icons.visibility_off, color: Colors.black,),
                                )
                            ),
                          ),
                        ),
                        Container(
                          width: widthScreen * 0.8,
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              if (formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _changePassword(this.reTypePassController.text);
                              }
                            },
                            focusNode: retypeFocus,
                            enabled: !_isLoading,
                            controller: reTypePassController,
                            obscureText: !_reTypePassVisible,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              else if (newPassController.text != reTypePassController.text) {
                                return 'Mật khẩu không khớp';
                              }
                              else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Nhập lại mật khẩu mới',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: _reTypePassVisible ?
                                  Icon(Icons.visibility, color: Colors.black,) :
                                  Icon(Icons.visibility_off, color: Colors.black,),
                                  onPressed: () {
                                    setState(() {
                                      _reTypePassVisible = !_reTypePassVisible;
                                    });
                                  },
                                )
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  height: 87,
                  child: !_isLoading ? SizedBox(
                    child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _changePassword(this.reTypePassController.text);
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
                          'Đổi mật khẩu',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                          ),
                        )),
                  ) : Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                      onPressed: !_isLoading ? () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      } : null,
                      style: ButtonStyle(
                          backgroundColor: !_isLoading ?
                          MaterialStateProperty.all(Colors.red) :
                          MaterialStateProperty.all(Colors.red[200]),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                              )
                          )
                      ),
                      child: Text(
                        'Hủy bỏ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      )),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}