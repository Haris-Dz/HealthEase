import 'dart:convert';
import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class PatientsProvider extends BaseProvider<Patient> {
  PatientsProvider() : super("Patient");
  @override
  Patient fromJson(data) {
    // TODO: implement fromJson
    return Patient.fromJson(data);
  }
}