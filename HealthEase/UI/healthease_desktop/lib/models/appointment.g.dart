// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) =>
    Appointment()
      ..appointmentId = (json['appointmentId'] as num?)?.toInt()
      ..appointmentDate = json['appointmentDate'] as String?
      ..appointmentTime = json['appointmentTime'] as String?
      ..status = json['status'] as String?
      ..statusMessage = json['statusMessage'] as String?
      ..note = json['note'] as String?
      ..isPaid = json['isPaid'] as bool?
      ..paymentDate = json['paymentDate'] as String?
      ..doctorId = (json['doctorId'] as num?)?.toInt()
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..appointmentTypeId = (json['appointmentTypeId'] as num?)?.toInt()
      ..doctor =
          json['doctor'] == null
              ? null
              : Doctor.fromJson(json['doctor'] as Map<String, dynamic>)
      ..patient =
          json['patient'] == null
              ? null
              : Patient.fromJson(json['patient'] as Map<String, dynamic>)
      ..appointmentType =
          json['appointmentType'] == null
              ? null
              : AppointmentType.fromJson(
                json['appointmentType'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'appointmentDate': instance.appointmentDate,
      'appointmentTime': instance.appointmentTime,
      'status': instance.status,
      'statusMessage': instance.statusMessage,
      'note': instance.note,
      'isPaid': instance.isPaid,
      'paymentDate': instance.paymentDate,
      'doctorId': instance.doctorId,
      'patientId': instance.patientId,
      'appointmentTypeId': instance.appointmentTypeId,
      'doctor': instance.doctor,
      'patient': instance.patient,
      'appointmentType': instance.appointmentType,
    };
