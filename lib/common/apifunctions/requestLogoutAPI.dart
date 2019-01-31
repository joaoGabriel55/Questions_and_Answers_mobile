
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:q_and_a/common/functions/saveLogout.dart';
import 'package:q_and_a/model/json/User.dart';

Future<User> requestLogoutAPI(BuildContext context) async {
  saveLogout();
  return null;
}
