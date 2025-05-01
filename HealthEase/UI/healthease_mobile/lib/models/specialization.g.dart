// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Specialization _$SpecializationFromJson(Map<String, dynamic> json) =>
    Specialization()
      ..specializationId = (json['specializationId'] as num?)?.toInt()
      ..name = json['name'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$SpecializationToJson(Specialization instance) =>
    <String, dynamic>{
      'specializationId': instance.specializationId,
      'name': instance.name,
      'description': instance.description,
    };
