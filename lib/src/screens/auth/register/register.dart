
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:tinawork/src/blocs/register/register_bloc.dart';
import 'package:tinawork/src/screens/auth/login/login.dart';


class RegisterPage extends StatefulWidget{
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPage createState() =>  _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {

  bool seePass = false ;
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _firstController = new TextEditingController();
  TextEditingController _lastController = new TextEditingController();

  RegisterBloc bloc = new RegisterBloc();

  @override
  Widget build(BuildContext context) {
    return  KeyboardDismisser(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: SingleChildScrollView(
              child:Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:40),
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,5,0,10),
                      child: StreamBuilder(
                        stream: bloc.userStream,
                        builder: (context,snapshoot) => TextField(
                          controller: _userController,
                          decoration: InputDecoration(
                              labelText: 'Username',
                              errorText: snapshoot.hasError? snapshoot.error : null,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              prefixIcon: Container(
                                width: 50,
                                child: Icon(Icons.account_circle_outlined),
                              )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,5,0,10),
                      child:Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children:<Widget>[
                          StreamBuilder(
                            stream: bloc.passStream,
                            builder:(context,snapshot) => TextField(
                              controller: _passController,
                              obscureText: !seePass,
                              decoration: InputDecoration(
                                  errorText: snapshot.hasError? snapshot.error : null,
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black,width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  prefixIcon: Container(
                                    width: 50,
                                    child: Icon(Icons.lock_outline),
                                  )
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: Showpass,
                              child:Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  child: Icon(seePass? Icons.visibility : Icons.visibility_off)
                              )
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,5,0,10),
                      child: StreamBuilder(
                        stream: bloc.emailStream,
                        builder: (context,snapshot) => TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              errorText: snapshot.hasError? snapshot.error : null,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black,width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              prefixIcon: Container(
                                width: 50,
                                child: Icon(Icons.mail_outline),
                              )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0,5,0,10),
                        child: StreamBuilder(
                          stream: bloc.firstStream,
                          builder: (context,snapshot)=>TextField(
                            controller: _firstController,
                            decoration: InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black,width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                prefixIcon: Container(
                                  width: 50,
                                  child: Icon(Icons.drive_file_rename_outline),
                                )
                            ),
                          ),
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0,5,0,40),
                        child: StreamBuilder(
                          stream: bloc.lastStream,
                          builder: (context,snapshot) => TextField(
                            controller: _lastController,
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black,width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                prefixIcon: Container(
                                  width: 50,
                                  child: Icon(Icons.drive_file_rename_outline),
                                )
                            ),
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: SizedBox(
                        height: 45,
                        width: 135,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              )
                          ),
                          onPressed: () => SignUp(),
                          child: Text('Đăng ký',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:30),
                      child: TextButton(
                          onPressed: (){Navigator.pop(context);},
                          child: Text('Đăng nhập',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),)
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  SignUp(){
    if(bloc.CheckRegister(_userController.text, _passController.text, _emailController.text,_firstController.text,_lastController.text)){
      return showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('Đăng ký thành công'),
        content: Image.asset('assets/check1.jpg',height: 50,),
        actions: <Widget>[
          ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage() ));}, child: Text('Đăng nhập'))
        ],
      ));
    }
  }

  Showpass(){
    setState(() {
      seePass = !seePass;
    });
  }
}