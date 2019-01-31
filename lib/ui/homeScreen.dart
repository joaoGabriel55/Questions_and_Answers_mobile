import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:q_and_a/common/apifunctions/requestLogoutAPI.dart';
import 'package:q_and_a/common/platform/platformScaffold.dart';
import 'package:q_and_a/common/widgets/basicDrawer.dart';
import 'package:q_and_a/ui/TesteObjs.dart';
import 'package:q_and_a/ui/loginScreen.dart';
import 'package:q_and_a/ui/questionsAndAnswers/questionsListAll.dart';
import 'package:q_and_a/ui/questionsAndAnswers/questionsListByUser.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/HomeScreen");
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'My Questions'.toUpperCase()),
                Tab(text: 'All Questions'.toUpperCase()),
                Tab(text: 'Teste'.toUpperCase()),
              ],
            ),
            title: Text('Home'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 8.0, 5.0),
                  child: new IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      requestLogoutAPI(context);
                      Navigator.of(context).pushReplacementNamed('/LoginScreen');
                    },
                  ))
            ],
          ),
          body: TabBarView(
            children: [
              QuestionsListByUser(),
              QuestionsListAll(),
              Test()
            ],
          ),
        ),
      ),
    );
  }
}
