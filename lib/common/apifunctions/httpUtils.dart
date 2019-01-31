import 'dart:convert';

import 'package:http/http.dart';

post(String url, Map<String, String> body) async {
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var httpClient = new Client();

  var jsonUser = json.encode(body);
//  final response = await http.post(
//      url + "/auth", body: body
//  );

  return await httpClient.post(url + "/auth", body: jsonUser, headers: headers);
}
