import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:q_and_a/common/apifunctions/global.dart';
import 'package:q_and_a/common/functions/getToken.dart';
import 'package:q_and_a/common/functions/saveCurrentLogin.dart';
import 'package:q_and_a/common/functions/showDialogSingleButton.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<String> requestQuestionAPI(BuildContext context, String content) async {
  String token = await getToken();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int userId = preferences.getInt("LastUserId");

  Map<String, String> body = {
    'content': content,
  };

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    HttpHeaders.authorizationHeader: token
  };

  var httpClient = new Client();

  var jsonQuestion = json.encode(body);

  final response = await httpClient.post(
      url + "/questions/" + userId.toString(),
      body: jsonQuestion,
      headers: headers);

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    return responseJson.toString();
  } else {
    final responseJson = json.decode(response.body);
    showDialogSingleButton(
        context, "Error on share question", "Contact the support", "OK");
    return null;
  }
}
