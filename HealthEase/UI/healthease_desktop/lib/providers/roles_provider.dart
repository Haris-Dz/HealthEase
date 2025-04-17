import 'package:healthease_desktop/models/role.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class RolesProvider extends BaseProvider<Role> {
  RolesProvider() : super("Role");

  @override
  Role fromJson(data) {
    return Role.fromJson(data);
  }
}
