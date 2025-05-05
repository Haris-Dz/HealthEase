import 'package:healthease_mobile/models/appointment_type.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class AppointmentTypesProvider extends BaseProvider<AppointmentType> {
  AppointmentTypesProvider() : super("AppointmentType");

  @override
  AppointmentType fromJson(data) {
    // TODO: implement fromJson
    return AppointmentType.fromJson(data);
  }
}
