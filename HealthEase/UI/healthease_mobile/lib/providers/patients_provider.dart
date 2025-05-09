import 'dart:convert';
import 'package:healthease_mobile/models/patient.dart';
import 'package:healthease_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class PatientProvider extends BaseProvider<Patient> {
  PatientProvider() : super("Patient");

  @override
  Patient fromJson(data) {
    // TODO: implement fromJson
    return Patient.fromJson(data);
  }

  Future<Patient> login(String username, String password) async {
    var url =
        "${BaseProvider.baseUrl}Patient/Login?username=${username}&password=${password}";
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

  Future<Patient> register(Map<String, dynamic> request) async {
    var url = "${BaseProvider.baseUrl}Patient/Register";
    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(request);
    var headers = {"Content-Type": "application/json"};
    var response = await http.post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Registration failed");
    }
  }
}
