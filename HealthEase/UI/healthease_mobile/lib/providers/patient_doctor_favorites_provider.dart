import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:healthease_mobile/models/patient_doctor_favorite.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class PatientDoctorFavoritesProvider
    extends BaseProvider<PatientDoctorFavorite> {
  PatientDoctorFavoritesProvider() : super("PatientDoctorFavorite");

  @override
  PatientDoctorFavorite fromJson(data) {
    return PatientDoctorFavorite.fromJson(data);
  }

  Future<PatientDoctorFavorite?> toggleFavorite(
    int patientId,
    int doctorId,
  ) async {
    var url = "${BaseProvider.baseUrl}PatientDoctorFavorite/toggle";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({"patientId": patientId, "doctorId": doctorId}),
    );

    if (response.body.isEmpty) return null;

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to toggle favorite.");
    }
  }

  Future<List<PatientDoctorFavorite>> getByPatientId(int patientId) async {
    var url =
        "${BaseProvider.baseUrl}PatientDoctorFavorite/by-patient/$patientId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var list = jsonDecode(response.body) as List;
      return list.map((item) => fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch favorites.");
    }
  }
}
