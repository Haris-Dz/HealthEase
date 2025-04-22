import 'package:healthease_desktop/models/working_hours.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class WorkingHoursProvider extends BaseProvider<WorkingHours> {
  WorkingHoursProvider() : super("WorkingHours");

  @override
  WorkingHours fromJson(data) {
    return WorkingHours.fromJson(data);
  }
}
