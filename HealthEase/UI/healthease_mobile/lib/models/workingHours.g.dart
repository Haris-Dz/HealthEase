// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workingHours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingHours _$WorkingHoursFromJson(Map<String, dynamic> json) =>
    WorkingHours()
      ..workingHoursId = (json['workingHoursId'] as num?)?.toInt()
      ..day = (json['day'] as num?)?.toInt()
      ..startTime = json['startTime'] as String?
      ..endTime = json['endTime'] as String?;

Map<String, dynamic> _$WorkingHoursToJson(WorkingHours instance) =>
    <String, dynamic>{
      'workingHoursId': instance.workingHoursId,
      'day': instance.day,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
