// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) =>
    Message()
      ..messageId = (json['messageId'] as num?)?.toInt()
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..userId = (json['userId'] as num?)?.toInt()
      ..senderId = (json['senderId'] as num?)?.toInt()
      ..content = json['content'] as String?
      ..sentAt = json['sentAt'] as String?
      ..senderType = json['senderType'] as String?
      ..isRead = json['isRead'] as bool?
      ..isDeleted = json['isDeleted'] as bool?
      ..user =
          json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>)
      ..patient =
          json['patient'] == null
              ? null
              : Patient.fromJson(json['patient'] as Map<String, dynamic>);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'messageId': instance.messageId,
  'patientId': instance.patientId,
  'userId': instance.userId,
  'senderId': instance.senderId,
  'content': instance.content,
  'sentAt': instance.sentAt,
  'senderType': instance.senderType,
  'isRead': instance.isRead,
  'isDeleted': instance.isDeleted,
  'user': instance.user,
  'patient': instance.patient,
};
