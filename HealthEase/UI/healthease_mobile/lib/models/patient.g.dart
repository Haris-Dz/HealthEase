// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) =>
    Patient()
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..firstName = json['firstName'] as String?
      ..lastName = json['lastName'] as String?
      ..email = json['email'] as String?
      ..phoneNumber = json['phoneNumber'] as String?
      ..username = json['username'] as String?
      ..profilePicture = json['profilePicture'] as String?
      ..registrationDate = json['registrationDate'] as String?;

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'patientId': instance.patientId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'username': instance.username,
  'profilePicture': instance.profilePicture,
  'registrationDate': instance.registrationDate,
};
