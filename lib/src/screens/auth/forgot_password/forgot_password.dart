import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:tinawork/src/api/forgot-password/api-forgot-password.dart';
import 'package:tinawork/src/screens/auth/forgot_password/verify_code.dart';
import 'package:tinawork/src/screens/auth/register/register.dart';
import 'package:tuple/tuple.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final emailController = TextEditingController();
  final emailFieldKey = GlobalKey<FormState>();
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

  _sendEmail(String email) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      Tuple2<Response, bool> result = await ApiForgotPassword.sendEmail(emailController.text);
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          _isLoading = false;
        });
      });

      if (result.item2) {

        if (result.item1?.statusCode == 204) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCode(emailController.text)));
        }
        else {
          _showDialogNotify('Lưu ý!', jsonDecode(result.item1?.body)['errorMessageDesc'] ?? jsonDecode(result.item1?.body)['message'][0]);
        }
      }
      else {
        _showDialogNotify('Lưu ý!', 'Vui lòng kiểm tra hoặc bật kết nối mạng');
      }
    }
    on SocketException catch (e) {
      _showDialogNotify('lưu ý', 'Vui lòng kiểm tra kết nối internet');
    }
    on Error catch (e) {
      _showDialogNotify('Lưu ý', 'Có lỗi xảy ra');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: KeyboardDismisser(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      key: emailFieldKey,
                      child: TextFormField(
                        onFieldSubmitted: (value) {
                          if (emailFieldKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _sendEmail(value);
                          }
                        },
                        enabled: !_isLoading,
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required';
                          }
                          else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.black,),
                            labelText: 'Nhập email',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0)
                        ),
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.all(50),
                  height: 136,
                  child: !_isLoading ? SizedBox(
                    width: widthScreen * 0.3,
                    child: ElevatedButton(
                        onPressed: () {
                          if (emailFieldKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _sendEmail(emailController.text);
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
                  ) : new CircularProgressIndicator(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 35,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          'Đăng ký tài khoản',
                          style: TextStyle(
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );

  }
}
