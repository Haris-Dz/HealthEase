import 'package:healthease_desktop/models/patient.dart';
import 'package:json_annotation/json_annotation.dart';
part 'app_notification.g.dart';

@JsonSerializable()
class AppNotification {
  int? notificationId;
  int? patientId;
  String? message;
  String? createdAt;
  bool? isRead;
  Patient? patient;

  AppNotification();

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);
}
