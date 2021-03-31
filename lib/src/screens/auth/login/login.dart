import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:tinawork/src/blocs/login/login_bloc.dart';
import 'package:tinawork/src/screens/auth/forgot_password/forgot_password.dart';
import 'package:tinawork/src/screens/auth/register/register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key,this.title}) : super(key: key);
  final String title;
  @override
  _LoginPage createState() =>  _LoginPage();
}

class  _LoginPage extends State<LoginPage> {
  LoginBloc bloc = new LoginBloc();
  bool Pass = true;
  TextEditingController _userControl = new TextEditingController();
  TextEditingController _passControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child:Scaffold(
        body: Container(
            constraints: BoxConstraints.expand(),
            child:SingleChildScrollView(
              child:Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(50,80,50,10),
                        child: StreamBuilder(
                          stream: bloc.userStream,
                          builder: (context,snapshot) =>
                              TextField(
                                controller: _userControl,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black,width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  labelStyle: TextStyle(color: Colors.black,fontSize: 15),
                                  errorText: snapshot.hasError? snapshot.error : null,
                                  prefixIcon: Container(
                                    width: 50,
                                    child: Icon(Icons.account_circle),
                                  ),
                                  labelText: 'Username',
                                ),
                              ),
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(50,10,50,50),
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children:<Widget> [
                            StreamBuilder(
                              stream: bloc.passStream,
                              builder: (context,snapshot) => TextField(
                                controller: _passControl,
                                obscureText: Pass,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black,width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  errorText: snapshot.hasError ? snapshot.error:null,
                                  prefixIcon: Container(
                                    width: 50,
                                    child: Icon(Icons.lock),
                                  ),
                                  labelStyle: TextStyle(color: Colors.black,fontSize: 15),
                                  labelText: 'Password',
                                ),
                              ),

                            ),
                            GestureDetector(
                                onTap: Showpass,
                                child:Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0 ) ,
                                    child: Icon(Pass? Icons.visibility : Icons.visibility_off)
                                )
                            )
                          ],
                        )
                    ),
                    SizedBox(
                      height: 45,
                      width: 135,
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            )
                        ),
                        onPressed: SignIn,
                        child: Text('Đăng nhập',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,40,0,20),
                      child: TextButton(
                          onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterPage()));
                          },
                          child: Text('Đăng kí ở đây',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,50),
                      child: TextButton(
                          onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ForgotPassword()));
                          },
                          child: Text('Quên mật khẩu?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),)
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
  SignIn(){
    setState(() {
      if(bloc.isValidInfo(_userControl.text, _passControl.text)){
        Navigator.pushNamed(context,'/drawer');
      }
    });
  }

  Showpass(){
    setState(() {
      Pass = !Pass;
    });
  }
}