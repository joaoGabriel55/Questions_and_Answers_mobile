import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:q_and_a/common/apifunctions/global.dart';
import 'package:q_and_a/common/apifunctions/requestAnswerAPI.dart';
import 'package:q_and_a/common/apifunctions/requestQuestionAPI.dart';
import 'package:q_and_a/common/functions/getToken.dart';
import 'package:q_and_a/model/json/AnswersUsers.dart';
import 'package:q_and_a/model/json/QuestionsAndAnswers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MaterialApp(home: QuestionsListByUser()));
}

class QuestionsListByUser extends StatefulWidget {
  @override
  _QuestionsListByUser createState() => new _QuestionsListByUser();
}

class _QuestionsListByUser extends State<QuestionsListByUser> {
  @override
  void initState() {
    super.initState();
    this.getData();
  }

  int size = 6;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Map<String, dynamic> data;
  List dataList;

  List<QuestionsAndAnswers> questionsAndAnswersList = [];

  final TextEditingController questionController = TextEditingController();

  Future<String> getData() async {
    refreshKey.currentState?.show(atTop: false);
    String token = await getToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int userId = preferences.getInt("LastUserId");
    var response = await Http.get(
        //Encode the URL
        Uri.encodeFull(url +
            "/questions/questionsanswers?page=0&size=" +
            this.size.toString() +
            "&userId=" +
            userId.toString()),
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

    List<AnswersUsers> listAnswers = [];
    QuestionsAndAnswers questionsAndAnswers;
    AnswersUsers answer;

    questionsAndAnswersList = [];

    for (var i = 0; i < dataList.length; i++) {
      List answerUserListAux = dataList[i]["answerUserList"];
      if (answerUserListAux.length > 0) {
        for (var j = 0; j < answerUserListAux.length; j++) {
          answer = AnswersUsers(
              dataList[i]["answerUserList"][j]["answerId"],
              dataList[i]["answerUserList"][j]["answerContent"],
              dataList[i]["answerUserList"][j]["authorId"],
              dataList[i]["answerUserList"][j]["author"]);
          listAnswers.add(answer);
        }
      }
      questionsAndAnswers = QuestionsAndAnswers(
          dataList[i]['userId'],
          dataList[i]['userName'],
          dataList[i]['questionId'],
          dataList[i]['questionContent'],
          listAnswers);
      listAnswers = [];
      questionsAndAnswersList.add(questionsAndAnswers);
    }

    this.size = this.size + 6;

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                      child:
                          _buildTiles(questionsAndAnswersList[index], context));
                },
                itemCount: questionsAndAnswersList == null
                    ? 0
                    : questionsAndAnswersList.length,
              ),
              onRefresh: this.getData,
            ))
          ])),
        ));
  }
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
_buildTiles(QuestionsAndAnswers questions, BuildContext context) {
  _buildExpandableContent(QuestionsAndAnswers covariant) {
    List<Widget> columnContent = [];

    final TextEditingController answerController = TextEditingController();

    for (AnswersUsers answer in covariant.answersUser)
      columnContent.add(new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: Container(
              height: 1.0,
              width: 500.0,
              color: Color.fromRGBO(230, 230, 230, 1.0),
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            ),
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
          new Container(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    answer.answerContent,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                ]),
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
          new Container(
            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  "Author: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  answer.author,
                ),
              ],
            ),
          )
        ],
      ));

    columnContent.add(
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        child: Container(
          height: 1.0,
          width: 500.0,
          color: Color.fromRGBO(230, 230, 230, 1.0),
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        ),
      ),
    );
    columnContent.add(new Column(
      children: <Widget>[
        new RaisedButton(
          padding: EdgeInsets.fromLTRB(100.0, 8.0, 100.0, 8.0),
          child: Text(
            "Answer this question".toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          color: Colors.blue,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(covariant.questionContent),
                      content: TextFormField(
                        controller: answerController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Type your answer...",
                            labelText: "Your answer"),
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
                            if (answerController.text.trim() != "") {
                              Navigator.pop(context, 'OK');
                            }
                          },
                        )
                      ],
                    )).then((returnVal) {
              if (answerController.text.trim() != "") {
                requestAnswerAPI(
                    context, answerController.text, covariant.questionId);
              }
            });
          },
        ),
        new Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
      ],
    ));

    return columnContent;
  }

  return new ExpansionTile(
    trailing: null,
    title: new Column(
      children: <Widget>[
        new Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
        new Container(
            alignment: AlignmentDirectional(-1, 0),
            child: new Column(children: <Widget>[
              new Text(
                questions.questionContent,
                style: new TextStyle(fontSize: 16.0),
              ),
            ])),
        new Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Text(
              "Author: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            new Text(
              questions.userName,
            ),
          ],
        ),
        new Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 8)),
      ],
    ),
    children: <Widget>[
      new Column(
        children: _buildExpandableContent(questions),
      ),
    ],
  );
}
