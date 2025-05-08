import 'dart:convert';

import 'package:healthease_desktop/models/appointment.dart';
import 'package:healthease_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class AppointmentsProvider extends BaseProvider<Appointment> {
  AppointmentsProvider() : super("Appointment");
  @override
  Appointment fromJson(data) {
    // TODO: implement fromJson
    return Appointment.fromJson(data);
  }

  Future<List<String>> getStatusOptions() async {
    final response = await http.get(
      Uri.parse("${BaseProvider.baseUrl}Appointment/status-options"),
      headers: createHeaders(),
    );
    print(response);
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load status options");
    }
  }
}
