// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentType _$AppointmentTypeFromJson(Map<String, dynamic> json) =>
    AppointmentType()
      ..appointmentTypeId = (json['appointmentTypeId'] as num?)?.toInt()
      ..name = json['name'] as String?
      ..price = (json['price'] as num?)?.toDouble();

Map<String, dynamic> _$AppointmentTypeToJson(AppointmentType instance) =>
    <String, dynamic>{
      'appointmentTypeId': instance.appointmentTypeId,
      'name': instance.name,
      'price': instance.price,
    };
