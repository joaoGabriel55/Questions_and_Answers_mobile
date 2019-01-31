import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:q_and_a/common/apifunctions/requestLoginAPI.dart';
import 'package:q_and_a/common/apifunctions/requestLogoutAPI.dart';
import 'package:q_and_a/common/apifunctions/requestSignupAPI.dart';
import 'package:q_and_a/common/functions/showDialogSingleButton.dart';
import 'package:q_and_a/common/platform/platformScaffold.dart';
import 'package:q_and_a/common/widgets/basicDrawer.dart';
import 'package:q_and_a/ui/loginScreen.dart';
import 'package:q_and_a/ui/questionsAndAnswers/questionsListByUser.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreen createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passKey = GlobalKey<FormFieldState>();

  String _name;
  String _email;
  String _password;
  String _confirmPassword;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/LoginScreen', (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushReplacementNamed('/LoginScreen');
          }
        },
        child: PlatformScaffold(
            backgroundColor: Colors.white,
            body: new SingleChildScrollView(
              child: new Container(
                margin: new EdgeInsets.all(15.0),
                child: Container(
                    child: new Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      new IconButton(
                        alignment: Alignment(-4, 4),
                        icon: Icon(Icons.arrow_back),
                        color: Colors.blueAccent,
                        onPressed: () {
                          requestLogoutAPI(context);
                          Navigator.of(context)
                              .pushReplacementNamed('/LoginScreen');
                        },
                      ),
                    ]),
                    Container(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 30.0),
                          child: Text(
                            "Sign Up",
                            style:
                                TextStyle(fontSize: 40.0, color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    new Container(
                        margin: new EdgeInsets.all(15.0),
                        child: new Form(key: _formKey, child: FormUI()))
                  ],
                )),
              ),
            )
        )
    );
  }

  Widget FormUI() {
    return new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: TextFormField(
            validator: validateName,
            onSaved: (String val) {
              _name = val;
            },
            decoration: InputDecoration(
                labelText: "Name",
                hintText: "Type your name",
                fillColor: Colors.black,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: TextFormField(
            validator: validateEmail,
            onSaved: (String val) {
              _email = val;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: "Email",
                hintText: "Type your email",
                fillColor: Colors.black,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: TextFormField(
            key: passKey,
            validator: validatePassword,
            onSaved: (String val) {
              _password = val;
            },
            decoration: InputDecoration(
                labelText: "Password",
                hintText: 'Type your password',
                fillColor: Colors.black,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            obscureText: true,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: TextFormField(
            validator: validateConfirmPassword,
            onSaved: (String val) {
              _confirmPassword = val;
            },
            decoration: InputDecoration(
                labelText: "Password confirmation",
                hintText: 'Repeat your password',
                fillColor: Colors.black,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            obscureText: true,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
          child: Container(
            height: 1.0,
            width: 500.0,
            color: Colors.grey,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
          child: Container(
            height: 65.0,
            width: 500.0,
            child: RaisedButton(
              onPressed: () {
                if (_validateInputs()) {
                  requestSignupAPI(context, _name, _email, _password);
                  showDialogSingleButton(
                      context,
                      "Successful user registration",
                      "Now, you can share questions and answer questions!",
                      "OK");
                }
              },
              child: Text("Register",
                  style: TextStyle(color: Colors.white, fontSize: 22.0)),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
        )
      ],
    );
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    var result =
        value.length < 4 ? "Password should have at least 4 characters" : null;
    return result;
  }

  String validateConfirmPassword(String value) {
    var password = passKey.currentState.value;
    return value == password ? null : "Confirm Password should match password";
  }

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }
}
