import 'package:healthease_desktop/models/specialization.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class SpecializationsProvider extends BaseProvider<Specialization> {
  SpecializationsProvider() : super("Specialization");

  @override
  Specialization fromJson(data) {
    return Specialization.fromJson(data);
  }
}
