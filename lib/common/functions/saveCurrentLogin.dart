import 'package:q_and_a/model/json/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveCurrentLogin(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = User.fromJson(responseJson).name;
  } else {
    user = "";
  }
  var token = (responseJson != null && responseJson.isNotEmpty)
      ? User.fromJson(responseJson).token
      : "";
  var email = (responseJson != null && responseJson.isNotEmpty)
      ? User.fromJson(responseJson).email
      : "";
  var id = (responseJson != null && responseJson.isNotEmpty)
      ? User.fromJson(responseJson).userId
      : 0;

  await preferences.setString(
      'LastUser', (user != null && user.length > 0) ? user : "");
  await preferences.setString(
      'LastToken', (token != null && token.length > 0) ? token : "");
  await preferences.setString(
      'LastEmail', (email != null && email.length > 0) ? email : "");
  await preferences.setInt('LastUserId', (id != null && id > 0) ? id : 0);
}
