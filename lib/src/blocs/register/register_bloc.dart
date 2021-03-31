import 'dart:async';

import 'package:tinawork/src/api/login/api_login.dart';

class RegisterBloc{
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController _firstController = new StreamController();
  StreamController _lastController = new StreamController();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get firstStream => _firstController.stream;
  Stream get lastStream => _lastController.stream;

  bool CheckRegister(String user,String pass,String email,String first,String last){
    if(!ApiLogin.isValid(user)){
      _userController.sink.addError('Chưa nhập tài khoản');
      return false;
    }
    _userController.sink.add('Ok');

    if(!ApiLogin.numOfKey(user)){
      _userController.sink.addError('tài khoản cần ít nhất 5 ký tự');
      return false;
    };
    _userController.sink.add('OK');

    if(!ApiLogin.isValid(pass)){
      _passController.sink.addError('Chưa nhập mật khẩu');
      return false;
    }
    _passController.sink.add('Ok');

    if(!ApiLogin.numOfKey(pass)){
      _passController.sink.addError('Mật khẩu tối thiểu là 5 ký tự');
      return false;
    };
    _passController.sink.add('OK');

    if(!ApiLogin.isValid(email)){
      _emailController.sink.addError('Chưa nhập email');
      return false;
    }
    _emailController.sink.add('oke');

    if(!ApiLogin.checkEmail(email)){
      _emailController.sink.addError('Email chưa đúng định dạng');
      return false;
    }
    _emailController.sink.add('ok');

    if(!ApiLogin.isValid(first)){
      _firstController.sink.addError('Chưa nhập first name');
      return false;
    }
    _firstController.sink.add('oke');

    if(!ApiLogin.isValid(last)){
      _lastController.sink.addError('Chưa nhập last name');
      return false;
    }
    _lastController.sink.add('oke');

    return true;
  }


  void dispose(){
    _userController.close();
    _passController.close();
    _emailController.close();
    _firstController.close();
    _lastController.close();
  }

}