// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) =>
    UserRole()
      ..userRoleId = (json['userRoleId'] as num?)?.toInt()
      ..roleId = (json['roleId'] as num?)?.toInt()
      ..userId = (json['userId'] as num?)?.toInt()
      ..role =
          json['role'] == null
              ? null
              : Role.fromJson(json['role'] as Map<String, dynamic>);

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
  'userRoleId': instance.userRoleId,
  'roleId': instance.roleId,
  'userId': instance.userId,
  'role': instance.role,
};
