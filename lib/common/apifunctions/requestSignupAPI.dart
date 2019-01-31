import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:q_and_a/common/apifunctions/global.dart';
import 'package:q_and_a/common/functions/saveCurrentLogin.dart';
import 'package:q_and_a/common/functions/showDialogSingleButton.dart';
import 'dart:convert';

import 'package:q_and_a/model/json/User.dart';

Future<String> requestSignupAPI(
    BuildContext context, String name, String email, String password) async {
  Map<String, String> body = {
    'nome': name,
    'email': email,
    'password': password,
  };

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var httpClient = new Client();

  var jsonUser = json.encode(body);

  final response =
      await httpClient.post(url + "/signup", body: jsonUser, headers: headers);

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    Navigator.of(context).pushReplacementNamed('/LoginScreen');
    return responseJson.toString();
  } else {
    final responseJson = json.decode(response.body);
    showDialogSingleButton(
        context,
        "Unable to register",
        "Please try again or contact your support representative.",
        "OK");
    return null;
  }
}
