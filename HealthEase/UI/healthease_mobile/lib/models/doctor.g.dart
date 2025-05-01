// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) =>
    Doctor()
      ..doctorId = (json['doctorId'] as num?)?.toInt()
      ..profilePicture = json['profilePicture'] as String?
      ..biography = json['biography'] as String?
      ..title = json['title'] as String?
      ..user =
          json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>)
      ..doctorSpecializations =
          (json['doctorSpecializations'] as List<dynamic>?)
              ?.map((e) => Specialization.fromJson(e as Map<String, dynamic>))
              .toList()
      ..workingHours =
          (json['workingHours'] as List<dynamic>?)
              ?.map((e) => WorkingHours.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
  'doctorId': instance.doctorId,
  'profilePicture': instance.profilePicture,
  'biography': instance.biography,
  'title': instance.title,
  'user': instance.user,
  'doctorSpecializations': instance.doctorSpecializations,
  'workingHours': instance.workingHours,
};
