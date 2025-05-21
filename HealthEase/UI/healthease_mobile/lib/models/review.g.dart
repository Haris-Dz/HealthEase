// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) =>
    Review()
      ..reviewId = (json['reviewId'] as num?)?.toInt()
      ..doctorId = (json['doctorId'] as num?)?.toInt()
      ..appointmentId = (json['appointmentId'] as num?)?.toInt()
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..rating = (json['rating'] as num?)?.toDouble()
      ..comment = json['comment'] as String?
      ..createdAt = json['createdAt'] as String?
      ..doctorName = json['doctorName'] as String?
      ..patientName = json['patientName'] as String?
      ..patientProfilePicture = json['patientProfilePicture'] as String?
      ..isDeleted = json['isDeleted'] as bool?;

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'reviewId': instance.reviewId,
  'doctorId': instance.doctorId,
  'appointmentId': instance.appointmentId,
  'patientId': instance.patientId,
  'rating': instance.rating,
  'comment': instance.comment,
  'createdAt': instance.createdAt,
  'doctorName': instance.doctorName,
  'patientName': instance.patientName,
  'patientProfilePicture': instance.patientProfilePicture,
  'isDeleted': instance.isDeleted,
};
