import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:q_and_a/common/apifunctions/global.dart';
import 'package:q_and_a/common/apifunctions/httpUtils.dart';
import 'package:q_and_a/common/functions/getToken.dart';
import 'package:q_and_a/common/platform/platformScaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int splashDuration = 2;

  startSplash() async {
    String token = await getToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var httpClient = new Client();

    final response =
        await httpClient.post(url + "/refresh/" + token, headers: headers);

    if (response.statusCode == 200) {
      var body = response.body;
      return Timer(Duration(seconds: splashDuration), () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Navigator.of(context).pushReplacementNamed('/HomeScreen');
      });
    } else {
      return Timer(Duration(seconds: splashDuration), () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Navigator.of(context).pushReplacementNamed('/LoginScreen');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startSplash();
  }

  @override
  Widget build(BuildContext context) {
    var drawer = Drawer();

    return PlatformScaffold(
        drawer: drawer,
        body: Container(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    alignment: FractionalOffset(0.5, 0.3),
                    child: Text(
                      "Questions & Answers",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 30.0),
                  child: Text(
                    "© Developed by Quaresma 2019",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )));
  }
}
