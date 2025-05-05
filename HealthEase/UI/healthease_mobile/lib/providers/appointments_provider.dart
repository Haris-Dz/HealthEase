import 'package:healthease_mobile/models/appointment.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class AppointmentsProvider extends BaseProvider<Appointment> {
  AppointmentsProvider() : super("Appointment");

  @override
  Appointment fromJson(data) {
    // TODO: implement fromJson
    return Appointment.fromJson(data);
  }
}
