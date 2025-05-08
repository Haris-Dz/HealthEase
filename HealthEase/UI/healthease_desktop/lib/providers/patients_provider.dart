import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class PatientsProvider extends BaseProvider<Patient> {
  PatientsProvider() : super("Patient");
  @override
  Patient fromJson(data) {
    // TODO: implement fromJson
    return Patient.fromJson(data);
  }
}
