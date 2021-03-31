import 'package:flutter/material.dart';
import 'package:tinawork/src/components/menu/drawer_content.dart';

import 'src/screens/auth/login/login.dart';
import 'src/screens/auth/register/register.dart';
import 'src/screens/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/login',
      routes:{
        '/login' : (context) => LoginPage(),
        '/Register': (context) => RegisterPage(),
        '/drawer' :(context) => DrawerContent(),
      },
    );
  }
}


