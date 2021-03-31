import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinawork/src/screens/auth/login/login.dart';

class CoreServices {
  // Hàm lưu thông tin User và Token
  static void saveProfile(Map<String, String> profile, String token) async {
    final keys = profile.keys.toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    keys.map((key) => () {
      prefs.setString(key, profile[key]);
    });
  }

  // Đăng xuất tài khoản
  static void logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}