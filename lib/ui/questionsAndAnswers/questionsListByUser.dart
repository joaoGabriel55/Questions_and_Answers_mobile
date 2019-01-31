import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:q_and_a/common/apifunctions/global.dart';
import 'package:q_and_a/common/apifunctions/requestQuestionAPI.dart';
import 'package:q_and_a/common/functions/getToken.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MaterialApp(home: QuestionsListByUser()));
}

class QuestionsListByUser extends StatefulWidget {
  @override
  _QuestionsListByUser createState() => new _QuestionsListByUser();
}

class _QuestionsListByUser extends State<QuestionsListByUser> {
  Map<String, dynamic> data;
  List dataList;

  int size = 6;
  bool loadMore = false;

  final TextEditingController questionController = TextEditingController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<String> getData() async {
    refreshKey.currentState?.show(atTop: false);
    String token = await getToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("LastUserId");
    var response = await Http.get(
        //Encode the URL
        Uri.encodeFull(
            url + "/questions?page=0&size="+ this.size.toString() +"&userId=" + userId.toString()),
        //Somente aceitar JSON format
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: token
        });

    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      print(convertDataToJson);
      data = convertDataToJson;
      dataList = data["data"];
    });

    this.size = this.size + 6;

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.questionController.text = "";
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          tooltip: "Share new question",
          backgroundColor: Colors.blue,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text("Share your question"),
                      content: TextFormField(
                        controller: questionController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Type your question...",
                            labelText: "Your Question"),
                        maxLines: 3,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () =>
                              Navigator.pop(context, 'Cancel'.toUpperCase()),
                        ),
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            if (questionController.text.trim() != "") {
                              Navigator.pop(context, 'OK');
                            }
                          },
                        )
                      ],
                    )).then((returnVal) {
              if (questionController.text.trim() != "") {
                requestQuestionAPI(context, questionController.text);
              }
//            } else {
//              Scaffold.of(context).showSnackBar(SnackBar(
//                content: Text("Yo clicked $returnVal"),
//                action: SnackBarAction(label: 'OK', onPressed: () {}),
//              ));
//            }
              questionController.text = "";
            });
          },
        ),
        body: new Container(
          child: new Column(children: <Widget>[
            new Expanded(
                child: RefreshIndicator(

                    child: new ListView.builder(
                      itemCount: dataList == null ? 0 : dataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                          child: new Container(
                              padding: EdgeInsets.all(20),
                              child: new Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                          dataList[index]['questionContent']),
                                    ],
                                  ),
                                  new Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 16, 0, 0)),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      new Text(
                                        "Author: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      new Text(dataList[index]['userName']),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                    onRefresh: this.getData)),
          ]),
        ));
  }
}
