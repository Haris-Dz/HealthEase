import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class DoctorsProvider extends BaseProvider<Doctor> {
  DoctorsProvider() : super("Doctor");

  @override
  Doctor fromJson(data) {
    // TODO: implement fromJson
    return Doctor.fromJson(data);
  }
}