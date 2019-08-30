import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:login_persistence/src/app_bloc.dart';
import 'package:login_persistence/src/app_module.dart';
import 'package:login_persistence/src/home/home_module.dart';

import 'login_bloc.dart';
import 'login_module.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = LoginModule.to.getBloc<LoginBloc>();
    final _appBloc = AppModule.to.getBloc<AppBloc>();
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Login',
        ),
        centerTitle: true,
        backgroundColor: Color(0xff036b80),
      ),
      body: Material(
        child: StreamBuilder<Object>(
          stream: _appBloc.outUser,
          builder: (context, snapshot) {
            return Center(
              child: SizedBox(
                width: _screenWidth / 1.2,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(1),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Image.asset('assets/sample_logo.png'),
                      ),
                      if (!snapshot.hasData) ...[
                        Container(margin: EdgeInsets.only(top: 10)),
                        usernameField(_bloc),
                        Container(margin: EdgeInsets.only(top: 10)),
                        passwordField(_bloc),
                        Container(margin: EdgeInsets.only(top: 15)),
                        submitButton(_bloc, context),
                      ] else ...[
                        entrarNovButton(context),
                        sairButton(context, _appBloc)
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SizedBox entrarNovButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/noticias'),
        child: Text('LOGIN AGAIN'),
        textColor: Colors.white,
        color: Color(0xff036b80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }

  SizedBox sairButton(BuildContext context, AppBloc bloc) {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () => bloc.inUser.add(null),
        child: Text('CLOSE SESSION'),
        textColor: Color(0xff036b80),
        borderSide: BorderSide(color: Color(0xff036b80), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }

  Widget usernameField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.username,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeUsername,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Color(0xff27d3f5).withOpacity(0.1),
            filled: true,
            labelText: 'Username',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          obscureText: true,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            fillColor: Color(0xff27d3f5).withOpacity(0.1),
            filled: true,
            labelText: 'Password',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget submitButton(LoginBloc bloc, BuildContext context) {
    return StreamBuilder<Object>(
      stream: bloc.outLoading,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else
          return StreamBuilder(
            stream: bloc.submitValid,
            builder: (_, snapshot) {
              return SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text(
                    "LOGIN",
                  ),
                  textColor: Colors.white,
                  color: Color(0xff036b80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  onPressed: () async {
                    if (snapshot.hasData) {
                      String result = await bloc.submit();
                      if (result.contains("true")) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomeModule()));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(result),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              );
            },
          );
      },
    );
  }
}
