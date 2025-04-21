
import 'package:healthease_desktop/models/user_role.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? username;
  List<UserRole>? userRoles;

  User();

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}