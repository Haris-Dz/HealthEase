// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification()
      ..notificationId = (json['notificationId'] as num?)?.toInt()
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..createdAt = json['createdAt'] as String?
      ..isRead = json['isRead'] as bool?
      ..patient =
          json['patient'] == null
              ? null
              : Patient.fromJson(json['patient'] as Map<String, dynamic>);

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'patientId': instance.patientId,
      'message': instance.message,
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'patient': instance.patient,
    };
