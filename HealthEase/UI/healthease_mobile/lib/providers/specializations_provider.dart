import 'package:healthease_mobile/models/specialization.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class SpecializationsProvider extends BaseProvider<Specialization> {
  SpecializationsProvider() : super("Specialization");

  @override
  Specialization fromJson(data) {
    // TODO: implement fromJson
    return Specialization.fromJson(data);
  }
}