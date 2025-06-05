// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) =>
    MedicalRecord()
      ..medicalRecordId = (json['medicalRecordId'] as num?)?.toInt()
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..notes = json['notes'] as String?
      ..entries =
          (json['entries'] as List<dynamic>?)
              ?.map(
                (e) => MedicalRecordEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList();

Map<String, dynamic> _$MedicalRecordToJson(MedicalRecord instance) =>
    <String, dynamic>{
      'medicalRecordId': instance.medicalRecordId,
      'patientId': instance.patientId,
      'notes': instance.notes,
      'entries': instance.entries,
    };
