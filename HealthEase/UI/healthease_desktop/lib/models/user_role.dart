import 'package:healthease_desktop/models/role.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  int? userRoleId;
  int? roleId;
  int? userId;
  Role? role;
  UserRole();

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}