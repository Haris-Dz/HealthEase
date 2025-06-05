// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecordEntry _$MedicalRecordEntryFromJson(Map<String, dynamic> json) =>
    MedicalRecordEntry()
      ..medicalRecordEntryId = (json['medicalRecordEntryId'] as num?)?.toInt()
      ..medicalRecordId = (json['medicalRecordId'] as num?)?.toInt()
      ..doctorId = (json['doctorId'] as num?)?.toInt()
      ..entryType = json['entryType'] as String?
      ..entryDate = json['entryDate'] as String?
      ..title = json['title'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$MedicalRecordEntryToJson(MedicalRecordEntry instance) =>
    <String, dynamic>{
      'medicalRecordEntryId': instance.medicalRecordEntryId,
      'medicalRecordId': instance.medicalRecordId,
      'doctorId': instance.doctorId,
      'entryType': instance.entryType,
      'entryDate': instance.entryDate,
      'title': instance.title,
      'description': instance.description,
    };
