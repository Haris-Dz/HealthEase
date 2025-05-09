// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) =>
    Doctor()
      ..doctorId = (json['doctorId'] as num?)?.toInt()
      ..biography = json['biography'] as String?
      ..title = json['title'] as String?
      ..stateMachine = json['stateMachine'] as String?
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
  'biography': instance.biography,
  'title': instance.title,
  'stateMachine': instance.stateMachine,
  'user': instance.user,
  'doctorSpecializations': instance.doctorSpecializations,
  'workingHours': instance.workingHours,
};
