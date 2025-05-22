import 'dart:convert';

import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class DoctorsProvider extends BaseProvider<Doctor> {
  DoctorsProvider() : super("Doctor");

  @override
  Doctor fromJson(data) {
    // TODO: implement fromJson
    return Doctor.fromJson(data);
  }

  Future<List<Doctor>> getRecommended() async {
    var url =
        "${BaseProvider.baseUrl}Doctor/recommended?patientId=${AuthProvider.patientId}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var obj = jsonDecode(response.body);

      if (obj is List) {
        List<Doctor> list = obj.map((item) => Doctor.fromJson(item)).toList();
        return list;
      } else {
        throw new Exception("Expected JSON list");
      }
    }
    throw new Exception("Error");
  }
}
