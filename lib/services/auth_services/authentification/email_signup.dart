import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopify_image/services/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';



class EmailSignUp extends StatefulWidget {
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =  FirebaseDatabase.instance.reference().child("Users");

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      "assets/images/shopify-bag.png",
      fit: BoxFit.fill,
      width: 80.0,
      height: 80.0,
    );

    final createMsg = Column(
      children: <Widget>[
        Text(
          'Create an Account with us for free',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
        ),
      ],
    );

    return Scaffold(
        backgroundColor: Color(0xFFE0F7FA),
        appBar: AppBar(title: Text("Sign Up to Tutor App")),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 40.0)),
                  logo,
                  Padding(padding: EdgeInsets.only(top: 40.0)),
                  createMsg,
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
                    child: TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Mandatory Field, Enter Your Full Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Mandatory Field, Enter an Email Address';
                        } else if (!value.contains('@')) {
                          return 'Your email lacks an @ sign. Please include a valid email address into this field';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Mandatory Field, Enter Password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            color: Colors.lightBlue,
                            onPressed: () {
                              print(_formKey.currentState.validate());

                              if (_formKey.currentState.validate()) {
                                setState(() {

                                  isLoading = true;
                                });
                                registerToFb();
                              }
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  )
            ]))));
  }

  void registerToFb() {
    print(emailController.text);
    print( passwordController.text);
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      dbRef.child(result.user.uid).set({
        "email": emailController.text,
        "name": nameController.text
      }).then((res) {
        print("setting");
        setState(() {
          isLoading = false;

        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
        );
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
