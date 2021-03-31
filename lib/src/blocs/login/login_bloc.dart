import 'dart:async';

import 'package:tinawork/src/api/login/api_login.dart';



class LoginBloc{
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;



  bool isValidInfo(String user,String pass){
    if(!ApiLogin.isValid(user)){
      _userController.sink.addError('Chưa nhập tài khoản');
      return false;
    };
    _userController.sink.add('OK');


    if(!ApiLogin.isValid(pass)){
      _passController.sink.addError('Chưa nhập mật khẩu');
      return false;
    };
    _passController.sink.add('OK');

    if(!ApiLogin.checkUser(user)){
      _userController.sink.addError('Tài khoản không tồn tại');
      return false;
    };
    _userController.sink.add('Ok');

    if(!ApiLogin.checkPass(user, pass)){
      _passController.sink.addError('Mật khẩu không chính xác');
      return false;
    }
    _passController.sink.add('OK');

    return true;
  }

  void dispose(){
    _userController.close();
    _passController.close();
  }
}