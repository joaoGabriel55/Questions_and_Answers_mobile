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

Future<User> requestLoginAPI(
    BuildContext context, String email, String password) async {
  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var httpClient = new Client();

  var jsonUser = json.encode(body);
//  final response = await http.post(
//      url + "/auth", body: body
//  );

  final response =
      await httpClient.post(url + "/auth", body: jsonUser, headers: headers);

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    var user = new User.fromJson(responseJson);

    saveCurrentLogin(responseJson);
    Navigator.of(context).pushReplacementNamed('/HomeScreen');

    return User.fromJson(responseJson);
  } else {
    final responseJson = json.decode(response.body);

    saveCurrentLogin(responseJson);
    showDialogSingleButton(
        context,
        "Unable to Login",
        "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.",
        "OK");
    return null;
  }
}
