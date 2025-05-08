import 'dart:convert';

import 'package:healthease_desktop/models/doctor.dart';
import 'package:healthease_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class DoctorsProvider extends BaseProvider<Doctor> {
  DoctorsProvider() : super("Doctor");
  @override
  Doctor fromJson(data) {
    // TODO: implement fromJson
    return Doctor.fromJson(data);
  }

  Future ChangeState(int id, String state) async {
    var endpoint = "Doctor/${id}/$state";
    var baseUrl = BaseProvider.baseUrl;
    var url = "$baseUrl$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
    print("$uri");
    if (isValidResponse(response)) {
      if (response.body.isEmpty) return fromJson({});
      var data = jsonDecode(response.body);
      return fromJson(data);
    }
  }
}
