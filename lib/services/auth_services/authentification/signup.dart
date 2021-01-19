import 'package:flutter/material.dart';

import 'email_login.dart';
import 'email_signup.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      "assets/images/emirates.png",
      fit: BoxFit.fill,
      width: 100.0,
      height: 100.0,
    );

    final buttonSize = MediaQuery.of(context);

    final choiceMsg = Column(
      children: <Widget>[
        Text(
          'Welcome to Tutor App',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17.0),
        ),
      ],
    );

    final registerButton = Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(14.0),
      color: Colors.blue[400],
      child: MaterialButton(
        minWidth: buttonSize.size.width / 1.8,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          'Join us',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmailSignUp()),
          );
        },
      ),
    );

    final loginButton = Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(14.0),
      color: Colors.blue[400],
      child: MaterialButton(
        minWidth: buttonSize.size.width / 1.8,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmailLogIn()),
          );
        },
      ),
    );

    return Scaffold(
        backgroundColor: Color(0xFF484848),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logo,
                Padding(padding: EdgeInsets.only(top: 50)),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Welcome to Tutor App!!",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                choiceMsg,
                Padding(padding: EdgeInsets.only(top: 40.0)),
                registerButton,
                Padding(padding: EdgeInsets.only(top: 40.0)),
                loginButton,
              ]),
        ));
  }
}
