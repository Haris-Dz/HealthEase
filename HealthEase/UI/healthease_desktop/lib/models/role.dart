import 'package:json_annotation/json_annotation.dart';
part 'role.g.dart';

@JsonSerializable()
class Role {
  int? roleId;
  String? roleName;
  Role();

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}