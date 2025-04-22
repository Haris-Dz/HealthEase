
import 'package:healthease_desktop/models/doctor.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class DoctorsProvider extends BaseProvider<Doctor> {
  DoctorsProvider() : super("Doctor");
  @override
  Doctor fromJson(data) {
    // TODO: implement fromJson
    return Doctor.fromJson(data);
  }
}