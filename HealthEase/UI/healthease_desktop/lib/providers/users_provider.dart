import 'dart:convert';

import 'package:healthease_desktop/models/user.dart';
import 'package:healthease_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends BaseProvider<User> {
  UsersProvider() : super("User");

  @override
  User fromJson(data) {
    // TODO: implement fromJson
    return User.fromJson(data);
  }

  Future<User> login(String username, String password) async {
    var url =
        "${BaseProvider.baseUrl}User/Login?username=${username}&password=${password}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);
    if (response.body == "") {
      throw new Exception("Wrong username or password");
    }
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
}