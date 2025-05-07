// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_doctor_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientDoctorFavorite _$PatientDoctorFavoriteFromJson(
  Map<String, dynamic> json,
) =>
    PatientDoctorFavorite()
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..doctorId = (json['doctorId'] as num?)?.toInt()
      ..createdAt = json['createdAt'] as String?
      ..doctor =
          json['doctor'] == null
              ? null
              : Doctor.fromJson(json['doctor'] as Map<String, dynamic>);

Map<String, dynamic> _$PatientDoctorFavoriteToJson(
  PatientDoctorFavorite instance,
) => <String, dynamic>{
  'patientId': instance.patientId,
  'doctorId': instance.doctorId,
  'createdAt': instance.createdAt,
  'doctor': instance.doctor,
};
