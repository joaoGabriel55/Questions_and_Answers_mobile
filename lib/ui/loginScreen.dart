import 'dart:async';

import 'package:flutter/material.dart';
import 'package:q_and_a/common/functions/getToken.dart';
import 'package:q_and_a/common/functions/showDialogSingleButton.dart';
import 'package:q_and_a/common/apifunctions/requestLoginAPI.dart';
import 'package:q_and_a/common/platform/platformScaffold.dart';
import 'package:q_and_a/common/widgets/basicDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

const URL = "http://www.google.com";

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _email;
  String _password;

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      showDialogSingleButton(
          context,
          "Unable to reach your website.",
          "Currently unable to reach the website $URL. Please try again at a later time.",
          "OK");
    }
  }

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/LoginScreen");
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        backgroundColor: Colors.white,
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: Container(
                child: new Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 30.0),
                      child: Text(
                        "Questions & Answers",
                        style: TextStyle(fontSize: 40.0, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    )),
                new Container(
                    margin: new EdgeInsets.all(15.0),
                    child: new Form(key: _formKey, child: FormUI())
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 25, 0.0, 0.0),
                  child: Container(
                      height: 65.0,
                      child: new GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/Signup');
                        },
                        child: new Text(
                          "Doesn't you have an account? Click here!",
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Colors.blueAccent, fontSize: 16),
                        ),
                      )),
                ),
              ],
            )),
          ),
        ));
  }

  Widget FormUI() {
    return new Column(
      children: <Widget>[
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
                  requestLoginAPI(context, _email, _password);
                }
              },
              child: Text("Sign in",
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
